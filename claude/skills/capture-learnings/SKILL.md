---
name: capture-learnings
description: |
  Capture mistakes, gotchas, and learnings to ~/.claude/CLAUDE.md.
  Use when Claude was corrected, a non-obvious behavior was discovered,
  PR review revealed a reusable pattern, or user says "remember this",
  "add gotcha", "save learning", "add to claude.md".
---

# Capture Learnings

Append gotchas to ⁠ ~/.claude/CLAUDE.md ⁠. Never auto-edit — always present for user approval first.

## Target Sections

| Section                                | When                            |
| -------------------------------------- | ------------------------------- |
| ⁠ ## Common Gotchas ⁠                  | Cross-project, tooling, general |
| ⁠ ## carta-web Model Gotchas ⁠         | Django models, queries, ORM     |
| ⁠ ## carta-frontend-platform Gotchas ⁠ | Frontend, TS, Rush, MSW, jest   |
| New section                            | Ask user if none fit            |

## Entry Format

Match existing style exactly:

- **Short Label**: Actionable description with `code`. Use `correct`, NOT `wrong` (context)

Good:

- **Certificate number**: Use `f"{cert.prefix}-{cert.prefix_number}"`, NOT `cert.certificate_number`

Bad:

- Certificates: Be careful with certificate numbers

## Process

1.⁠ ⁠Extract learnings from conversation (corrections, "actually...", reverted suggestions) or user's explicit input
2.⁠ ⁠Read ⁠ ~/.claude/CLAUDE.md ⁠, check target section for duplicates
3.⁠ ⁠Format entry: bold 2-4 word label, actionable description, code refs, NOT pattern
4.⁠ ⁠Present proposed entry and section to user — ask for approval
5.⁠ ⁠After approval, use Edit to append to correct section
6.⁠ ⁠Show diff
