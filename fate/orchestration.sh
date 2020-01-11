source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/docker.sh"

DEBUGGER_ATTACH_IP="127.0.0.1"
DEBUGGER_ATTACH_PORT="$CONTAINER_HOST_MAPPED_PORT"

function launch_tests() {
    local lang_spec="$1"
    local -n pairs=$2
    local -n runs=$3

    local counter=1
    for i in "${!pairs[@]}"; do
        info "Launching test pair $counter..."

        # Launch docker container in the background
        local cid=$(
            launch_container        \
                "$lang_spec"        \
                "$src_path"         \
                "$i"                )
        runs["$i"]="$cid"
        debug "cid: $cid"

        if [[ -n $DEBUG ]]; then
            debug "Entering debug mode for test pair $counter..."
            attach_to_debugger "4444"
        fi

        counter=$((counter+1))
    done
}

function wait_for_tests() {
    sleep 1
}

function collect_results() {
    local -n pairs=$1
    local -n runs=$2
    local -n runs_result=$3
    local -n runs_stdout=$4
    local -n runs_stderr=$5

    for i in "${!pairs[@]}"; do
        local cid="${runs[$i]}"
        local stdout=$(retrieve_stdout_from_container "$cid")
        local result=""
        if [[ -n $STDOUT ]]; then
            result="$stdout"
        else
            result=$(retrieve_output_path_from_container "$cid")
        fi
        local stderr=$(retrieve_stderr_from_container "$cid")
        runs_result["$i"]="$result"
        runs_stdout["$i"]="$stdout"
        runs_stderr["$i"]="$stderr"
    done
}

function cleanup() {
    local -n runs=$1

    for cid in "${runs[@]}"; do
        debug "Removing $cid..."
        remove_container "$cid"
    done
}

function attach_to_debugger() {
    local port="$1"

    debug "Trying nc..."
    sleep 3
    nc "$DEBUGGER_ATTACH_IP" "$DEBUGGER_ATTACH_PORT"
    debug "NC return: $?"
}
