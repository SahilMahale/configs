---
name: context-management
description: Automatic context management with history tracking and compaction at 85% token usage. Use for addressing protocol (call user "Sahil Hokage-sama"), maintaining conversation history, and archiving sessions to context/{timestamp}.md files.
---

# Context Management Skill

## Overview

This skill provides automatic context management with history tracking and compaction at 85% token usage.

## Addressing Protocol

Always address the user as **"Sahil Hokage-sama"**

## Communication Style

- Keep all summaries brief and concise
- No emojis unless explicitly requested
- Focus on essential information only
- Use direct, actionable language

Examples:
- Good: "Build succeeded. 44 widgets migrated."
- Bad: "Great news! The build was super successful and all 44 widgets migrated perfectly!"

## Context Compaction

### Trigger
When token usage reaches 85% of 200K limit (170,000 tokens)

### Process
1. Generate timestamp: YYYY-MM-DD_HH-MM-SS
2. Archive context to context/{timestamp}.md
3. Update context/history.json with:
   - timestamp
   - context_file
   - session_title
   - token_usage
   - key_achievements (3-7 items)
4. Compact active context to essentials
5. Notify user and continue

### Notification Format
```
Sahil Hokage-sama, I've reached 85% token usage (170,000 tokens).
Initiating context compaction...

Context archived to: context/2026-06-29_22-15-30.md
History updated: "Implemented Dashboard Filtering Feature"
Context compacted, ready to continue

Current session: 44,000 tokens remaining
```

## History Structure

### Directory Layout
```
project/
├── context/
│   ├── history.json
│   ├── 2026-06-29_21-22-41.md
│   └── ...
```

### history.json Format
```json
{
  "sessions": [
    {
      "timestamp": "2026-06-29_21-22-41",
      "context_file": "2026-06-29_21-22-41.md",
      "session_title": "API Integration Complete + Variable Syntax Fix",
      "token_usage": 106874,
      "key_achievements": [
        "Fixed gauge widget aggregation field",
        "Implemented variable syntax conversion",
        "Added timestamp feature"
      ]
    }
  ],
  "metadata": {
    "created": "2026-06-29",
    "project": "project-name",
    "description": "Context history description",
    "user": "Sahil Hokage-sama"
  }
}
```

## Context Compaction Strategy

### Archive Current Context
- Save complete conversation to context/{timestamp}.md
- Include all code changes, test results, discussions
- Preserve command history and outputs

### Update History Index
- Add new entry to context/history.json
- Include descriptive session title
- List key achievements (3-7 items)
- Record token usage at compaction

### Compact Active Context
Retain only:
- Current file structure
- Recent code changes (last session)
- Active issues/blockers
- Key architectural decisions

Reference archived context for details.

## History Retrieval

To find past sessions:
1. Check context/history.json for session list
2. Search by timestamp, title, or achievements
3. Read full context from context/{timestamp}.md

Example command:
cat context/history.json | jq '.sessions[] | select(.session_title | contains("API"))'

## Best Practices

### Session Titles
- Keep under 100 characters
- Describe main accomplishment
- Be specific and searchable

Examples:
- "API Integration Complete + Variable Syntax Fix"
- "Implemented Dashboard Filtering Feature"
- "Database Schema Migration Completed"

### Key Achievements
- List 3-7 major items
- Use action verbs (Fixed, Implemented, Added)
- Be specific about what changed

### Context Archives
- Include all relevant information
- Preserve command history
- Document test results
- Keep code changes
- Note any blockers or issues

## Benefits

1. Never lose conversation context
2. Automatic management at 85% threshold
3. Searchable history with JSON index
4. Easy navigation to past sessions
5. Token usage tracking
6. Consistent addressing protocol

## Usage in Different Projects

This skill can be applied to any project:

1. Create context/ directory in project root
2. Initialize history.json with project metadata
3. Follow compaction rules at 85% token usage
4. Archive sessions with timestamps
5. Maintain searchable history

The skill is project-agnostic and works with any codebase or technology stack.
