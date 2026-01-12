# Project Instructions

This project uses the **RALPH method** - an autonomous development loop that spawns fresh Claude sessions to implement features.

## How RALPH Works

1. You are one iteration in a loop of many
2. Each iteration gets a fresh context window
3. Your job: implement ONE story from `prd.json`
4. Mark it complete, commit, and exit

## Files You Must Know

### `prd.json`
Contains user stories. Each story has:
- `id`: unique identifier
- `title`: short description
- `description`: full requirements
- `priority`: lower = higher priority
- `passes`: false = incomplete, true = done
- `steps`: array of verification steps

Each step has:
- `text`: what to verify
- `passed`: false = not verified, true = verified

**Your task:**
1. Implement stories where `passes: false`
2. Verify EACH step in the `steps` array
3. Mark each step `"passed": true` as you verify it
4. Only set `"passes": true` on the story when ALL steps pass

### `progress.txt`
Accumulated learnings from all iterations. Read this first to understand:
- What's been done
- What patterns/conventions are established
- Any blockers or gotchas

**Your task:** Append your learnings when you finish.

### `ralph.sh`
The loop script that spawned you. Don't modify it.

## Your Workflow

1. **Read** `progress.txt` - learn from previous iterations
2. **Read** `prd.json` - find your assigned story
3. **Implement** - write code, tests if needed
4. **Verify each step** - go through the `steps` array one by one:
   - Run/check what the step describes
   - If it passes, set `"passed": true` for that step
   - If it fails, fix the code and try again
5. **Update** `prd.json`:
   - Mark each verified step as `"passed": true`
   - Only set story `"passes": true` when ALL steps pass
6. **Append** to `progress.txt`:
   ```
   ## Iteration [date/time]
   - Completed: [story title]
   - Steps verified: [list each step]
   - Learned: [key insights]
   - Files changed: [list]
   ```
7. **Commit** all changes with a descriptive message

## Rules

- **ONE story per iteration** - don't try to do multiple
- **Small commits** - commit working increments
- **Document blockers** - if stuck, write it in progress.txt
- **Don't break existing code** - read progress.txt for context
- **Always commit** - even partial progress is progress

## When You're Stuck

If you can't complete a story:
1. Document what's blocking you in progress.txt
2. Commit what you have
3. The next iteration will pick up where you left off

## Example progress.txt Entry

```
## Iteration 2024-01-11 10:30
- Completed: Story 2 - Add greeting function
- Steps verified:
  - [x] greet() function exists in hello.sh
  - [x] greet 'World' outputs 'Hello, World!'
  - [x] greet 'Alice' outputs 'Hello, Alice!'
- Learned: Using bash functions with local variables
- Files changed: hello.sh
- Notes: Added greet() function, tested with various names
```
