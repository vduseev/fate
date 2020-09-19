from cleo import Command
from cleo import argument, option


class RunCommand(Command):
    name = "run"
    description = "Run fate"

    arguments = [argument("path", "The directory in which to run fate or path to executable", optional=True)]
    options = [
        option("output-type", description="Instruct executable to print output to file or to stdout", value_required=True),
        option("execution-environment", description="Which environment to use to run the solution", value_required=True),
        option("docker", description="Use docker to run the solution", flag=True),
        option("debug", description="Run solution in debug mode", flag=True),
        option("input-file", description="Path input file of the test case", value_required=True),
        option("output-file", description="Path to output file of the test case", value_required=True),
        option("test-case-name", description="Name of the test case to execute", value_required=True),
        option("concurrent", description="Run tests concurrently (optionally specify number of concurent executions)", value_required=False),
        option("memory-limit", description="Impose a memory limit (MB) when running in docker container", value_required=True),
        option("time-limit", description="Impose a time limit (ms) for each execution", value_required=True)
    ]

    def handle(self) -> None:
        pass
