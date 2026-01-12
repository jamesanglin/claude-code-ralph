#!/bin/bash

greet() {
    local name="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Hello, ${name}! [${timestamp}]"
}

farewell() {
    local name="$1"
    echo "Goodbye, ${name}! See you soon."
}

echo "Hello, RALPH!"
