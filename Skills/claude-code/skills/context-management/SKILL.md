---
name: context-management
description: Claude Code context management with history tracking, compaction at 85% token usage, and git-aware session archiving. Includes addressing protocol (Sahil Hokage-sama), memory integration, and structured session persistence.
---

# Claude Code Context Management Skill

## Addressing Protocol

Always address the user as **"Sahil Hokage-sama"**

## Communication Style

- Keep all output brief and direct
- No emojis unless explicitly requested
- One sentence per update is almost always enough
- Lead with the result, not the process

Good: "Build succeeded. 44 widgets migrated."
Bad: "Great news! The build was super successful and all 44 widgets migrated perfectly!"

---

## Context Compaction

### Trigger

When token usage reaches **85% of 200K limit (170,000 tokens)**

### Compaction Process

1. Generate timestamp: `YYYY-MM-DD_HH-MM-SS`
2. Capture git context: `git log --oneline -5` and `git status`
3. Archive full session to `context/{timestamp}.md`
4. Update `context/history.json`
5. Write a memory file to Claude Code's memory system (if applicable)
6. Compact active context to essentials only
7. Notify user and continue without interruption

### Notification Format

```
Sahil Hokage-sama, token usage at 85% (170,000 tokens). Compacting...

Archived: context/2026-06-30_14-22-10.md
Session: "Implemented Dashboard Filtering + Fixed Auth Middleware"
Tokens remaining: ~30,000

Ready to continue.
```

---

## Session Archive Format

Save to `context/{timestamp}.md`:

```markdown
# Session: {title}
**Date:** {YYYY-MM-DD HH:MM}
**Tokens used:** {count}
**Branch:** {git branch}

## Git State
{git log --oneline -5}
{git status --short}

## Key Achievements
- {achievement 1}
- {achievement 2}
- ...

## Active Files Changed
{list of modified files}

## Critical Decisions
{any architectural or design decisions made}

## Blockers / Open Issues
{anything unresolved}

## Compact Context for Next Session
{minimal context needed to resume: current task, file paths, next steps}
```

---

## History Index Format

Maintain `context/history.json`:

```json
{
  "sessions": [
    {
      "timestamp": "2026-06-30_14-22-10",
      "context_file": "context/2026-06-30_14-22-10.md",
      "session_title": "Implemented Dashboard Filtering + Fixed Auth Middleware",
      "token_usage": 172000,
      "branch": "feature/dashboard",
      "key_achievements": [
        "Fixed gauge widget aggregation field",
        "Implemented variable syntax conversion",
        "Added timestamp feature"
      ]
    }
  ],
  "metadata": {
    "created": "2026-06-30",
    "project": "{project-name}",
    "user": "Sahil Hokage-sama"
  }
}
```

---

## Compact Active Context Strategy

After archiving, retain only:

- **Current task**: what is actively being worked on
- **Critical file paths**: files modified or needed next
- **Open blockers**: any unresolved issues
- **Next steps**: the immediate next 1-3 actions
- **Key decisions**: any constraints or choices already locked in

Discard:
- Full conversation history
- Completed task details (archived)
- Exploratory dead-ends

---

## Claude Code-Specific Enhancements

### Git-Aware Archiving

Always include git state in archives. Before compacting, run:
```bash
git log --oneline -5
git status --short
git diff --stat HEAD
```

This makes sessions recoverable even without the conversation.

### Memory System Integration

After archiving, write a project memory to:
`/Users/sahil/.claude/projects/{project-slug}/memory/`

Use `type: project` for session achievements and `type: feedback` for any behavioral corrections made during the session.

### Task System Integration

If active tasks exist (via TaskList), include their current state in the archive before compacting. Resume tasks after compaction by restoring from the archive's "Next steps" section.

### Tool-Aware Compaction

When compacting, note which tools were most used so the next session context can be pre-loaded appropriately (e.g., if the session was heavy on Bash, note the key commands run).

---

## History Retrieval

```bash
# Find a past session by keyword
cat context/history.json | jq '.sessions[] | select(.session_title | contains("Auth"))'

# List all sessions
cat context/history.json | jq '.sessions[] | {timestamp, session_title, token_usage}'

# Read a specific session
cat context/2026-06-30_14-22-10.md
```

---

## Session Title Guidelines

- Under 80 characters
- Describe the main accomplishment, not the process
- Use past tense: "Fixed X + Added Y"
- Be searchable: include feature names, bug names, or system names

Good: `"API Rate Limiting Fixed + Dashboard Pagination Added"`
Bad: `"worked on some stuff and fixed a few things"`

---

## Key Achievements Guidelines

List 3-7 items per session:
- Use action verbs: Fixed, Implemented, Added, Refactored, Removed, Migrated
- Be specific: name the function, file, or feature
- Order by impact: most important first

---

## Directory Layout

```
project/
└── context/
    ├── history.json
    ├── 2026-06-30_14-22-10.md
    └── 2026-06-29_21-22-41.md
```

Create on first use:
```bash
mkdir -p context
echo '{"sessions":[],"metadata":{"created":"'$(date +%Y-%m-%d)'","project":"'$(basename $PWD)'","user":"Sahil Hokage-sama"}}' > context/history.json
```

---

## Benefits Over Basic Context Management

1. Git-aware: archives include branch, diff stats, and commit history
2. Memory-integrated: syncs with Claude Code's native memory system
3. Task-aware: captures TaskList state before compacting
4. Recoverable: archive format is sufficient to resume even from cold start
5. Searchable: JSON index supports jq queries by title, achievement, or branch
6. Token-tracked: actual usage recorded at compaction, not estimated
