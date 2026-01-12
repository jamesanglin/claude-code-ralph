# Claude-Code-Ralph

Autonomous development loop framework for Claude Code.

## What is RALPH?

RALPH enables AI-driven feature implementation through an iterative, story-driven workflow. It spawns fresh Claude Code sessions to implement features defined in a PRD (Product Requirements Document), tracking progress via Git commits and automatically moving to the next story when one completes.

## Requirements

- `jq` - JSON command-line parser
- `claude` CLI - installed and authenticated
- Git repository initialized

## Quick Start

```bash
# Interactive mode (prompts for permissions)
./ralph.sh

# AFK mode (fully autonomous, no prompts)
./ralph.sh --afk
```

### Interactive Mode (Default)

In normal interactive mode, RALPH spawns a Claude Code session and waits for it to complete. The shell loop pauses while Claude is active, allowing you to interact with Claude, approve permissions, and guide the implementation. Once you exit the Claude session (e.g., with `/exit` or Ctrl+C), control returns to the RALPH loop, which checks for progress and spawns a new session for the next story.

### AFK Mode

With `--afk`, RALPH runs fully autonomously using Claude's `--dangerously-skip-permissions` flag. No user interaction is required—Claude will implement features, commit changes, and move through stories without prompts.

## How It Works

1. RALPH reads `prd.json` for incomplete stories (where `passes == false`)
2. Selects the highest priority story (lowest priority number)
3. Spawns a fresh Claude Code session with the story context
4. Claude implements the feature and verifies each step
5. Progress is detected via Git commits or PRD updates
6. Loop continues until all stories pass or max iterations reached

### Key Files

| File              | Purpose                           |
| ----------------- | --------------------------------- |
| `ralph.sh`        | Main loop orchestrator            |
| `ralph-prompt.md` | Instructions template for Claude  |
| `prd.json`        | Product requirements with stories |
| `progress.txt`    | Development log across iterations |

## PRD Format

Stories in `prd.json` follow this structure:

```json
{
  "project": "Project Name",
  "description": "Project description",
  "stories": [
    {
      "id": "1",
      "title": "Short description",
      "description": "Full requirements",
      "priority": 1,
      "passes": false,
      "steps": [{ "text": "Verification step", "passed": false }]
    }
  ]
}
```

| Field         | Description                                                |
| ------------- | ---------------------------------------------------------- |
| `id`          | Unique story identifier                                    |
| `title`       | Short description                                          |
| `description` | Full requirements                                          |
| `priority`    | Lower number = higher priority                             |
| `passes`      | `false` = incomplete, `true` = done                        |
| `steps`       | Verification checklist with individual completion tracking |

## Configuration

### Environment Variables

| Variable          | Default | Description                              |
| ----------------- | ------- | ---------------------------------------- |
| `MAX_ITERATIONS`  | 50      | Maximum loop iterations                  |
| `MAX_NO_PROGRESS` | 3       | Exit after N iterations with no progress |
| `SLEEP_BETWEEN`   | 2       | Seconds between iterations               |

### Command-Line Flags

| Flag     | Description                                                  |
| -------- | ------------------------------------------------------------ |
| `--afk`  | Run in AFK mode (fully autonomous, skips permission prompts) |
| `--help` | Display usage information                                    |

### Example

```bash
MAX_ITERATIONS=100 MAX_NO_PROGRESS=5 ./ralph.sh --afk
```

## Credits

Inspired by [Tips for AI Coding with Ralph Wiggum](https://www.aihero.dev/tips-for-ai-coding-with-ralph-wiggum) from AI Hero.

## License

MIT
