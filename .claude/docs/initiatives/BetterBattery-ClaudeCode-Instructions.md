# BetterBattery.org — Claude Code Build Instructions

## What This Is

A single-page website hosted at BetterBattery.org that walks a non-technical Mac user through setting up a battery charge limiter on their MacBook. The goal: stop their battery from sitting at 100% all day, run the Mac off wall power like a desktop, and add a one-tap toggle to charge to full when going mobile.

The target audience is someone who has never opened Terminal. Every step must be explicit, friendly, and assume zero technical knowledge. The tone is helpful and direct — not corporate, not overly casual. Think "a friend who's good with computers walking you through it."

---

## The Technical Setup Being Taught

This is the exact sequence a user needs to follow. Every step has been validated on macOS Tahoe 26.3 with Apple Silicon (M2). The site must reproduce these steps accurately.

### Prerequisites
- Apple Silicon Mac (M1, M2, M3, or M4)
- macOS Sequoia (15) or macOS Tahoe (26)
- The tool does NOT work on Intel Macs

### Tool: batt by charlie0129
- GitHub: https://github.com/charlie0129/batt
- Free, open-source (GPL-2.0), ~1,500 GitHub stars
- No telemetry, no ads, no internet required
- Works by writing to SMC (System Management Controller) keys via a lightweight background daemon
- Runs as a launchd service that starts automatically on boot
- Current version: v0.7.1 (as of February 2026)
- The Homebrew-installed version automatically enables non-root access, meaning regular user commands work without sudo — this is critical for Shortcuts integration

### Step 1: Install Homebrew (if not already installed)

Check first:
```
brew --version
```

If not found, install:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Note: After Homebrew installs, the user may need to run the PATH setup commands Homebrew displays. On Apple Silicon, Homebrew installs to /opt/homebrew/bin/. The user should close and reopen Terminal after installing.

### Step 2: Install batt

```
brew install batt
```

Then start the daemon:
```
sudo brew services start batt
```

This installs a launchd plist at /Library/LaunchDaemons/cc.chlc.batt.plist with RunAtLoad=true and --always-allow-non-root-access. It persists across reboots automatically.

### Step 3: Set charge limit

```
batt limit 70
```

No sudo needed (Homebrew version enables non-root access by default). The user can use any number — 70 and 80 are the most common recommendations. The site should explain the tradeoff: lower = better for battery longevity, but less charge available when unplugging.

Verify with:
```
batt status
```

### Step 4: Disable Apple's Optimized Battery Charging

This is critical — Apple's system conflicts with batt.

Path: System Settings → Battery → Battery Health → click (i) info button → toggle OFF "Optimized Battery Charging"

### Step 5: Create the toggle script

This shell script checks the current batt limit and flips between the desk limit and 100%:

```
mkdir -p ~/bin && cat > ~/bin/toggle-battery-limit.sh << 'SCRIPT'
#!/bin/zsh
CURRENT=$(/opt/homebrew/bin/batt status 2>&1)
if echo "$CURRENT" | grep -q "Upper limit: 70%"; then
    /opt/homebrew/bin/batt limit 100 2>&1
    osascript -e 'display notification "Charging to 100% — Mobile Mode" with title "🔋 Battery"'
else
    /opt/homebrew/bin/batt limit 70 2>&1
    osascript -e 'display notification "Capped at 70% — Desk Mode" with title "🔋 Battery"'
fi
SCRIPT
chmod +x ~/bin/toggle-battery-limit.sh
```

Important: The script uses full paths (/opt/homebrew/bin/batt) because Shortcuts and launchd don't inherit the user's PATH. This must not be changed.

The site should offer both a 70% and 80% version of this script block, or tell the user to replace both instances of "70" with their preferred number.

### Step 6: Install auto-drain monitor

The Mac charges to 100% during shutdowns because batt isn't running. This monitor script checks every 60 seconds and automatically drains the battery back to the limit by disabling the power adapter. It skips if in mobile mode (limit is 100%).

