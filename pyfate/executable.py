import os


class Executable:
    def __init__(self, path):
        self.path = path

    @staticmethod
    def is_executable(path):
        return Executable.__is_executable_file(path) \
            or Executable.__is_shebang_file(path) \
            or Executable.__is_code_file(path)

    @staticmethod
    def __is_executable_file(path):
        # Check if file has an executable attribute
        return os.access(path, os.X_OK)

    @staticmethod
    def __is_shebang_file(path):
        # Check whether given file contains a shebang line
        first_line = path.read_text()
        if first_line.find("#!") == 0:
            return True
        return False

    @staticmethod
    def __is_code_file(path):
        # Check whether given file is written in one of the known languages
        return False
