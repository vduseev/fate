source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

DOCKER_HUB_USERNAME="fate"

function get_env_image_name() {
    # Language spec, i.e. python3, python2, bash, cpp14, etc.
    local lang="$1"

    if [[ -z $1 ]]; then
        error "(get_env_image_name) missing argument 1: language spec name"
        exit 1
    fi

    printf "$DOCKER_HUB_USERNAME/$lang"
}

function get_env_execution_cmd() {
    # Language spec, i.e. python3, python2, bash, cpp14, etc.
    local lang="$1"
    # Name of source code file
    local source_code_filename="$2"
    # Name of input file containing testcase data
    local input_filename="$3"

    # Argument verification
    if [[ -z $1 ]]; then
        error "(get_env_execution_cmd) missing argument 1: language spec name"
        exit 1
    fi
    if [[ -z $2 ]]; then
        error "(get_env_execution_cmd) missing argument 2: source code file name"
        exit 1
    fi
    if [[ -z $3 ]]; then
        error "(get_env_execution_cmd) missing argument 3: input file name"
        exit 1
    fi

    # Return a proper algorithm compilation/invokation command for the
    # chosen environment.
    # That command will be executed in a container.
    case $lang in
        python3)
            printf "python3 $source_code_filename < input/$input_filename";;
        bash)
            printf "bash $source_code_filename";;
        *)
            error "Environment for $lang does not exist"
            exit 1;;
    esac
}
