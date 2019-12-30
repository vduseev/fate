LOG_LEVEL=1

declare -A LOG_LEVEL_NAMES
LOG_LEVEL_NAMES[1]="ERROR"
LOG_LEVEL_NAMES[2]="WARNING"
LOG_LEVEL_NAMES[3]="INFO"
LOG_LEVEL_NAMES[4]="DEBUG"

declare -A LOG_LEVEL_MESSAGE
LOG_LEVEL_MESSAGE[1]="[ERROR]  "
LOG_LEVEL_MESSAGE[2]="[WARNING]"
LOG_LEVEL_MESSAGE[3]="[INFO]   "
LOG_LEVEL_MESSAGE[4]="[DEBUG]  "

function log_message() {
    local level="$1"
    local message="$2"

    if [[ $level -le $LOG_LEVEL ]]; then
        echo "[$(date)] ${LOG_LEVEL_MESSAGE[$level]} $message"
    fi
}

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