Create the monitor script:
```
cat > ~/bin/batt-monitor.sh << 'SCRIPT'
#!/bin/zsh
# batt-monitor.sh — Auto-drain battery to target limit
BATT="/opt/homebrew/bin/batt"
LOG_TAG="batt-monitor"

STATUS=$($BATT status 2>&1)
UPPER=$(echo "$STATUS" | grep "Upper limit:" | grep -oE '[0-9]+')
LOWER=$(echo "$STATUS" | grep "Lower limit:" | grep -oE '[0-9]+')

# Mobile mode (100%) — make sure adapter is on, exit
if [ "$UPPER" = "100" ]; then
    ADAPTER_DISABLED=$(echo "$STATUS" | grep "Use power adapter" | grep -c "✘")
    if [ "$ADAPTER_DISABLED" -eq 1 ]; then
        $BATT adapter enable >/dev/null 2>&1
        logger -t "$LOG_TAG" "Mobile mode — re-enabled adapter"
    fi
    exit 0
fi

CHARGE=$(echo "$STATUS" | grep "Current charge:" | grep -oE '[0-9]+')

if [ -z "$UPPER" ] || [ -z "$LOWER" ] || [ -z "$CHARGE" ]; then
    logger -t "$LOG_TAG" "Could not read batt status — skipping"
    exit 0
fi

ADAPTER_DISABLED=$(echo "$STATUS" | grep "Use power adapter" | grep -c "✘")

if [ "$ADAPTER_DISABLED" -eq 1 ]; then
    if [ "$CHARGE" -le "$LOWER" ]; then
        $BATT adapter enable >/dev/null 2>&1
        logger -t "$LOG_TAG" "Reached ${CHARGE}% (lower ${LOWER}%) — re-enabled adapter"
    fi
elif [ "$CHARGE" -gt "$UPPER" ]; then
    $BATT adapter disable >/dev/null 2>&1
    logger -t "$LOG_TAG" "At ${CHARGE}% (above ${UPPER}%) — disabled adapter to drain"
fi
SCRIPT
chmod +x ~/bin/batt-monitor.sh
```

Create the launchd agent (runs every 60 seconds, starts on login):
```
cat > ~/Library/LaunchAgents/com.betterbattery.monitor.plist << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.betterbattery.monitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>/Users/$(whoami)/bin/batt-monitor.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>60</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/batt-monitor.err</string>
</dict>
</plist>
PLIST
```

Load and verify:
```
launchctl load ~/Library/LaunchAgents/com.betterbattery.monitor.plist
launchctl list | grep betterbattery
```

You should see a line with `com.betterbattery.monitor`. The monitor will now keep your battery at your target automatically.

### Step 7: Create a macOS Shortcut

1. Open the Shortcuts app
2. Click "Menu Bar" in the left sidebar (creating it here automatically pins it to the menu bar)
3. Click + to create a new shortcut
4. Search for "Run Shell Script" in the right panel and add it
5. Set Shell to zsh
6. In the script body, enter: /Users/USERNAME/bin/toggle-battery-limit.sh
   - The user needs to replace USERNAME with their actual username (found by running `whoami` in Terminal)
7. Leave "Run as Administrator" UNCHECKED (non-root access is already enabled)
8. Rename the shortcut to "Toggle Battery Limit"

### Step 8: Set up keyboard shortcut (⇧⌘B)

This creates a system-wide keyboard shortcut to toggle the battery limit without touching the mouse.

#### Create the Automator Quick Action

The Quick Action needs two files inside `~/Library/Services/Toggle Battery Limit.workflow/`:

**Contents/Info.plist** — service registration:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSServices</key>
    <array>
        <dict>
            <key>NSMenuItem</key>
            <dict>
                <key>default</key>
                <string>Toggle Battery Limit</string>
            </dict>
            <key>NSMessage</key>
            <string>runWorkflowAsService</string>
            <key>NSRequiredContext</key>
            <dict/>
        </dict>
    </array>
