from durable.lang import post

# The imports below initialize and start the rules engine
import pyfate.rules.args
import pyfate.rules.flow

def console():
    post("flow", { "e": "console_requested" })

def webservice():
    post("flow", { "e": "webservice_requested" })

if __name__ == "__main__":
    # Launch CLI based flow by default
    console()
