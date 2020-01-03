source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

# Parse arguments
function parse_arguments() {
    local positional=()
    while [[ $# -gt 0 ]]; do
        local key="$1"

        case $key in
            -i|--input)
                INPUT_FILE="$2"
                shift; shift;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift; shift;;
            -e|--env|--environment)
                ENV="$2"
                shift; shift;;
            -v|--verbosity)
                VERBOSITY="$2"
                shift; shift;;
            --help)
                HELP=YES
                shift;;
            --stdout)
                STDOUT=YES
                shift;;
            *)
                positional+=("$1")
                shift;;
        esac
    done
    set -- "${positional[@]}"

    if [[ -n $1 ]]; then
        SOURCE_CODE_FILE="$1"
    fi
}

function verify_arguments() {
    # Verify source code file path is present
    if [[ -z $SOURCE_CODE_FILE ]]; then
        error "(argument_parser.verify_arguments) missing argument: source code file path"
        exit 1
    fi

    # Verify that if input and output options are only present simultaneously
    if [[ -n $INPUT_FILE ]] && [[ -z $OUTPUT_FILE ]]; then
        error "(argument_parser.verify_arguments) missing argument: input file path is present but output file path is missing"
        exit 1
    fi
    if [[ -z $INPUT_FILE ]] && [[ -n $OUTPUT_FILE ]]; then
        error "(argument_parser.verify_arguments) missing argument: output file path is present but input file path is missing"
        exit 1
    fi

    # Verify that verbosity is within allowed limits
    if [[ $VERBOSITY -lt 1 ]] || [[ $VERBOSITY -gt 4 ]]; then
        error "(argument_parser.verify_arguments) wrong value: verbosity value must be between 1 (default) and 4"
        exit 1
    fi
}
