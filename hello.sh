#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Color support (can be disabled with --no-color flag)
NO_COLOR=${NO_COLOR:-false}

# Logging support (enabled with --log flag)
LOG_ENABLED=${LOG_ENABLED:-false}
LOG_FILE="hello.log"

# Version
VERSION="1.0.0"

# Display help information
show_help() {
    echo "Usage: ./hello.sh [OPTIONS]"
    echo ""
    echo "A simple greeting script with color support."
    echo ""
    echo "Options:"
    echo "  --help       Display this help message"
    echo "  --version    Display version information"
    echo "  --no-color   Disable colored output"
    echo "  --log        Log greetings and farewells to hello.log"
    echo ""
    echo "Functions (when sourced):"
    echo "  greet NAME [OPTIONS]        Print a greeting with timestamp (green)"
    echo "  farewell NAME [OPTIONS]     Print a farewell message (yellow)"
    echo ""
    echo "Function Options:"
    echo "  --count N    Repeat the greeting or farewell N times (default: 1)"
    echo "  --uppercase  Output the message in all uppercase letters"
    echo ""
    echo "Examples:"
    echo "  ./hello.sh                  # Print 'Hello, RALPH!'"
    echo "  ./hello.sh --help           # Show this help"
    echo "  source hello.sh && greet 'World'    # Greet World"
    echo "  source hello.sh && farewell 'Alice' # Say goodbye to Alice"
}

# Parse arguments for flags
for arg in "$@"; do
    if [[ "$arg" == "--no-color" ]]; then
        NO_COLOR=true
    elif [[ "$arg" == "--help" ]]; then
        show_help
        exit 0
    elif [[ "$arg" == "--version" ]]; then
        echo "hello.sh version ${VERSION}"
        exit 0
    elif [[ "$arg" == "--log" ]]; then
        LOG_ENABLED=true
    fi
done

# Log a message to the log file
log_message() {
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[${timestamp}] ${message}" >> "$LOG_FILE"
}

greet() {
    local name="$1"
    shift
    local count=1
    local uppercase=false
    # Parse function arguments for --count and --uppercase
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --count)
                count="$2"
                shift 2
                ;;
            --uppercase)
                uppercase=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    local i
    for ((i=1; i<=count; i++)); do
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        local message="Hello, ${name}! [${timestamp}]"
        if [[ "$uppercase" == "true" ]]; then
            message=$(echo "$message" | tr '[:lower:]' '[:upper:]')
        fi
        if [[ "$NO_COLOR" == "true" ]]; then
            echo "$message"
        else
            echo -e "${GREEN}${message}${RESET}"
        fi
        if [[ "$LOG_ENABLED" == "true" ]]; then
            log_message "GREET: Hello, ${name}!"
        fi
    done
}

farewell() {
    local name="$1"
    shift
    local count=1
    local uppercase=false
    # Parse function arguments for --count and --uppercase
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --count)
                count="$2"
                shift 2
                ;;
            --uppercase)
                uppercase=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    local i
    for ((i=1; i<=count; i++)); do
        local message="Goodbye, ${name}! See you soon."
        if [[ "$uppercase" == "true" ]]; then
            message=$(echo "$message" | tr '[:lower:]' '[:upper:]')
        fi
        if [[ "$NO_COLOR" == "true" ]]; then
            echo "$message"
        else
            echo -e "${YELLOW}${message}${RESET}"
        fi
        if [[ "$LOG_ENABLED" == "true" ]]; then
            log_message "FAREWELL: Goodbye, ${name}!"
        fi
    done
}

echo "Hello, RALPH!"