</dict>
</plist>
```

**Contents/document.wflow** — "Run Shell Script" action pointing to the toggle script:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>AMApplicationBuild</key>
    <string>523</string>
    <key>AMApplicationVersion</key>
    <string>2.10</string>
    <key>actions</key>
    <array>
        <dict>
            <key>action</key>
            <dict>
                <key>AMAccepts</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Optional</key>
                    <true/>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.string</string>
                    </array>
                </dict>
                <key>AMActionVersion</key>
                <string>2.0.3</string>
                <key>AMApplication</key>
                <array>
                    <string>Automator</string>
                </array>
                <key>AMBundleIdentifier</key>
                <string>com.apple.RunShellScript</string>
                <key>AMCategory</key>
                <array>
                    <string>AMCategoryUtilities</string>
                </array>
                <key>AMIconName</key>
                <string>Automator</string>
                <key>AMKeywords</key>
                <array>
                    <string>Shell</string>
                    <string>Script</string>
                </array>
                <key>AMName</key>
                <string>Run Shell Script</string>
                <key>AMProvides</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.string</string>
                    </array>
                </dict>
                <key>AMRequiredResources</key>
                <array/>
                <key>ActionBundlePath</key>
                <string>/System/Library/Automator/Run Shell Script.action</string>
                <key>ActionName</key>
                <string>Run Shell Script</string>
                <key>ActionParameters</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <string>/Users/USERNAME/bin/toggle-battery-limit.sh</string>
                    <key>CheckedForUserDefaultShell</key>
                    <true/>
                    <key>inputMethod</key>
                    <integer>0</integer>
                    <key>shell</key>
                    <string>/bin/zsh</string>
                    <key>source</key>
                    <string></string>
                </dict>
                <key>BundleIdentifier</key>
                <string>com.apple.RunShellScript</string>
                <key>CFBundleVersion</key>
                <string>2.0.3</string>
                <key>CanShowSelectedItemsWhenRun</key>
                <false/>
                <key>CanShowWhenRun</key>
                <true/>
                <key>InputUUID</key>
                <string>00000000-0000-0000-0000-000000000000</string>
                <key>OutputUUID</key>
                <string>00000000-0000-0000-0000-000000000001</string>
            </dict>
        </dict>
    </array>
    <key>connectors</key>
    <dict/>
    <key>workflowMetaData</key>
    <dict>
        <key>workflowTypeIdentifier</key>
        <string>com.apple.Automator.servicesMenu</string>
    </dict>
</dict>
</plist>
```

Note: Replace `USERNAME` with the user's actual macOS username (from `whoami`).

#### Refresh the services cache

```
/System/Library/CoreServices/pbs -update
```

#### Register the ⇧⌘B keyboard shortcut

```
defaults write pbs NSServicesStatus -dict-add '"(null) - Toggle Battery Limit - runWorkflowAsService"' '{ "key_equivalent" = "@$b"; }'
```

#### Handle app conflicts

Check which apps are installed and remap their ⇧⌘B bindings to ⌃⇧⌘B (Control+Shift+Command+B):

**Chrome** (bookmarks bar toggle):
```
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Always Show Bookmarks Bar" "^@\$b"
```

**Arc** (bookmarks bar toggle):
```
defaults write company.thebrowser.Browser NSUserKeyEquivalents -dict-add "Always Show Bookmarks Bar" "^@\$b"
```

**VS Code** (Run Build Task) — uses its own keybindings system, not macOS NSUserKeyEquivalents. Create or update `~/Library/Application Support/Code/User/keybindings.json`:
```json
[
    {
        "key": "ctrl+shift+cmd+b",
        "command": "workbench.action.tasks.build"
    },
    {
        "key": "shift+cmd+b",
        "command": "-workbench.action.tasks.build"
    }
]
```

Note: The shortcut **requires logging out and back in** for macOS to activate it. The `pbs -update` command refreshes the services cache, but macOS doesn't pick up new keyboard bindings until the next login session. Tell the user what was changed, which apps were remapped, and that they need to log out and back in.

### Step 9: Add to Control Center (optional but recommended)

1. Open Control Center (click icon in menu bar)
2. Click + at bottom left
3. Find and add Shortcuts
4. Select "Toggle Battery Limit"

### How it works day-to-day
- Mac stays at the set limit (e.g. 70%), running off wall power — battery sits idle
- Tap toggle → charges to 100% for mobile use
- Tap toggle again → caps back to limit when back at desk
- Survives reboots — daemon auto-starts with last configured limit
- Sleep is handled — batt disables charging before sleep to prevent overnight charge-up

### Uninstall steps
```
sudo brew services stop batt
brew uninstall batt
rm ~/bin/toggle-battery-limit.sh
rm ~/bin/batt-monitor.sh
launchctl unload ~/Library/LaunchAgents/com.betterbattery.monitor.plist
rm ~/Library/LaunchAgents/com.betterbattery.monitor.plist
rm -rf ~/Library/Services/Toggle\ Battery\ Limit.workflow
```
Then re-enable Optimized Battery Charging in System Settings. Delete the Shortcut you created in the Shortcuts app. If you remapped keyboard shortcuts for Chrome, Arc, or VS Code, revert those changes.

---

## Site Design & Content Requirements

### Structure
Single-page site. No navigation needed beyond scrolling. Sections:

1. **Hero / Hook** — Short, compelling pitch. Something like "Your MacBook battery is dying while it sits on your desk. Fix it in 10 minutes." Communicate the core value: run your Mac like a desktop with a built-in UPS, one-tap toggle for mobile.

