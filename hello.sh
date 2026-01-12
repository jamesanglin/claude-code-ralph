#!/bin/bash

greet() {
    local name="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Hello, ${name}! [${timestamp}]"
}

echo "Hello, RALPH!"
