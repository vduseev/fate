import pathlib

from pyfate.executable import Executable


class Execution:
    def __init__(
        self,
        executable: Executable,
        test_input_file: pathlib.Path,
        test_output_file: pathlib.Path,
    ) -> None:
        self.test_input_file = test_input_file
        self.test_output_file = test_output_file
        self.output = None
        self.executable = executable

    def execute(self):
        pass

    def verify(self):
        pass
