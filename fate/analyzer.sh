source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

function analyze_tests() {
    local -n pairs=$1
    local -n stdouts=$2
    local -n stderrs=$3

    local pass_counter=0
    for i in "${!pairs[@]}"; do
        local expected=$(cat "${pairs[$i]}")
        local actual="${stdouts[$i]}"
        local errors="${stderrs[$i]}"

        local test_name="$(basename $i)"

        if [[ -n $errors ]]; then
            error "Test results for $test_name: errors"
            print_errors "$errors"
            print_input "$i"
            print_output "$actual"
            print_expected "${pairs[$i]}"
        elif [[ -z $actual ]]; then
            error "Test results for $test_name: empty output"
            print_input "$i"
            print_expected "${pairs[$i]}"
        elif check_output_is_same "$expected" "$actual"; then
            info "Test results for $test_name: successful!"
            pass_counter=$((pass_counter+1))
        else
            error "Test results for $test_name: output don't match"
            print_input "$i"
            print_output "$actual"
            print_expected "${pairs[$i]}"
            print_diff "$expected" "$actual"
        fi
    done

    info "$pass_counter/${#pairs[@]} tests passed, $((${#pairs[@]} - $pass_counter)) tests failed"
}

function check_output_is_same() {
    local expected="$1"
    local actual="$2"

    local result=$(diff -q --strip-trailing-cr <(printf "$expected\n") <(printf "$actual\n"))

    if [[ -z $result ]]; then
        return 0    
    else
        return 1
    fi
}

function print_input() {
    local filepath="$1"

    error "Input:"
    printf "$(cat $i)\n"
}

function print_output() {
    local actual_output="$1"

    error "Your output:"
    printf "$actual_output\n"
}

function print_expected() {
    local filepath="$1"

    error "Expected output:"
    printf "$(cat $filepath)\n"
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
    diff -u --strip-trailing-cr <(printf "$expected\n") <(printf "$actual\n")
}
