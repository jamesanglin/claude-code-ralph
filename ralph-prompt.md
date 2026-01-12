You are working on a project using the RALPH method - an autonomous development loop.

## Your Task

Implement story ID "{{STORY_ID}}" from prd.json.

## Understanding prd.json

The file contains user stories with this structure:
```json
{
  "stories": [
    {
      "id": "unique-id",
      "title": "Short description",
      "description": "Full requirements",
      "priority": 1,
      "passes": false,
      "steps": [
        { "text": "What to verify", "passed": false }
      ]
    }
  ]
}
```

- `priority`: lower number = higher priority
- `passes`: false = incomplete, true = done
- `steps`: verification checklist - each step must pass before the story passes

## Your Workflow

1. **Read progress.txt** - Learn from previous iterations (what's done, patterns, blockers)

2. **Find your story** - Locate story "{{STORY_ID}}" in prd.json

3. **Implement** - Write the code, tests if appropriate

4. **Verify each step** - Go through the `steps` array one by one:
   - Run/check what the step describes
   - If it passes, set `"passed": true` for that step in prd.json
   - If it fails, fix the code and try again

5. **Mark story complete** - Only set `"passes": true` when ALL steps pass

6. **Append to progress.txt** with this format:
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

## If You're Stuck

1. Document what's blocking you in progress.txt
2. Commit what you have
3. Exit - the next iteration will pick up where you left off
