import os
import logging

from cleo import Command
from test_executor import TestExecutor


class TestCommand(Command):
    """
    Test an executable solution against a set of input and output test files.

    test
        {executable_path? : Path to the executable solution.}
        {--i|input=* : Input test files.}
        {--o|output=* : Output test files.}
        {--c|config= : Path to the fate.yml config file.}
    """

    def handle(self):
        executable_path = self.argument('executable_path')

        # Check if it's in fact, executable
        if not self.is_executable(executable_path):
            logging.error(
                "{} is not an executable file!".format(executable_path))

        # Look for input and output files in the currect directory
        # - Take everything from the 'input' directory
        # - Take everything from the 'output' directory
        # - Match the similar files using following logic:
        #   a) Input files must start with 'input' and end with a suffix
        #   b) Output files must start with 'output' and end with a suffix
        #   c) Mathcing pairs is done by finding similar suffixes
        input_files = self.get_files_in_dir('input')
        output_files = self.get_files_in_dir('output')

        # test_files is a list of a matching test file pairs
        test_files = []
        for i in input_files:
            _, input_name = os.path.split(i)
            base = os.path.splitext(input_name)
            for o in output_files:
                _, output_name = os.path.split(o)
                name = os.path.splitext(output_name)
                # if mathes, then save both to the list
                if base == name:
                    test_files.append((i, o))

        # Basic test execution
        executor = TestExecutor(executable_path, test_files)
        executor.execute()
        executor.report()

    def is_executable(self, path):
        return os.path.isfile(path) and os.access(path, os.X_OK)

    def get_files_in_dir(self, dir_path):
        # https://stackoverflow.com/questions/11968976/list-files-only-in-the-current-directory
        return [
            f for f in os.listdir(dir_path) if os.path.isfile(
                os.path.join(dir_path, f))
        ]
