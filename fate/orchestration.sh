source "$FATE_SCRIPT_ROOT_DIR/fate/error.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/docker.sh"

DEBUGGER_ATTACH_IP="127.0.0.1"
DEBUGGER_ATTACH_PORT="$CONTAINER_HOST_MAPPED_PORT"
CONTAINER_RUN_TIME_LIMIT=10

function launch_tests() {
    local lang_spec="$1"
    local -n pairs=$2
    local -n runs=$3
    local -n times=$4

    local counter=1
    for i in "${!pairs[@]}"; do
        info "Launching test pair $counter..."

        # Launch docker container in the background
        local start_time=$(date +%s)
        local cid=$(
            launch_container        \
                "$lang_spec"        \
                "$src_path"         \
                "$i"                )
        runs["$i"]="$cid"
        times["$i"]="$start_time"
        debug "cid: $cid"

        if [[ -n $DEBUG ]]; then
            debug "Entering debug mode for test pair $counter..."
            attach_to_debugger "4444"
        fi

        counter=$((counter+1))
    done
}

function wait_for_tests() {
    local -n runs=$1
    local -n times=$2

    local wait_start=$(date +%s)
    # Run while there are still containers running
    while [[ ${#times[@]} -gt 0 ]]; do
        current_time=$(date +%s)

        for i in "${!times[@]}"; do
            local cid="${runs[$i]}"
            local status=$(get_container_status "$cid")

            # Possible values for container status:
            # One of created, restarting, running, removing, paused, exited, or dead.
            # See https://docs.docker.com/engine/reference/commandline/ps/
            if [[ "$status" == "created"  || \
                  "$status" == "removing" || \
                  "$status" == "exited"   || \
                  "$status" == "dead" ]]; then
                # If container status is created (but not started), removing, exited, or dead, then
                # we remove it from the watchlist.
                unset times["$i"]
            else
                # If container still tries to do soemthing, then we measure its runtime
                # and forcibly stop it in case it exceeds the allowed limit.
                # And then still wait for it to reach the removing, exited, or dead
                # state.
                local start_time="${times[$i]}"
                local run_time=$((current_time - start_time))
                if [[ $run_time -ge $CONTAINER_RUN_TIME_LIMIT ]]; then
                    kill_container "$cid"
                    error "Stopping container running $(basename $i) for exceeding the time limit"
                fi
            fi
        done

        debug "Waiting for containers to finish: $((current_time - wait_start))s passed"

        # Only do this check every 1 second
        sleep 1
    done
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
