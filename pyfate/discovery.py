import os
import glob
import pathlib
import re

from pyfate.executable import Executable

from typing import List, Tuple, Optional, Dict

CaseFileKey = Tuple[str, ...]
CaseFileCollection = Dict[CaseFileKey, pathlib.Path]
CaseCollection = Dict[CaseFileKey, Tuple[pathlib.Path, pathlib.Path]]

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
    def __init__(self) -> None:
        pass

    @staticmethod
    def find_executable(path: str) -> Executable:
        candidates: List[pathlib.Path] = []

        # Check if direct path to executable has been provided
        p = pathlib.Path(path)
        if p.is_file():
            if Executable.is_executable(p):
                candidates.append(p)
            
        # If not than consider it a directory and search there
        elif p.is_dir():
            for f in os.scandir(path):
                if f.is_file() and Executable.is_executable(f):
                    candidates.append(pathlib.Path(f))
            
        if not candidates:
            raise ExecutableNotFound(path=path)

        # Sort candidates based on whatever?

        # Return first in list
        executable = Executable(candidates[0])
        return executable

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
        p = pathlib.Path(path)

        # Verify that given glob pattern is correct
        Discovery.validate_glob_pattern(p)

        # How many wildcards do we have in the filename pattern
        wildcard_count = p.stem.count("*")

        # Create a regex that will capture values in place of wildcards using capture groups
        regex = p.stem.replace(".", "\.").replace("*", "(.*)")

        files: CaseFileCollection = dict()
        for f in pathlib.Path().glob(path):
            # Capture all regex groups in place of the wildcards as parts of the key that will identify
            # this particular file uniquely
            s = re.search(regex, str(f.stem))

            # Build a unique key that will identify this file using captured groups
            key = s.group(*range(1, wildcard_count + 1))

            # Add to collection of discovered files and identify using the unique key
            files[key] = f

        return files

    @staticmethod
    def validate_glob_pattern(path: pathlib.Path) -> None:
        # Raise exception if glob pattern contains nothing but wildcards and placeholders
        gist = path.stem.replace("*", "")
        if not len(gist):
            raise NameNotFoundInGlobPattern(path=str(path))

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
