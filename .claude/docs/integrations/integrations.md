<!-- Last updated: 2026-02-16 | Status: Active -->

# Integrations

## Credential Security

### This Project's Configuration

| Setting | Value |
|---------|-------|
| **GitHub Account** | `roar-gits` |
| **Token Variable** | `BETTERBATTERY_GITHUB_TOKEN` |
| **Credential File** | `~/.env.credentials/betterbattery.env` |
| **Isolation** | direnv - only this project's tokens loaded |

### Security Rules

1. **NEVER embed tokens** in git remote URLs
2. **NEVER hardcode tokens** in .mcp.json - use `${VAR}` syntax
3. **NEVER use `gh auth login`** globally - breaks per-project isolation
4. **For git/gh commands**: Use `direnv exec <project-path> <command>`
5. **After credential changes**: Run credential audit

### Verification

```bash
gh auth status  # Should show: roar-gits
echo $BETTERBATTERY_GITHUB_TOKEN  # Should have value
```

---

## GitHub

**Organization/Owner**: `roar-gits`
**Repository**: `_TBD_`

<!-- CUSTOMIZE: Add GitHub-specific details -->

---

<!-- CUSTOMIZE: Add sections for each integrated service -->

## [Service Name]

**Account**: [account]
**Project**: [project-id]

### Configuration

Details about how this service is configured.

### CLI Usage

```bash
# Example commands
```
