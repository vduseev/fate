from cleo import Application

from pyfate.cli.commands.run import RunCommand
from pyfate.cli.commands.configure import ConfigureCommand
from pyfate.cli.commands.discover import DiscoverCommand


def run() -> None:
    application = Application()
    application.add(RunCommand())
    application.add(ConfigureCommand())
    application.add(DiscoverCommand())
    application.run()

if __name__ == "__main__":
    run()
