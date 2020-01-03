# Global script variables
INPUT_FILE=""
OUTPUT_FILE=""
ENV=""
HELP=""
STDOUT=""
SOURCE_CODE_FILE=""
VERBOSITY=1

source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/argument_parser.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/discovery.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/orchestration.sh"
source "$FATE_SCRIPT_ROOT_DIR/fate/analyzer.sh"

function main() {
    parse_arguments "$@"
    verify_arguments

    debug "INPUT_FILE:          $INPUT_FILE"
    debug "OUTPUT_FILE:         $OUTPUT_FILE"
    debug "ENV:                 $ENV"
    debug "HELP:                $HELP"
    debug "STDOUT:              $STDOUT"
    debug "SOURCE_CODE_FILE:    $SOURCE_CODE_FILE"
    debug "VERBOSITY:           $VERBOSITY"

    local src_path=$(realpath $SOURCE_CODE_FILE)
    local src_name=$(basename $src_path)
    debug "src_path:            $src_path"
    debug "src_name:            $src_name"

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
    declare -A test_stdouts
    declare -A test_stderrs

    # Find all test pairs
    debug "Discovering test case files..."
    find_test_pairs test_pairs

    # Launch all tests
    debug "Launching all test pairs..."
    launch_tests "$ENV" test_pairs test_runs

    info "Waiting for all containers to finish..."
    wait_for_tests

    # Collect all results
    debug "Collecting results from all containers..."
    collect_results test_pairs test_runs test_stdouts test_stderrs

    # Analyze test runs
    debug "Reporting results..."
    analyze_tests test_pairs test_stdouts test_stderrs

    # Remove containers used to run tests
    debug "Removing containers..."
    cleanup test_runs
}
