import subprocess
import pytest


class TestExecutor():
    """

    """

    def __init__(self, executable_path, test_files):
        self.executable_path = executable_path
        self.test_files = test_files

    def execute():
        pass

    def __execute_single_test(self, test_pair):
        input_file, output_file = test_pair

        # Feed input file to the executable
        with open(input_file) as i:
            run = subprocess.Popen(
                [self.executable_path],
                stdin=i,
                stdout=subprocess.PIPE)

            # Read the output of execution
            answer = run.communicate()[0].decode('ascii').rstrip('\n')

        with open(output_file) as o:
            correct_answer = o.read().rstrip('\n')

        

    def report():
        pass
