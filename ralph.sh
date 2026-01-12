#!/bin/bash
#
# ralph.sh - Simplified RALPH loop for Claude Code
#
# Spawns fresh Claude Code sessions to implement features from prd.json.
# Each iteration gets a clean context window.
#
# Usage: ./ralph.sh
#
# Requirements:
#   - jq (for JSON parsing)
#   - claude CLI installed and authenticated
#   - Git repository initialized
#

set -e

# Configuration
MAX_ITERATIONS=${MAX_ITERATIONS:-50}
MAX_NO_PROGRESS=${MAX_NO_PROGRESS:-3}
SLEEP_BETWEEN=${SLEEP_BETWEEN:-2}

# State
no_progress_count=0
iteration=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
  echo -e "${GREEN}[ralph]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[ralph]${NC} $1"
}

error() {
  echo -e "${RED}[ralph]${NC} $1"
}

# Check dependencies
check_deps() {
  if ! command -v jq &> /dev/null; then
    error "jq is required but not installed. Install with: brew install jq"
    exit 1
  fi
  if ! command -v claude &> /dev/null; then
    error "claude CLI is required but not installed."
    exit 1
  fi
  if [ ! -f "prd.json" ]; then
    error "prd.json not found. Create one first."
    exit 1
  fi
}

# Check if all stories have passes: true
all_complete() {
  local incomplete
  incomplete=$(jq '[.stories[] | select(.passes == false)] | length' prd.json)
  [ "$incomplete" -eq 0 ]
}

# Get count of incomplete stories
incomplete_count() {
  jq '[.stories[] | select(.passes == false)] | length' prd.json
}

# Get next incomplete story (highest priority = lowest number)
next_story() {
  jq -r '.stories | map(select(.passes == false)) | sort_by(.priority) | .[0] | "\(.title) (priority \(.priority))"' prd.json
}

# Get next story ID
next_story_id() {
  jq -r '.stories | map(select(.passes == false)) | sort_by(.priority) | .[0].id' prd.json
}

# Build the prompt for Claude
build_prompt() {
  local story_id
  story_id=$(next_story_id)

  cat <<EOF
You are working on a project using the RALPH method.

## Your Task
Read prd.json and find story ID "$story_id". Implement ONLY that story.

## Instructions
1. Read CLAUDE.md for project context and conventions
2. Read progress.txt for learnings from previous iterations
3. Implement the story - write the code, tests if appropriate
4. When the story is complete and working:
   - Update prd.json: set "passes": true for story "$story_id"
   - Append to progress.txt with what you learned
   - Commit all changes with a descriptive message
5. If you get stuck or blocked:
   - Document the blocker in progress.txt
   - Still commit what you have
   - The next iteration will try to resolve it

## Important
- Focus on ONE story only
- Make small, working increments
- Commit your work before finishing
EOF
}

# Main loop
main() {
  check_deps

  log "Starting RALPH loop"
  log "Max iterations: $MAX_ITERATIONS"
  log "Incomplete stories: $(incomplete_count)"

  # Create progress.txt if it doesn't exist
  if [ ! -f "progress.txt" ]; then
    echo "# RALPH Progress Log" > progress.txt
    echo "" >> progress.txt
  fi

  while ! all_complete && [ $iteration -lt $MAX_ITERATIONS ]; do
    iteration=$((iteration + 1))

    echo ""
    log "=========================================="
    log "Iteration $iteration / $MAX_ITERATIONS"
    log "Working on: $(next_story)"
    log "Remaining: $(incomplete_count) stories"
    log "=========================================="

    # Record git state before
    before_hash=$(git rev-parse HEAD 2>/dev/null || echo "none")
    before_prd=$(cat prd.json)

    # Run Claude with the prompt
    # --print: output conversation to stdout
    # --yes: auto-accept tool calls (be careful with this!)
    log "Spawning fresh Claude instance..."

    if claude --print "$(build_prompt)"; then
      log "Claude session completed"
    else
      warn "Claude session exited with error"
    fi

    # Check for progress
    after_hash=$(git rev-parse HEAD 2>/dev/null || echo "none")
    after_prd=$(cat prd.json)

    # Detect progress via commits or prd.json changes
    if [ "$before_hash" != "$after_hash" ]; then
      log "Progress: new commit(s) made"
      no_progress_count=0
    elif [ "$before_prd" != "$after_prd" ]; then
      log "Progress: prd.json updated"
      no_progress_count=0
    else
      no_progress_count=$((no_progress_count + 1))
      warn "No progress detected ($no_progress_count/$MAX_NO_PROGRESS)"

      if [ $no_progress_count -ge $MAX_NO_PROGRESS ]; then
        error "Stuck after $MAX_NO_PROGRESS iterations with no progress"
        error "Check progress.txt for blockers"
        exit 1
      fi
    fi

    # Brief pause between iterations
    sleep "$SLEEP_BETWEEN"
  done

  echo ""
  if all_complete; then
    log "=========================================="
    log "ALL STORIES COMPLETE!"
    log "Total iterations: $iteration"
    log "=========================================="
  else
    warn "Reached max iterations ($MAX_ITERATIONS)"
    warn "$(incomplete_count) stories remaining"
  fi
}

main "$@"
