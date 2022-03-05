from durable.lang import *
from loguru import logger


with ruleset("args"):

    @when_all((m.output_path != None), (m.input_path == None), m.arguments_collected == True)
    def r1(c):
        desc = "'input-path' must be specified when 'output-path' is specified"

        logger.debug(f"'args' ruleset triggered: {desc}")
        post("flow", {
            "e": "argument_exception",
            "message": desc
        })

    @when_all(m.arguments_collected == True)
    def r2(c):
        desc = "notify 'flow' flowchart when all arguments were collected"

        logger.debug(f"'args' ruleset triggered: {desc}")
        post("flow", {
            "e": "arguments_collected"
        })
