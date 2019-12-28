#!/usr/bin/env bash

# Stores directory where root fate scripts resides
FATE_SCRIPT_ROOT_DIR=""

function determine_script_location_dir() {
    local source="${BASH_SOURCE[0]}"
    # resolve $source until the file is no longer a symlink
    while [ -h "$source" ]; do
        FATE_SCRIPT_ROOT_DIR="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
        source="$(readlink "$source")"
        # if $source was a relative symlink, we need to resolve it relative
        # to the path where the symlink file was located
        [[ $source != /* ]] && source="$FATE_SCRIPT_ROOT_DIR/$source"
    done
    FATE_SCRIPT_ROOT_DIR="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
}

# Function call determines where exactly the fate.sh is located
# despite being symlinked
determine_script_location_dir

# Import main logic
source "$FATE_SCRIPT_ROOT_DIR/fate/main.sh"

main "$@"
