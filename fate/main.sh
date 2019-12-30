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

    # Form a collection of input/output file pairs
    # 1. For the time being lets assume we have only one pair
    #    dictated by the input and ouput arguments
    local input_file_abs_path=$(realpath $INPUT_FILE)
    local input_file_basename=$(basename $INPUT_FILE)
    local output_file_abs_path=$(realpath $OUTPUT_FILE)
    local source_code_file_abs_path=$(realpath $SOURCE_CODE_FILE)
    local source_code_file_basename=$(basename $SOURCE_CODE_FILE)

    # For each pair in the collection invoke a docker container based
    # on certain image and apply corresponding cpu/mem/time restrictions.
    local image=$(get_env_image_name $ENV)
    local cmd=$(
        get_env_execution_cmd \
            $ENV \
            $source_code_file_basename \
            $input_file_basename
    )

    execute_in_docker_container \
        "$image" \
        "$cmd" \
        "$source_code_file_abs_path" \
        "$input_file_abs_path"

    # For each pair of input output run a diff between the desired output
    # and the actual output of the algorithm.

    # Exit with correct code and logging.
    #
}
