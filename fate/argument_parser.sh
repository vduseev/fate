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
                ENVIRONMENT="$2"
                shift; shift;;
            --help)
                HELP=YES
                shift;;
            *)
                positional+=("$1")
                shift;;
        esac
    done
    set -- "${positional[@]}"

    if [[ -n $1 ]]; then
        SOURCE_FILE="$1"
    fi
}
