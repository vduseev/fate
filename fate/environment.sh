source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/docker.sh"

function determine_environment() {
    local source_file_path="$1"
    ENVIRONMENT="python3"
}

function execute_in_environment() {
    local environment="$1"

    case $environment in
        python3)
            local output=$(execute_in_docker "image" "input")
            ;;
    esac
}
