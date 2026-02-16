---
stack: static
services:
  github:
    username: "roar-gits"
---

# Project Configuration - BetterBattery

**Inherits**: Global `~/.claude/CLAUDE.md`
**Framework Docs**: `~/.claude/docs/` (on-demand loading)

---

## Session Bootstrap

**Start here**: Read this file, then check `docs/initiatives/` for active work.

| Current Focus | Status |
|---------------|--------|
| _Project setup_ | Pending |

> **Keep this table updated**: When work focus changes, update silently. This helps future sessions pick up where you left off.

## Project Type

| Setting | Value |
|---------|-------|
| **Type** | `static` |
| **Stack** | GitHub + GitHub Pages |
| **Status** | `pending-setup` |

> **Stack types**:
> - `static`: GitHub Pages (just needs GitHub credentials)
> - `full-stack`: Vercel + Next.js + Supabase (needs GitHub + Vercel + Supabase credentials)
>
> Update status to `active` once credentials are configured.

---

## Session Start: Credential Check

On session start, Claude should verify required credentials exist based on project type:

**For static projects:**
```bash
echo $GITHUB_TOKEN   # From hobby.env — should show token
```

**For full-stack projects:**
```bash
echo $GITHUB_TOKEN      # From hobby.env — required
echo $VERCEL_TOKEN      # From hobby.env — required for troubleshooting
echo $BETTERBATTERY_SUPABASE_URL      # Required
echo $BETTERBATTERY_SUPABASE_ACCESS_TOKEN  # Required for MCP
```

If GitHub/Vercel tokens are missing, run `direnv allow` to load `hobby.env`.
If Supabase vars are missing or show "NOT_CONFIGURED", add them to
`~/.env.credentials/betterbattery.env` and run `direnv allow`.

---

## Credential Security (CRITICAL)

### This Project's Configuration

| Setting | Value |
|---------|-------|
| **GitHub Account** | `roar-gits` |
| **Token Variable** | `HOBBY_GITHUB_TOKEN` (from `hobby.env`) |
| **Credential File** | `~/.env.credentials/hobby.env` (shared) + `betterbattery.env` (project-specific) |
| **Isolation** | direnv - loads hobby.env + project credentials |
| **MCP Config** | `.mcp.json` |

### GitHub Tools (Dual-Path)

Both MCP tools and gh CLI are isolated to this project via `GITHUB_TOKEN` env var.

| Tool | Use When |
|------|----------|
| MCP tools | Normal operations (structured, auditable) |
| gh CLI | MCP unavailable, complex queries, scripting |

### Verify Isolation
```bash
gh auth status  # Should show: roar-gits
```

### AI Self-Guidance - Security Rules

1. **NEVER embed tokens** in git remote URLs
2. **NEVER hardcode tokens** in .mcp.json - use \${VAR} syntax
3. **Use MCP tools or gh CLI** - both are isolated via GITHUB_TOKEN
4. **Be explicit about repo**: `owner:roar-gits repo:REPO_NAME`
5. **NEVER use `gh auth login`** - breaks per-project isolation
6. **After credential changes**: Run `~/.claude/scripts/audit.sh`

### Correct Usage
```bash
# MCP (preferred)
Use mcp__github__list_issues for owner:roar-gits repo:REPO_NAME

# gh CLI (alternative - same isolation)
gh issue list
gh pr create --title "..." --body "..."
```

**Full credential documentation**: `~/.claude/docs/guides/credential-security.md`

---

## MCP Servers Configured

| Server | Status | Purpose |
|--------|--------|---------|
| GitHub | Configured | Repository operations via `HOBBY_GITHUB_TOKEN` |

---

## Documentation (Consult Proactively)

| When you need to... | Read |
|---------------------|------|
| Understand the stack | `docs/architecture.md` |
| Debug service issues (OAuth, API) | `docs/integrations.md` |
| Understand users, personas | `docs/users/` |
| See active work streams | `docs/initiatives/` |

> **Proactive reading**: Don't wait until stuck. Check relevant docs before starting unfamiliar work.

---

## Recipes

Common task patterns for this project:

### Add a New Feature
1. Check `docs/initiatives/` for related active work
2. Review `docs/architecture.md` for patterns to follow
3. Implement following existing conventions
4. Update docs if patterns change

### Debug an Integration Issue
1. Check `docs/integrations.md` for known quirks
2. Verify credentials: `echo $GITHUB_TOKEN` (or `$VERCEL_TOKEN`)
3. Check service dashboard (links in integrations.md)

> **Add project-specific recipes** as common patterns emerge.

---

## Current Work

Check `docs/initiatives/` for active work streams.

When starting a multi-session initiative:
1. Create `docs/initiatives/[name].md`
2. Update the Session Bootstrap table above
3. Track progress with phase checklists

---

## Framework Access

Load docs on-demand from `~/.claude/docs/` when needed:

| Need | Read |
|------|------|
| Credential setup | `~/.claude/docs/guides/credential-security.md` |
| Web stack guide | `~/.claude/docs/guides/web-stack-guide.md` |
| Git workflow | `~/.claude/docs/guides/git-workflow.md` |

---

## Session Lifecycle

1. **Start**: `git status`
2. **Work**: Use TaskCreate for multi-step tasks
3. **End**: Commit changes, verify audit passes

---

**Philosophy**: Lightweight bootstrap -> On-demand framework loading -> Context efficiency
