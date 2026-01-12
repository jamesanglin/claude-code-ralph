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
    echo "  --count N       Repeat the greeting or farewell N times (default: 1)"
    echo "  --uppercase     Output the message in all uppercase letters"
    echo "  --random        Pick a random greeting style (Hello/Hi/Hey/Greetings)"
    echo "  --quiet         Suppress timestamp output"
    echo "  --delimiter S   Use custom separator S instead of ', ' (default: ', ')"
    echo "  --file FILE     Read names from FILE (one per line) and greet/farewell each"
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
    local name=""
    local count=1
    local uppercase=false
    local random=false
    local quiet=false
    local delimiter=", "
    local file=""
    local remaining_args=()

    # Parse all arguments
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
            --random)
                random=true
                shift
                ;;
            --quiet)
                quiet=true
                shift
                ;;
            --delimiter)
                delimiter="$2"
                shift 2
                ;;
            --file)
                file="$2"
                shift 2
                ;;
            *)
                if [[ -z "$name" ]]; then
                    name="$1"
                fi
                shift
                ;;
        esac
    done

    # If --file is provided, read names from file and greet each
    if [[ -n "$file" ]]; then
        if [[ ! -f "$file" ]]; then
            echo "Error: File '$file' not found" >&2
            return 1
        fi
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ -n "$line" ]]; then
                greet "$line" --count "$count" --delimiter "$delimiter" \
                    $(if [[ "$uppercase" == "true" ]]; then echo "--uppercase"; fi) \
                    $(if [[ "$random" == "true" ]]; then echo "--random"; fi) \
                    $(if [[ "$quiet" == "true" ]]; then echo "--quiet"; fi)
            fi
        done < "$file"
        return 0
    fi

    local i
    for ((i=1; i<=count; i++)); do
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        local greeting="Hello"
        if [[ "$random" == "true" ]]; then
            local greetings=("Hello" "Hi" "Hey" "Greetings")
            greeting="${greetings[$RANDOM % 4]}"
        fi
        local message
        if [[ "$quiet" == "true" ]]; then
            message="${greeting}${delimiter}${name}!"
        else
            message="${greeting}${delimiter}${name}! [${timestamp}]"
        fi
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
    local name=""
    local count=1
    local uppercase=false
    local quiet=false
    local delimiter=", "
    local file=""

    # Parse all arguments
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
            --quiet)
                quiet=true
                shift
                ;;
            --delimiter)
                delimiter="$2"
                shift 2
                ;;
            --file)
                file="$2"
                shift 2
                ;;
            *)
                if [[ -z "$name" ]]; then
                    name="$1"
                fi
                shift
                ;;
        esac
    done

    # If --file is provided, read names from file and farewell each
    if [[ -n "$file" ]]; then
        if [[ ! -f "$file" ]]; then
            echo "Error: File '$file' not found" >&2
            return 1
        fi
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ -n "$line" ]]; then
                farewell "$line" --count "$count" --delimiter "$delimiter" \
                    $(if [[ "$uppercase" == "true" ]]; then echo "--uppercase"; fi) \
                    $(if [[ "$quiet" == "true" ]]; then echo "--quiet"; fi)
            fi
        done < "$file"
        return 0
    fi

    local i
    for ((i=1; i<=count; i++)); do
        local message="Goodbye${delimiter}${name}! See you soon."
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
