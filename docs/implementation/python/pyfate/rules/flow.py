import sys

from durable.lang import *
from loguru import logger


with flowchart("flow"):

    with stage("initial"):
        @run
        def on_initial(c):
            logger.debug("On stage: initial")

        to("console").when_all(m.e == "console_requested")
        to("webservice").when_all(m.e == "webservice_requested")

    with stage("console"):
        @run
        def on_console(c):
            logger.debug("On stage: console")

            # Launch console application and parse command line arguments
            from pyfate.cli.app import App
            cliapp = App()
            cliapp.run()

        to("configuration_collection").when_all(m.e == "arguments_collected", m.e != "argument_exception")
        to("fatal_exception").when_all(m.e == "argument_exception")

    with stage("webservice"):
        @run
        def on_webservice(c):
            logger.debug("On stage: webservice")

    with stage("configuration_collection"):
        @run
        def on_configuration_collection(c):
            logger.debug("Handling configuration collection")

    with stage("fatal_exception"):
        @run
        def on_fatal_exception(c):
            logger.debug("On stage: fatal_exception")
            logger.error(f"Fatal exception: {c.m.message}")
