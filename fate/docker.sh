source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/environment.sh"

CONTAINER_SOURCE_DIR="/source/"
CONTAINER_INPUT_DIR="/input/"
CONTAINER_OUTPUT_PATH="/tmp/result.txt"

function launch_container() {
    # Language spec
    # e.g. python3
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

    # Docker run in a detached mode prints the container identification number
    # to stdout and then proceedes with running the actual process in the
    # container in the background.
    local cid=$(
        { 
            docker run                                                                  \
                --detach                                                                \
                --mount "type=bind,src=$source_code_file_dir,dst=$CONTAINER_SOURCE_DIR" \
                --mount "type=bind,src=$input_file_dir,dst=$CONTAINER_INPUT_DIR"        \
                --env "OUTPUT_PATH=$CONTAINER_OUTPUT_PATH"                              \
                --workdir "$CONTAINER_SOURCE_DIR"                                       \
                "$image" bash -c "$cmd"; 
        }
    )

    printf "$cid"
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

function remove_container() {
    local cid="$1"

    docker rm --force --volumes "$cid" &> /dev/null
}
