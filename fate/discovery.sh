source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

function find_test_pairs() {
    local -n pairs=$1

    # If input/output test file pair has been explicitely set in the
    # command line arguments then this is the only test pair we
    # are going to use.
    if [[ -n $INPUT_FILE ]] && [[ -n $OUTPUT_FILE ]]; then
        debug "Using test pair set via arguments: $INPUT_FILE, $OUTPUT_FILE"
        local input_file_abs_path=$(realpath $INPUT_FILE)
        local output_file_abs_path=$(realpath $OUTPUT_FILE)

        pairs["$input_file_abs_path"]="$output_file_abs_path"
    else
        # Otherwise, we examine the current directory context
        debug "Examining current directory '.'"
        find_test_pairs_in_dir pairs "."

        # If nothing has been collected in the current directory,
        # then try luck in the parent directory
        if [[ ${#pairs[@]} -eq 0 ]]; then
            debug "Examining parent directory './..'"
            find_test_pairs_in_dir pairs "./.."

            # Again, if nothing is found, then try the grandparent dir
            if [[ ${#pairs[@]} -eq 0 ]]; then
                debug "Examining grandparent directory './../..'"
                find_test_pairs_in_dir pairs "./../.."
            fi
        fi
    fi

    # Verify that after all these attempts at least some test pairs
    # have been collected.
    if [[ ${#pairs[@]} -eq 0 ]]; then
        error "(discovery.find_test_pairs) unable to find input-output test file pairs"
        exit 1
    else
        debug "${#pairs[@]} test pairs have been found"
    fi
}

function find_test_pairs_in_dir() {
    local -n dirpairs=$1
    local dir="$2"

    # Check specified directory
    # Search for files matching the input*.txt pattern.
    debug "Trying to find input*.txt and output*.txt pairs in '$dir' directory"
    for f in $dir/input*.txt; do
        # Matching output file have exactly the same name
        # but should contain 'output' instead of the 'input'
        local matching_output_file="${f/input/output}"
        # If matching output file exists, then add a test pair
        if [[ -f "$matching_output_file" ]]; then
            local input_file_abs_path=$(realpath $f)
            local output_file_abs_path=$(realpath $matching_output_file)
            dirpairs["$input_file_abs_path"]="$output_file_abs_path"
        fi
    done

    # If nothing has been collected in the specified directory, then
    # check in the ./input/ and ./output/ subdirectories of the 
    # specified directory.
    if [[ ${#dirpairs} -eq 0 ]]; then
        debug "Trying to find $dir/input/input*.txt and $dir/output/output*.txt pairs in '$dir' directory"
        for f in $dir/input/input*.txt; do
            local basename_of_input=$(basename "$f")
            local matching_output_file="${basename_of_input/input/output}"
            if [[ -f "$dir/output/$matching_output_file" ]]; then
                local input_file_abs_path=$(realpath $f)
                local output_file_abs_path=$(realpath "$dir/output/$matching_output_file")
                dirpairs["$input_file_abs_path"]="$output_file_abs_path"
            fi
        done
    fi
}
