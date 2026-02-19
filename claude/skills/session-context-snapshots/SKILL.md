---
name: session-context-snapshots
description: "TRIGGER PHRASES: 'save work', 'pause', 'continue later', 'restart later', 'snapshot', 'compress context', 'take a break', 'wrap up', 'checkpoint', 'save progress', 'context switch', 'finishing soon'. Use when user requests to pause/save/continue later, or switching between multiple complex tasks - creates persistent markdown files capturing iterations, decisions, code state, and next steps instead of relying on conversation compaction"
---

# Session Context Snapshots

Create persistent markdown capturing exact session state for later resumption.

Save to `specs/sessions/[TaskName]-YYYY-MM-DD-HHmm.md` or ask user

## Filename

⁠ [TaskName]-YYYY-MM-DD-HHmm.md ⁠

Location: Task sessions folder → Project root → ⁠ /tmp/ ⁠

## Template

⁠ markdown

# Session Context: [Task Name]

**Exported:** [YYYY-MM-DD HH:mm]
**Project:** [project path]
**Duration:** [approximate time spent]

## Environment

- **Working Directory:** [path]
- **Git Branch:** [branch]
- **Git Status:** [clean/dirty, uncommitted files if any]

## Active Todos

- ✅ [completed task with file:line]
- 🔄 [in progress task with current state]
- ⏳ [pending task]

## Completed Work

[For each item:]

- **File:** `path/to/file.ts:line-range`
- **Changed:** [what was modified]
- **Why:** [decision rationale]
- **Related:** [tests, types, docs affected]

## In-Progress Work

- **File:** `path/to/file.ts:line` (stopped here)
- **Done:** [what's complete]
- **Remaining:** [what's left]
- **Next step:** [specific action with file:line]

## Blockers (if any)

- **Issue:** [description] at `file:line`
- **Investigated:** [what was tried]
- **Next:** [recommended approach]

## Decisions Made

- **Decision:** [what was decided]
- **Rationale:** [why this approach]
- **Rejected:** [alternatives considered]

## Next Session Start

1. [First specific action with file:line]
2. [Second action with file:line]
3. [Third action with file:line]
    ⁠

## Multi-Task Format

ONE file with separate task sections:

⁠ markdown

## Task 1: [Name] [PRIORITY: HIGH/MED/LOW]

[All sections above for this task]

## Task 2: [Name] [PRIORITY]

[All sections above for this task]

## Task Dependencies

- Task 2 blocked by Task 1 (reason)
- Task 3 independent
   ⁠

## After Export

1.⁠ ⁠*Display* full file path to user
2.⁠ ⁠*Summarize* what was captured (e.g., "3 completed files, 2 decisions, 1 blocker")
3.⁠ ⁠*Remind* user: "Reference this file after ⁠ /clear ⁠"

## Critical: Always file:line

| Avoid                      | Use Instead                                 |
| -------------------------- | ------------------------------------------- |
| "in auth.ts"               | ⁠ src/auth/login.ts:45 ⁠                    |
| "finish the feature"       | "Add validation at ⁠ api/users.ts:89 ⁠"     |
| "fix the bug"              | "Change condition at ⁠ utils/parse.ts:23 ⁠" |
| "somewhere around line 80" | ⁠ component.tsx:82-89 ⁠                     |

## Other Reminders

•⁠ ⁠*Never skip "why"* - Future sessions need decision context
•⁠ ⁠*Document exact stopping point* - "Was I at line 78 or
