# Global script variables
INPUT_FILE=""
OUTPUT_FILE=""
ENV=""
HELP=""
SOURCE_CODE_FILE=""
VERBOSITY=1

source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/argument_parser.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/environment.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/docker.sh"

function main() {
    parse_arguments "$@"

    debug "Arguments..."
    debug "INPUT_FILE:          $INPUT_FILE"
    debug "OUTPUT_FILE:         $OUTPUT_FILE"
    debug "ENV:                 $ENV"
    debug "HELP:                $HELP"
    debug "SOURCE_CODE_FILE:    $SOURCE_CODE_FILE"
    debug "VERBOSITY:           $VERBOSITY"

    local src_path=$(realpath $SOURCE_CODE_FILE)
    local src_name=$(basename $src_path)

    debug "src_path:            $src_path"
    debug "src_name:            $src_name"

    # For each pair in the collection invoke a docker container based
    # on certain image and apply corresponding cpu/mem/time restrictions.
    local image=$(get_env_image_name $ENV)

    debug "image:               $image"

    # Test pairs dictionary contains pairs of input and output test
    # files.
    declare -A test_pairs
    # Test runs dictionary contains a container ID for each 
    # corresponding input file. It has the same set of keys as the
    # test pairs dictionary.
    # We need to track test runs and CIDs to be able to spawn a set
    # of detached containers in the background and later collect
    # their outputs using docker log and stored CIDs.
    declare -A test_runs
    # Test results dictionary has the same keys as the test pairs
    # dictionary but stores test results for each key invokation.
    declare -A test_results_stdout
    declare -A test_results_stderr

    # Find all test pairs
    debug "Discovering test case files..."

    # If input/output test file pair has been explicitely set in the
    # command line arguments then this is the only test pair we
    # are going to run.
    if [[ -n $INPUT_FILE ]] && [[ -n $OUTPUT_FILE ]]; then
        local input_file_abs_path=$(realpath $INPUT_FILE)
        local output_file_abs_path=$(realpath $OUTPUT_FILE)

        test_pairs["$input_file_abs_path"]="$output_file_abs_path"
    fi

    local num_test_pairs="${#test_pairs[@]}"

    debug "Number of test pairs: $num_test_pairs"
    for i in "${!test_pairs[@]}"; do
        debug "input:   $(basename $i)"
        debug "output:  $(basename ${test_pairs[$i]})"
    done

    # Launch all tests

    local launch_counter=1

    for i in "${!test_pairs[@]}"; do
        info "Launching test pair $launch_counter..."

        # Build a command to execute in container
        local input_name=$(basename $i)
        local cmd=$(
            get_env_execution_cmd   \
                $ENV                \
                $input_name         \
                $src_name           )
        
        debug "cmd: $cmd"

        # Launch docker container in the background
        local cid=$(
            launch_container        \
                "$image"            \
                "$cmd"              \
                "$src_path"         \
                "$i"                )

        debug "cid: $cid"

        test_runs["$i"]="$cid"

        launch_counter=$((launch_counter+1))
    done

    info "Waiting for all containers to finish..."

    sleep 1

    debug "Collecting results from all containers..."

    # Collect all results
    for i in "${!test_pairs[@]}"; do
        local cid="${test_runs[$i]}"
        local stdout=$(retrieve_stdout_from_container "$cid")
        local stderr=$(retrieve_stderr_from_container "$cid")
        test_results_stdout["$i"]="$stdout"
        test_results_stderr["$i"]="$stderr"
    done

    debug "Reporting results..."

    # Analyze test runs
    for i in "${!test_pairs[@]}"; do
        local expected=$(cat "${test_pairs[$i]}")
        local actual="${test_results_stdout[$i]}"

        #info "Test $i results:"
        #diff -u <(printf "$result") <(printf "$expected")
    done
}
