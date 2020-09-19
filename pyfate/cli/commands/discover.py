from cleo import Command
from cleo import argument, option

from pyfate.discovery import Discovery


class DiscoverCommand(Command):
    name = "discover"
    description = "Test dsicovery functionality"

    arguments = [
        argument("parameter", description="What to discover", optional=False)
    ]
    options = [
        option("input-glob", flag=False),
        option("output-glob", flag=False)
    ]

    def handle(self) -> None:
        parameter = self.argument("parameter")

        if parameter == "tests":
            input_glob = self.option("input-glob")
            output_glob = self.option("output-glob")

            if not input_glob:
                self.line("<error>input-glob option must be specified</error>")
                return

            if not output_glob:
                self.line("<error>output-glob option must be specified</error>")
                return

            tests = Discovery.find_test_cases(input_glob, output_glob)
            self.line(f"len of tests: {len(tests)}")

            for t in tests:
                print(f"key: {t}; input: {tests[t][0]}; output: {tests[t][1]}")
