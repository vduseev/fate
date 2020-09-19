from loguru import logger
from pathlib import Path


class Case(object):
    FILE_NAME_EXTENSION = ".txt"
    INPUT_FILE_NAME_PREFIX = "input"
    OUTPUT_FILE_NAME_PREFIX = "output"

    def __init__(self, input_path_obj, output_path_obj):
        super().__init__()

        self.input_path = input_path_obj.resolve()
        self.output_path = output_path_obj.resolve()

        # Setting case name
        self.name = self.get_case_name_from_input_path(self.input_path)

        # Setting case unique ID
        self.id = self.get_id_from_path(self.input_path)

    @staticmethod
    def from_string_paths(input_path, output_path):
        """Creates new Case object from paths provided.
        """
        input_path_obj = Path(input_path)
        output_path_obj = Path(output_path)

        # Verify that both files exist
        if not Case.is_valid_case_file_path_obj(input_path_obj):
            raise CaseInvalidPathExc(f"Not a valid path: {input_path}")
        if not Case.is_valid_case_file_path_obj(output_path_obj):
            raise CaseInvalidPathExc(f"Not a valid path: {output_path}")

        case = Case(input_path_obj, output_path_obj)
        return case

    @staticmethod
    def get_case_name_from_input_path(path):
        name = path.name
        if name.endswith(Case.FILE_NAME_EXTENSION):
            name = name[: -len(Case.FILE_NAME_EXTENSION)]
        if name.startswith(Case.INPUT_FILE_NAME_PREFIX):
            name = name[len(Case.INPUT_FILE_NAME_PREFIX) :]
        return name

    @staticmethod
    def get_id_from_path(path):
        return str(path)

    @staticmethod
    def is_valid_case_file_path_obj(path):
        if isinstance(path, Path):
            if path.is_file():
                return True
        return False


class CaseInvalidPathExc(Exception):
    pass
