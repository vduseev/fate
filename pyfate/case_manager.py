from loguru import logger
from pathlib import Path
from pyfate.case import Case


class CaseManager(object):
    INPUT_FILES_DIR_NAME = "input"
    OUTPUT_FILES_DIR_NAME = "output"
    DIRS_TO_SEARCH = {
        "current": [
            Path("."),
            Path(INPUT_FILES_DIR_NAME),
            Path(OUTPUT_FILES_DIR_NAME),
        ],
        "parent": [
            Path(".."),
            Path("..", INPUT_FILES_DIR_NAME),
            Path("..", OUTPUT_FILES_DIR_NAME),
        ],
        "grandparent": [
            Path("..", ".."),
            Path("..", "..", INPUT_FILES_DIR_NAME),
            Path("..", "..", OUTPUT_FILES_DIR_NAME),
        ],
    }

    def __init__(self):
        super().__init__()
        self.cases = dict()

    def add_case(self, case) -> None:
        self.cases[case.id] = case

    def collect_cases(self) -> None:
        """Collect cases from surrounding directories.
        """

        self.cases.update(self.collect_cases_from_dirs(self.DIRS_TO_SEARCH["current"]))
        if not self.cases:
            self.cases.update(
                self.collect_cases_from_dirs(self.DIRS_TO_SEARCH["parent"])
            )
            if not self.cases:
                self.cases.update(
                    self.collect_cases_from_dirs(self.DIRS_TO_SEARCH["grandparent"])
                )

    @staticmethod
    def collect_cases_from_dirs(dirs: list) -> dict:
        """Collect cases from provided list of directories.

        Args:
            dirs: List of Path objects representing directories to look into.

        Returns:
            Dict of Case objects with Case's ID as a key.
        """

        cases = dict()
        input_files = dict()
        output_files = dict()

        for dir in dirs:

            # Verify both paths are directories
            if not dir.is_dir():
                continue

            # Collect files matching input pattern
            input_files.update(
                CaseManager.collect_identified_files_by_pattern(
                    dir, Case.INPUT_FILE_NAME_PREFIX, Case.FILE_NAME_EXTENSION
                )
            )

            # Collect files matching output pattern
            output_files.update(
                CaseManager.collect_identified_files_by_pattern(
                    dir, Case.OUTPUT_FILE_NAME_PREFIX, Case.FILE_NAME_EXTENSION
                )
            )

        # Match files in both collections by looking at their IDs
        for id in input_files:

            # If matching output file exists
            if id in output_files:

                # Form a case with this pair
                case = Case(input_files[id], output_files[id])
                cases[case.id] = case

        return cases

    @staticmethod
    def collect_identified_files_by_pattern(
        dir: Path, prefix: str, suffix: str
    ) -> dict:
        """Collect all files matching 'prefix*suffix' pattern in the provided dir.

        Args:
            dir: Directory Path in which the search must be performed.
            prefix: Prefix of file for glob search, e.g. 'input'.
            suffix: Suffix of file for glob search, e.g. '.txt'.
        
        Returns:
            Dict of Path objects represening files matching the provided pattern.
        """

        # Form a pattern
        # Given: prefix = 'input'
        #        suffix = '.txt'
        # Then pattern 'input*.txt' should match 'input00.txt'
        pattern = f"{prefix}*{suffix}"

        # Collect files
        # ID for each file is the part between prefix and suffix
        files = {f.name[len(prefix) : -len(suffix)]: f for f in dir.glob(pattern)}

        return files
