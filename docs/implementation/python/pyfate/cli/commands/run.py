from cleo import Command
from cleo import argument, option

from loguru import logger

from durable.lang import assert_fact
from durable.engine import MessageNotHandledException


class RunCommand(Command):
    name = "run"
    description = "Run fate"

    arguments = [
        argument(
            "path",
            description="The directory in which to run fate or path to executable",
            optional=True,
        )
    ]
    options = [
        option(
            "output",
            description="Instruct executable to print output to file or to stdout",
            flag=False,
            value_required=True,
        ),
        option(
            "environment",
            description="Which environment to use to run the solution",
            flag=False,
            value_required=True,
        ),
        option(
            "docker",
            description="Use docker to run the solution",
            flag=True,
            value_required=False,
        ),
        option(
            "debug",
            description="Run solution in debug mode",
            flag=True,
            value_required=False,
        ),
        option(
            "input-path",
            description="Glob path to input files of the test cases",
            flag=False,
            value_required=True,
            # default=""
        ),
        option(
            "output-path",
            description="Glob path to output files of the test cases",
            flag=False,
            value_required=True,
            # default="",
        ),
        option(
            "case",
            description="Name of the test case to execute",
            flag=False,
            value_required=True,
        ),
        option(
            "parallel",
            description="Run tests concurrently (optionally specify number of concurent executions)",
            flag=True,
            value_required=False,
        ),
        option(
            "memory-limit",
            description="Impose a memory limit (MB) when running in docker container",
            flag=False,
            value_required=True,
        ),
        option(
            "time-limit",
            description="Impose a time limit (ms) for each execution",
            flag=False,
            value_required=True,
        ),
    ]

    def handle(self) -> None:
        # Pass option as facts into the rules engine to evaluate
        options = self.option()
        for o in options:
            # Replace '-' with '_' for compatibility with rules engine
            name = o.replace("-", "_")

            logger.debug(f"Option {name} is set to {options[o]}!")

            try:
                assert_fact("args", {name: options[o]})
            except MessageNotHandledException:
                pass

        # Pass arguments as facts into the rules engine
        path = self.argument("path")
        try:
            assert_fact("args", {"path": path})
        except MessageNotHandledException:
            pass

        # Notify rules engine that all arguments are collected
        assert_fact("args", { "arguments_collected": True })
