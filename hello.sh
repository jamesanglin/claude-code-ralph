#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Color support (can be disabled with --no-color flag)
NO_COLOR=${NO_COLOR:-false}

# Display help information
show_help() {
    echo "Usage: ./hello.sh [OPTIONS]"
    echo ""
    echo "A simple greeting script with color support."
    echo ""
    echo "Options:"
    echo "  --help       Display this help message"
    echo "  --no-color   Disable colored output"
    echo ""
    echo "Functions (when sourced):"
    echo "  greet NAME      Print a greeting with timestamp (green)"
    echo "  farewell NAME   Print a farewell message (yellow)"
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
    fi
done

greet() {
    local name="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local message="Hello, ${name}! [${timestamp}]"
    if [[ "$NO_COLOR" == "true" ]]; then
        echo "$message"
    else
        echo -e "${GREEN}${message}${RESET}"
    fi
}

farewell() {
    local name="$1"
    local message="Goodbye, ${name}! See you soon."
    if [[ "$NO_COLOR" == "true" ]]; then
        echo "$message"
    else
        echo -e "${YELLOW}${message}${RESET}"
    fi
}

echo "Hello, RALPH!"
