source "$FATE_SCRIPT_ROOT_DIR/fate/logging.sh"

FATE_STATE_DIR=".fate"
FATE_LAUNCH_STATE_DIR=".fate/launches"

function cleanup_state() {
    ensure_state_dirs_exist
    cleanup_state_dirs
}

function ensure_state_dirs_exist() {
    if [[ ! -d "$FATE_STATE_DIR" || ! -d "$FATE_LAUNCH_STATE_DIR" ]]; then
        create_state_dirs
    fi
}

function create_state_dirs() {
    mkdir -p "$FATE_STATE_DIR"
    mkdir -p "$FATE_LAUNCH_STATE_DIR"
}

function cleanup_state_dirs() {
    rm -f "$FATE_LAUNCH_STATE_DIR/*"
}