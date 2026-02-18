<!-- Last updated: 2026-02-17 | Status: Active -->

# Architecture

## Stack

| Layer | Technology |
|-------|------------|
| Framework | None — single `index.html` with inline `<style>` and `<script>` |
| Hosting | GitHub Pages (deploys from `main` branch) |
| Fonts | Google Fonts (loaded via `<link>` tags) |
| Database | None |
| Auth | None |
| Build tools | None — file is deployable as-is |

---

## Directory Structure

```
BetterBattery/
├── index.html          # The entire site — single-page, inline CSS/JS (~114KB)
├── CNAME               # GitHub Pages custom domain: betterbattery.org
├── og-image.png        # Open Graph social preview image
├── batt-monitor.sh     # Auto-drain monitor script (reference copy)
└── .claude/            # Claude Code project config + docs
```

---

## Key Patterns

### Single-Page Static Site

Everything lives in one `index.html`. No routing, no components, no build step. Inline `<style>` and `<script>` tags. Deploys by pushing to `main`.

### Two Setup Paths

The site offers two ways to set up battery limiting:
1. **Claude-assisted** (recommended) — user installs batt via one Terminal command, then uses Claude AI to complete the rest conversationally
2. **DIY** — full step-by-step guide with collapsible accordion sections

### Progressive Disclosure

Content uses collapsible/accordion sections (CSS `<details>`/`<summary>` where possible, minimal JS). Science and environmental sections default to summary view with expand toggles.

### Copy-to-Clipboard

Code blocks have copy buttons with visual feedback. Implemented with minimal inline JS.

---

## Conventions

| Convention | Rule |
|------------|------|
| Deployment | Push to `main` → GitHub Pages auto-deploys |
| Code blocks | Must use full paths (e.g., `/opt/homebrew/bin/batt`) — Shortcuts/launchd don't inherit PATH |
| Page weight | Target under 500KB including fonts |
| Browser support | All modern browsers (Safari, Chrome, Firefox, Edge) |
| Accessibility | Semantic HTML5, WCAG AA color contrast, keyboard-navigable |
