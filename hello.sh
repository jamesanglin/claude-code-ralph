#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Color support (can be disabled with --no-color flag)
NO_COLOR=${NO_COLOR:-false}

# Parse arguments for --no-color flag
for arg in "$@"; do
    if [[ "$arg" == "--no-color" ]]; then
        NO_COLOR=true
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
