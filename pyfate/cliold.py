import click

from loguru import logger
from pyfate.case import Case, CaseInvalidPathExc
from pyfate.case_manager import CaseManager
from pyfate.environment import Environment
from pyfate.launch_suite import LaunchSuite


@click.group()
def cli():
    # CLI command group invoked by default
    pass


@click.command()
def test():
    print("quack")


@click.command()
@click.argument("path", type=click.Path(exists=True))
@click.option("-i", "--input", "input_file_path", type=click.Path(exists=True))
@click.option("-o", "--output", "output_file_path", type=click.Path(exists=True))
@click.option("-e", "--env", "environment_name", type=str, default="python3")
@click.option("--stdout/--to-output-path", default=False)
@click.option("--debug/--no-debug", default=False)
@click.option("--sequential/--no-sequential", default=False)
def run(
    path, input_file_path, output_file_path, environment_name, stdout, debug, sequential
):
    # Build Environment object
    environment = Environment(path, environment_name)

    # Build CaseManager
    case_manager = CaseManager()

    # If both input and output paths have been specified, which means user tried
    # to feed a specific case into the run, then try to initialize a case using them.
    if input_file_path and output_file_path:
        try:
            given_case = Case.from_string_paths(input_file_path, output_file_path)
            case_manager.add_case(given_case)
        except CaseInvalidPathExc as e:
            # UI ERROR
            print(f"Unable to build a case, wrong path {e.msg}")
            return
    # In case a specific case is not provided collect the cases in the surrounding directories
    else:
        case_manager.collect_cases()

    # Pack boolean flags into options object
    options = dict(is_debug=debug, is_stdout=stdout, is_sequential=sequential)

    # DEBUG
    for i, c in enumerate(case_manager.cases.values()):
        print(f"case {i}: {c.input_path.name} {c.output_path.name}")

    # Initialize and launch a case suite
    # launch_suite = LaunchSuite(environment, case_manager, options)


@click.command()
def status():
    pass


@click.command()
def stop():
    pass


cli.add_command(test)
cli.add_command(run)
cli.add_command(status)
cli.add_command(stop)
