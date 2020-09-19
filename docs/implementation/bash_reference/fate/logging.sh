source "$FATE_SCRIPT_ROOT_DIR/fate/error.sh"

VERBOSITY=1

declare -A LOG_LEVEL_NAMES
LOG_LEVEL_NAMES[0]="FATAL"
LOG_LEVEL_NAMES[1]="ERROR"
LOG_LEVEL_NAMES[2]="WARNING"
LOG_LEVEL_NAMES[3]="INFO"
LOG_LEVEL_NAMES[4]="DEBUG"

declare -A LOG_LEVEL_MESSAGE
LOG_LEVEL_MESSAGE[0]="[FATAL]  "
LOG_LEVEL_MESSAGE[1]="[ERROR]  "
LOG_LEVEL_MESSAGE[2]="[WARNING]"
LOG_LEVEL_MESSAGE[3]="[INFO]   "
LOG_LEVEL_MESSAGE[4]="[DEBUG]  "

function debug() {    # LEVEL 4
    local message="$1"
    log_message 4 "$message"
}

function info() {     # LEVEL 3
    local message="$1"
    log_message 3 "$message"
}

function warning() {  # LEVEL 2
    local message="$1"
    log_message 2 "$message"
}

function error() {    # LEVEL 1
    local message="$1"
    log_message 1 "$message"
}

function fatal() {
    local message="$1"

    # Logic to obtain calling module name
    local module_path="${BASH_SOURCE[1]}"
    local module_basename=$(basename $module_path)
    local module_name="${module_basename%.sh}"

    local function_name="${FUNCNAME[1]}"
    local line_number="${BASH_LINENO[0]}"

    log_message 0 "(${module_name}.${function_name}) at line ${line_number}: ${message}"  

    die
}

function log_message() {
    local level="$1"
    local message="$2"

    if [[ $level -le $VERBOSITY ]]; then
        # Form a string to print
        local log_line="[$(date)] ${LOG_LEVEL_MESSAGE[$level]} $message"
        # Print to stderr
        1>&2 printf '%s\n' "$log_line"
        #printf '%s\n' "$log_line"
    fi
}
