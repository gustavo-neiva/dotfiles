---
name: context7
description: |
  Fetch current technical documentation from Context7 API.
  Use when user requests "check docs", "latest docs", "current documentation",
  or when implementing/troubleshooting requires up-to-date technical details
  that may have changed after training cutoff.
user-invocable: true
---

# Context7 Documentation Lookup

Query Context7 API for current technical documentation.

## When to Use

- User explicitly requests: "check docs", "latest docs", "lookup documentation"
- Claude encounters API/method/library that may have changed post-cutoff
- Implementing features requiring precise technical details
- Troubleshooting with version-specific behavior

## API Endpoint

```
GET https://context7.com/api/v2/context
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `libraryId` | string | Yes | Library identifier (e.g., `/vercel/next.js`, `/rails/rails`) |
| `query` | string | Yes | Search query (URL-encoded, e.g., `setup+ssr`) |
| `type` | string | No | Response format (`txt` default, `md` for markdown) |

## Usage Template

```bash
curl -X GET "https://context7.com/api/v2/context?libraryId=$LIBRARY_ID&query=$QUERY&type=txt" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"
```

## Implementation Steps

1. Parse user request to extract:
   - Technology/library name
   - Specific topic or feature
   - Format preference (optional)

2. Construct API call:
   - Map library name to `libraryId` (use `/org/repo` pattern for GitHub projects)
   - URL-encode the query
   - Default `type=txt` unless markdown requested

3. Execute via Bash tool with the curl command

4. Parse and summarize the response for the user

## Common Library IDs

```bash
# Frontend
/vercel/next.js          # Next.js
/facebook/react          # React
/vuejs/core              # Vue.js
/sveltejs/svelte         # Svelte

# Backend
/rails/rails             # Ruby on Rails
/django/django           # Django
/flask/flask             # Flask
expressjs/express        # Express
/pallets/flask           # Flask

# Database
/postgres/postgres       # PostgreSQL
/redis/redis             # Redis
/mongodb/mongo           # MongoDB

# Tools
/nodejs/node             # Node.js
/pnpm/pnpm               # pnpm
volta-cli/volta          # Volta
```

## Example Invocations

```bash
# Next.js SSR setup
curl "https://context7.com/api/v2/context?libraryId=/vercel/next.js&query=setup+ssr&type=txt" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"

# Rails authentication
curl "https://context7.com/api/v2/context?libraryId=/rails/rails&query=authentication&type=md" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"

# Docker compose
curl "https://context7.com/api/v2/context?libraryId=/docker/compose&query=volumes+mount&type=txt" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"
```

## Notes

- `CONTEXT7_API_KEY` is pre-loaded in the shell environment
- Auto-urlencode queries (replace spaces with `+`)
- Default to `type=txt` for faster responses
- Use `type=md` when formatted documentation is needed
