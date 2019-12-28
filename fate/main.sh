# Global script variables
INPUT_FILE=""
OUTPUT_FILE=""
ENVIRONMENT=""
HELP=""
SOURCE_FILE=""

source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/argument_parser.sh"

# Form a collection of input/output file pairs
#

# For each pair in the collection invoke a docker container based
# on certain image and apply corresponding cpu/mem/time restrictions.
#

# For each pair of input output run a diff between the desired output
# and the actual output of the algorithm.
#

# Exit with correct code and logging.
#

function main() {
    parse_arguments "$@"

    echo "$INPUT_FILE"
    echo "$OUTPUT_FILE"
    echo "$ENVIRONMENT"
    echo "$SOURCE_FILE"
    echo "$HELP"
}