2. **Why This Matters** — Brief explanation (2-3 short paragraphs max) of why sitting at 100% is bad. Mention that lithium-ion batteries degrade faster at high charge levels. Don't get overly scientific. The key insight: "If your MacBook lives on a charger, it's aging faster than it needs to."

3. **What You'll Need** — Simple checklist. Apple Silicon Mac, macOS Sequoia or Tahoe, 10 minutes, willingness to paste a few commands into Terminal.

4. **Step-by-Step Setup** — The full walkthrough from Steps 1-7 above. Each step should have:
   - A clear heading
   - Brief explanation of what we're doing and why (1-2 sentences)
   - The exact commands or actions
   - What success looks like (what they should see)
   - Common issues / troubleshooting tips where relevant

5. **Day-to-Day Usage** — Short section explaining the workflow. Most days you do nothing. Toggle when going mobile. Toggle back at desk.

6. **FAQ** — Cover these questions:
   - Will this void my warranty? (No)
   - Is batt safe? (Open source, 1,500+ stars, no data collection, auditable code)
   - Can I change the limit later? (Yes, `batt limit XX`)
   - What happens when my Mac is shut down? (Charges normally — hardware limitation)
   - What about sleep / closing the lid? (Handled by batt's pre-sleep charging disable)
   - Does this work on Intel Macs? (No, Apple Silicon only)
   - What if I want to uninstall? (Provide the 3 commands)
   - Should I pick 70% or 80%? (70% = more longevity, 80% = more buffer. Both are significantly better than 100%)

7. **Footer** — Credit to batt/charlie0129 with GitHub link. Brief note that this is a free community resource.

### Design Direction
- Clean, modern, minimal. White/light background, easy to read.
- Good typography — the page is mostly text and code blocks, so readability is everything.
- Code blocks should be clearly styled with a copy button if possible.
- Mobile responsive — people might be reading this on their phone while setting up their Mac.
- Consider a simple visual/diagram showing the concept: "Plugged in at desk → battery holds at 70% → tap toggle → charges to 100% → go mobile → come back → tap toggle → holds at 70% again"
- No JavaScript frameworks needed. Plain HTML/CSS is fine. Keep it fast.
- Subtle battery/energy theming is fine but don't overdo it.

### Tone
- Friendly, direct, confident
- "Here's what to do" not "you might consider perhaps trying"
- Assume the reader is smart but not technical
- Explain Terminal without being condescending ("Terminal is an app on your Mac that lets you type commands directly")
- Every command should be copy-pasteable with zero modifications unless explicitly noted (like the username replacement)

### Important Accuracy Notes for Claude Code
- The Homebrew install of batt does NOT use `batt install` — that command only works for non-Homebrew installs. Homebrew uses `sudo brew services start batt`.
- The Homebrew launchd plist already includes `--always-allow-non-root-access`, so there's no separate step to enable it.
- Commands like `batt limit 70` and `batt status` work WITHOUT sudo because of the above.
- The toggle script MUST use full paths (`/opt/homebrew/bin/batt`) because Shortcuts doesn't inherit the user's shell PATH.
- The user's username in the Shortcut script path must be their actual macOS username (found via `whoami`).
- hibernatemode should be 3 (factory default for MacBooks). If someone has changed it, batt's sleep protection won't work correctly. Worth mentioning in FAQ or troubleshooting.
- macOS Tahoe 26 initially broke batt, but v0.4.0+ added new Tahoe-compatible SMC keys. Current v0.7.1 fully supports Tahoe. This is resolved — don't scare users about it, but do emphasize keeping batt updated.
- The `key_equivalent` format used by `defaults write pbs NSServicesStatus`: `@` = Command, `$` = Shift, `^` = Control, `~` = Option. So `@$b` = ⇧⌘B.
- The pbs service key format is: `(null) - <ServiceName> - runWorkflowAsService` — the `(null)` is literal.
- Chrome's menu item for the bookmarks bar is "Always Show Bookmarks Bar" (not "Toggle Bookmarks Bar" or "Show Bookmarks Bar").
- VS Code uses its own keybindings system (`keybindings.json`), not macOS `NSUserKeyEquivalents`. Remapping must be done in VS Code's config, not via `defaults write`.
- The auto-drain monitor uses `batt adapter enable/disable` to control power flow. These commands require batt's daemon to be running.

---

## Deployment Note

The site will be hosted at BetterBattery.org. Standard static hosting — no backend needed. Just HTML, CSS, and optionally minimal JS for copy-to-clipboard on code blocks.
