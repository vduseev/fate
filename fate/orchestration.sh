source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/environment.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/docker.sh"

function launch_tests() {
    local -n pairs=$1
    local -n runs=$2

    local counter=1
    for i in "${!pairs[@]}"; do
        info "Launching test pair $counter..."

        # Build a command to execute in container
        local input_name=$(basename $i)
        local cmd=$(
            get_env_execution_cmd   \
                $ENV                \
                $src_name           \
                $input_name         )
        debug "cmd: $cmd"

        # Launch docker container in the background
        local cid=$(
            launch_container        \
                "$image"            \
                "$cmd"              \
                "$src_path"         \
                "$i"                )
        runs["$i"]="$cid"
        debug "cid: $cid"

        counter=$((counter+1))
    done
}

function wait_for_tests() {
    sleep 1
}

function collect_results() {
    local -n pairs=$1
    local -n runs=$2
    local -n runs_stdout=$3
    local -n runs_stderr=$4

    for i in "${!pairs[@]}"; do
        local cid="${runs[$i]}"
        local stdout=$(retrieve_stdout_from_container "$cid")
        local stderr=$(retrieve_stderr_from_container "$cid")
        runs_stdout["$i"]="$stdout"
        runs_stderr["$i"]="$stderr"
    done
}
