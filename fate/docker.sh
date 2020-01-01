source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

CONTAINER_WORKDIR="/execution/"

function launch_container() {
    # Full image name from Docker Hub
    # e.g. fate/python3:latest
    local image_name="$1"
    # Command to execute in the environment to be able
    # to compile (if required) and run the source code file.
    local cmd="$2"
    # Absolute path to the source code file on the host system.
    local source_code_file_abs_path="$3"
    # Absolute path to the test case input file on the host system.
    local input_file_abs_path="$4"

    # Extract directory path part from file locations to mount them into
    # container.
    local source_code_file_dir=$(dirname "$source_code_file_abs_path")
    local input_file_dir=$(dirname "$input_file_abs_path")

    # Docker run in a detached mode prints the container identification number
    # to stdout and then proceedes with running the actual process in the
    # container in the background.
    local cid=$(
        { 
            docker run                                                                  \
                --detach                                                                \
                --mount "type=bind,src=$source_code_file_dir,dst=$CONTAINER_WORKDIR"    \
                --mount "type=bind,src=$input_file_dir,dst=$CONTAINER_WORKDIR/input"    \
                --workdir "$CONTAINER_WORKDIR"                                          \
                "$image_name" bash -c "$cmd"; 
        }
    )

    printf "$cid"
}

function retrieve_stdout_from_container() {
    local cid="$1"

    # Collect only stdout from docker logs
    local stdout=$(docker logs "$cid" 2>/dev/null)
    printf "$stdout"
}

function retrieve_stderr_from_container() {
    local cid="$1"

    # Collect only stderr from docker logs
    local stderr=$(docker logs "$cid" 2>&1 >/dev/null)
    printf "$stderr"
}
