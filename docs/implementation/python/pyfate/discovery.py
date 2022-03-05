import os
import glob
import re

from pathlib import Path

from pygments.lexers import guess_lexer_for_filename
from pygments.util import ClassNotFound

from pyfate.executable import Executable

from typing import List, Tuple, Optional, Dict

CaseFileKey = Tuple[str, ...]
CaseFileCollection = Dict[CaseFileKey, Path]
CaseCollection = Dict[CaseFileKey, Tuple[Path, Path]]

# |---------------|---------------|---------------|-----------------|---------------|
# | Input file    | Output file   | Glob-1        | Glob-2          | Key           |
# |---------------|---------------|---------------|-----------------|---------------|
# | tc0.in        | tc0.out       | tc*.in        | tc*.out         | ("0",)        |
# | tc0           | tc0           | tc*           | tc*             | ("0",)        |
# | input.txt     | output.txt    | input*.txt    | output*.txt     | ("",)         |
# | input01.txt   | output01.txt  | input*.txt    | output*.txt     | ("01",)       |
# | 0case0.txt    | 0output0.txt  | *case*.txt    | *output*.txt    | ("0", "0")    |
# | in0put.txt    | out0put.txt   | in*put.txt    | out*put.txt     | ("0")         |
# |---------------|---------------|---------------|-----------------|---------------|


class Discovery:
    
    @staticmethod
    def find_executables(path: str, guess_code: bool = False) -> List[Path]:
        candidates = Discovery.find_files_by_glob_pattern(path)
        executables = [
            f for f in candidates if Discovery.is_file_executable(f, guess_code)
        ]

        if not executables:
            raise ExecutableNotFound(path=path)
        return executables

    @staticmethod
    def find_test_cases(input_glob_path: str, output_glob_path: str) -> CaseCollection:
        inputs = Discovery.find_files_by_glob_pattern(input_glob_path)
        outputs = Discovery.find_files_by_glob_pattern(output_glob_path)

        cases: CaseCollection = dict()

        # For each input file with unique ID look for the matching output file
        # with the same unique ID and form a test case file pair out of them
        for i in inputs:
            if i in outputs:
                cases[i] = (inputs[i], outputs[i])
        return cases

    @staticmethod
    def find_files_by_glob_pattern(path: str) -> CaseFileCollection:
        p = Path(path)

        # Verify that given glob pattern is correct
        Discovery.validate_glob_pattern(p)

        # How many wildcards do we have in the filename pattern
        wildcard_count = p.stem.count("*")

        # Create a regex that will capture values in place of wildcards using capture groups
        regex = (
            p.stem.replace(".", "\.")  # escape dot in filename
            .replace("(", "\(")  # escape opening bracket
            .replace(")", "\)")  # escape closing bracket
            .replace("*", "(.*)")  # turn glob symbols into capture groups
        )

        files: CaseFileCollection = dict()
        for f in Path().glob(path):
            # Capture all regex groups in place of the wildcards as parts of the key that will identify
            # this particular file uniquely
            s = re.search(regex, str(f.stem))

            # Build a unique key that will identify this file using captured groups
            key = s.group(*range(1, wildcard_count + 1))

            # Add to collection of discovered files and identify using the unique key
            files[key] = f

        return files

    @staticmethod
    def validate_glob_pattern(path: Path) -> None:
        # Raise exception if glob pattern contains nothing but wildcards and placeholders
        gist = path.stem.replace("*", "").replace("?", "")
        if not len(gist):
            raise NameNotFoundInGlobPattern(path=str(path))

    @staticmethod
    def is_file_executable(path: Path, guess_code: bool = False) -> bool:
        def has_x_attr(path: Path) -> bool:
            return os.access(path, os.X_OK)

        def has_shebang_line(path: Path) -> bool:
            return path.read_text().find("#!") == 0

        def has_code_in_known_language(path: Path) -> bool:
            try:
                l = guess_lexer_for_filename(path.name, path.read_text())
                return True
            except ClassNotFound:
                return False

        return path.is_file() and (
            has_x_attr(path)
            or has_shebang_line(path)
            or (has_code_in_known_language(path) if guess_code else False)
        )


class ExecutableNotFound(Exception):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__()
        self.path = kwargs["path"]
        self.message = f"Executable file not found in {self.path}"


class NameNotFoundInGlobPattern(Exception):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__()
        self.path = kwargs["path"]
        self.message = f"File name in glob pattern must contain symbols other than wildcard: {self.path}"
