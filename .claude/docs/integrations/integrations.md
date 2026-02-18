<!-- Last updated: 2026-02-17 | Status: Active -->

# Integrations

## Credential Security

### This Project's Configuration

| Setting | Value |
|---------|-------|
| **GitHub Account** | `roar-gits` |
| **Token Variable** | `HOBBY_GITHUB_TOKEN` (from `hobby.env`) |
| **Credential File** | `~/.env.credentials/hobby.env` (shared) |
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
echo $GITHUB_TOKEN  # Should have value
```

---

## GitHub

**Organization/Owner**: `roar-gits`
**Repository**: `BetterBattery`
**URL**: https://github.com/roar-gits/BetterBattery

---

## GitHub Pages

**Custom domain**: betterbattery.org (configured via `CNAME` file in repo root)
**Deploy branch**: `main`
**How it works**: Push to `main` → GitHub Pages auto-builds and deploys the static `index.html`.

No build step required — the repo contains a single deployable HTML file.

---

## batt (External Dependency)

**What**: Open-source macOS battery charge limiter by charlie0129
**GitHub**: https://github.com/charlie0129/batt
**License**: GPL-2.0
**Current version**: v0.7.1 (as of February 2026)

BetterBattery.org teaches users how to install and configure `batt`. The site itself doesn't depend on `batt` at runtime — it's a static guide.

### Key technical details (for site accuracy)

- Apple Silicon only (M1/M2/M3/M4) — does NOT work on Intel Macs
- Installed via Homebrew: `brew install batt`
- Daemon started with: `sudo brew services start batt`
- Homebrew install auto-enables non-root access (no separate step needed)
- Commands like `batt limit 70` work WITHOUT sudo
- Toggle scripts must use full paths (`/opt/homebrew/bin/batt`) for Shortcuts/launchd compatibility
- macOS Tahoe (26) fully supported since batt v0.4.0+
