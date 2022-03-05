from cleo import Application

from pyfate.cli.commands.run import RunCommand
from pyfate.cli.commands.configure import ConfigureCommand
from pyfate.cli.commands.discover import DiscoverCommand


class App:
    def __init__(self):
        self.application = Application()
        self.application.add(RunCommand())
        self.application.add(ConfigureCommand())
        self.application.add(DiscoverCommand())

    def run(self):
        self.application.run()
