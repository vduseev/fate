source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/environment.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/state.sh"

CONTAINER_SOURCE_DIR="/source/"
CONTAINER_INPUT_DIR="/input/"
CONTAINER_OUTPUT_PATH="/tmp/result.txt"
CONTAINER_DEBUGGER_PORT="4444"
CONTAINER_HOST_MAPPED_PORT="4576"

function launch_container() {
    # Language spec, e.g. python3
    local lang_spec="$1"
    # Absolute path to the source code file on the host system.
    local source_code_file_abs_path="$2"
    # Absolute path to the test case input file on the host system.
    local input_file_abs_path="$3"

    # Extract directory path part from file locations to mount them into
    # container.
    local source_code_file_dir=$(dirname "$source_code_file_abs_path")
    local input_file_dir=$(dirname "$input_file_abs_path")

    # Determine which docker image will be used to run the test
    local image=$(get_env_image_name "$lang_spec")

    # Build a command to execute in container
    local src_name=$(basename "$source_code_file_abs_path")
    local input_name=$(basename "$input_file_abs_path")
    local cmd=$(
        get_env_execution_cmd   \
            $ENV                \
            $src_name           \
            $input_name         )

    local launch_errors=$(
        docker run                                                                  \
            --detach                                                                \
            --cidfile "$FATE_LAUNCH_STATE_DIR/$input_name"                          \
            --mount "type=bind,src=$source_code_file_dir,dst=$CONTAINER_SOURCE_DIR" \
            --mount "type=bind,src=$input_file_dir,dst=$CONTAINER_INPUT_DIR"        \
            --expose "$CONTAINER_DEBUGGER_PORT"                                     \
            --publish "$CONTAINER_HOST_MAPPED_PORT:$CONTAINER_DEBUGGER_PORT"        \
            --env "OUTPUT_PATH=$CONTAINER_OUTPUT_PATH"                              \
            --workdir "$CONTAINER_SOURCE_DIR"                                       \
            "$image" bash -c "$cmd" 2>&1 >/dev/null
    )

    if [[ -z $launch_errors ]]; then
        return 0
    else
        error "Unable to properly start container for $input_name"
        error "$launch_errors"
        return 1
    fi
}

function retrieve_stdout_from_container() {
    local cid="$1"

    # Collect only stdout from docker logs
    local stdout=$(docker logs "$cid" 2>/dev/null)
    printf '%s' "$stdout"
}

function retrieve_stderr_from_container() {
    local cid="$1"

    # Collect only stderr from docker logs
    local stderr=$(docker logs "$cid" 2>&1 >/dev/null)
    printf '%s' "$stderr"
}

function retrieve_output_path_from_container() {
    local cid="$1"

    # Read contents of the file under OUTPUT_PATH
    # docker cp copies the file to stdout
    # then it's piped into the tar command
    # that reads from the stdin and outputs to
    # stdout as well.
    local output=$(
        docker cp "$cid:$CONTAINER_OUTPUT_PATH" - | tar -Oxzf - )
    printf '%s' "$output"
}

function get_launched_containers() {
    local -n container_list

    for f in "$FATE_LAUNCH_STATE_DIR"/*; do
        container_list["$f"]=
    done
}

function get_container_status() {
    local cid="$1"

    local status=$(docker inspect --format '{{ .State.Status }}' "$cid")
    printf "$status"
}

function kill_container() {
    local cid="$1"

    docker kill "$cid" &>/dev/null
}

function remove_container() {
    local cid="$1"

    docker rm --force --volumes "$cid" &> /dev/null
}
