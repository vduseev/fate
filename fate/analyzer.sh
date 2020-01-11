source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

function analyze_tests() {
    local -n pairs=$1
    local -n results=$2
    local -n stdouts=$3
    local -n stderrs=$4

    local pass_counter=0
    for i in "${!pairs[@]}"; do
        local expected=$(cat "${pairs[$i]}")
        local actual="${results[$i]}"
        local logs="${stdouts[$i]}"
        local errors="${stderrs[$i]}"

        local test_name="$(basename $i)"

        if [[ -n $errors ]]; then
            error "Test results for $test_name: errors"
            print_errors "$errors"
            print_input "$i"
            print_output "$actual"
            print_expected "${pairs[$i]}"
            print_logs "$logs"
        elif [[ -z $actual ]]; then
            error "Test results for $test_name: empty output"
            print_input "$i"
            print_expected "${pairs[$i]}"
            print_logs "$logs"
        elif check_output_is_same "$expected" "$actual"; then
            info "Test results for $test_name: successful!"
            print_logs "$logs"
            pass_counter=$((pass_counter+1))
        else
            error "Test results for $test_name: output don't match"
            print_input "$i"
            print_output "$actual"
            print_expected "${pairs[$i]}"
            print_diff "$expected" "$actual"
            print_logs "$logs"
        fi
    done

    info "$pass_counter/${#pairs[@]} tests passed, $((${#pairs[@]} - $pass_counter)) tests failed"
}

function check_output_is_same() {
    local expected="$1"
    local actual="$2"

    local result=$(diff -q --strip-trailing-cr <(printf '%s\n' "$expected") <(printf '%s\n' "$actual"))

    if [[ -z $result ]]; then
        return 0    
    else
        return 1
    fi
}

function print_input() {
    local filepath="$1"

    error "Input:"
    printf '%s\n' "$(cat $i)"
}

function print_output() {
    local actual_output="$1"

    error "Your output:"
    printf '%s\n' "$actual_output"
}

function print_expected() {
    local filepath="$1"

    error "Expected output:"
    printf '%s\n' "$(cat $filepath)"
}

function print_errors() {
    local errors="$1"

    error "Errors found:"
    printf "$errors\n"
}

function print_diff() {
    local expected="$1"
    local actual="$2"

    info "Diff (unified, no trailing cr) expected vs. actual:"
    diff -u --strip-trailing-cr <(printf '%s\n' "$expected") <(printf '%s\n' "$actual")
}

function print_logs() {
    local logs="$1"

    # If STDOUT option has been used in arguments then
    # stdout will be used for output and not for logs.
    # In that case - don't report logs.
    if [[ -n $STDOUT ]]; then
        return
    fi

    error "Your stdout logs:"
    printf '%s\n' "$logs"
}
