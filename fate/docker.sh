source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

CONTAINER_WORKDIR="/execution/"

function execute_in_docker_container() {
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

    local cid=$(
        docker run \
            --detach \
            --mount "type=bind,src=$source_code_file_dir,dst=$CONTAINER_WORKDIR" \
            --mount "type=bind,src=$input_file_dir,dst=$CONTAINER_WORKDIR/input" \
            --workdir "$CONTAINER_WORKDIR" \
            "$image_name" \
            bash -c "$cmd"
    )

    debug "cid: $cid"
    
    local results=$(docker logs "$cid")
    debug "results: $results"
}
