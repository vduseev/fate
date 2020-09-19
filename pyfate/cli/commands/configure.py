from cleo import Command
from cleo import argument, option

from pyfate.config.configuration import Configuration


class ConfigureCommand(Command):
    name = "configure"
    description = "Configure the environment"

    arguments = [
        argument("command", description="Which command to execute: show, get, or set", optional=False),
        argument("parameter", description="Which parameter to set or get", optional=True)
    ]
    options = [
        option("user", description="Save configuration file in user's home directory when setting parameter", flag=True),
        option("system", description="Save configuration file in system directory when setting parameters", flag=True)
    ]

    def handle(self) -> None:
        command = self.argument("command")
        parameter = self.argument("parameter")

        if command == "show":
            config = Configuration()
            config.build()
            table = config.as_table()
            self.render_table(*table)

        elif command == "get":
            if not parameter:
                self.line("<error>Parameter name must be specified</error>")

        elif command == "set":
            if not parameter:
                self.line("<error>Parameter name must be specified</error>")

        else:
            self.line(f"<error>Wrong command: {command}</error>")
