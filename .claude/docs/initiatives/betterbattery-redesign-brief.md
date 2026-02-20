# BetterBattery.org — Redesign Brief for Claude Code

## OVERVIEW

Redesign betterbattery.org as a single-page HTML site. The site convinces MacBook users to limit their battery charge to 70–80%, then helps them set it up using Claude AI as their guide. The tone is environmental advocacy meets approachable tech — think Patagonia's directness crossed with Apple's clarity.

This is a static HTML/CSS/JS site. No frameworks. No build tools. One `index.html` file with inline styles and scripts. It must be deployable as-is.

---

## SITE ARCHITECTURE (top to bottom)

### Section 1: THE HOOK (above the fold)

**Goal:** Emotional + environmental impact. Make people care in 5 seconds.

**Headline:** "Your MacBook battery is dying while it sits on your desk."

**Subhead:** Something like: "Right now, ~100 million MacBooks are plugged in worldwide, grinding through battery life they're not even using. Every worn-out battery means more lithium mining, more cobalt extraction, more e-waste. You can fix yours in 10 minutes — for free."

**Key stat callouts** (use these real numbers from our research):
- "Charging to 80% instead of 100% can double your battery's lifespan" (Battery University, peer-reviewed studies)
- "Apple charges $159–$249 to replace a MacBook battery"
- "If 10% of MacBook users did this, it would prevent ~3.3 million battery replacements and ~16,500 tonnes of CO₂"
- "Only 5% of US lithium-ion batteries are even collected for recycling" (Rocky Mountain Institute)

**CTA:** "Set it up now →" (scrolls to setup section)

**Design note:** This section should feel urgent but not alarmist. Use the environmental data to create gravity, not guilt. The vibe is "here's something real you can do right now."

---

### Section 2: HOW IT WORKS (simple visual explainer)

**Goal:** Demystify the concept in 10 seconds.

Show the two modes as a simple before/after or toggle visualization:

**Desk Mode (daily default):**
- Battery holds at 70–80%
- Mac runs on wall power like a desktop
- Battery sits idle in a healthy range
- MagSafe LED: green (not charging)

**Mobile Mode (when you need to leave):**
- One tap: charges to 100%
- Unplug and go
- Back at desk: one tap returns to Desk Mode

**Key reassurance:** "Your Mac works exactly the same. You won't notice any difference — except your battery lasting years longer."

**Design note:** This should be extremely visual. Think animated toggle, side-by-side comparison, or a simple diagram. No code, no terminal screenshots. Pure concept.

---

### Section 3: THE SCIENCE (collapsible/progressive disclosure)

**Goal:** Build credibility for skeptics without overwhelming casual visitors.

**Default state:** Show 2–3 compelling bullet points with a "See the research →" expand toggle.

**Key points (visible by default):**
- Lithium-ion batteries degrade faster at high voltage. Holding at 100% keeps cells at peak stress. Dropping to 80% roughly doubles cycle life.
- This isn't theoretical — every major laptop maker (Lenovo, ASUS, Dell) now ships charge-limiting features. Apple added an 80% charge limit slider to macOS in February 2026.
- A MacBook kept at 100% loses ~20% capacity in one year from calendar aging alone. At 40%, it loses only ~4%.

**Expanded content (behind toggle):**
- Battery University BU-808 data on voltage vs. cycle life
- Choi & Lim (2002) foundational research
- Wikner & Thiringer (2018) — 44–130% lifetime increase
- Jeff Dahn's lab (2019, 2022) — cells approaching 100-year projected life at lower voltage
- LFP study showing 4,320 vs. 956 cycles at 80% vs. 100%

**Design note:** Use a clean accordion or expandable section. The research details should feel authoritative but not academic. No journal-style formatting — translate the findings into plain language with source links.

---

### Section 4: THE ENVIRONMENTAL CASE (collapsible/progressive disclosure)

**Goal:** This is the emotional core for environmentally-motivated visitors.

**Default state:** 2–3 powerful stats visible.

**Key messaging:**
- Each MacBook battery contains ~6g lithium, ~8–21g cobalt — extracted from mines that consume 500,000 gallons of water per ton of lithium
- 70% of the world's cobalt comes from the DRC, where mining causes severe water contamination affecting hundreds of thousands of people
- The bigger impact: keeping your MacBook in service longer avoids 167–303 kg CO₂ from manufacturing a replacement device
- Global e-waste hit 62 million tonnes in 2022. Only 22% gets recycled. Laptop batteries in US landfills leach cobalt at 20× hazardous waste limits.

**Impact calculator concept (optional stretch goal):**
A simple interactive element: "If [slider: X%] of MacBook users adopted charge limiting..." → dynamically shows battery replacements avoided, CO₂ saved, water saved. Use the data from our research table.

**Design note:** This section should hit hard but stay grounded in data. No greenwashing aesthetics (no stock photos of forests). Use the real numbers. Consider a dark background to create visual weight and contrast with the rest of the page.

---

### Section 5: SETUP — CHOOSE YOUR PATH

**Goal:** Get people started without overwhelming them. Progressive disclosure is critical here.

Present two clear paths as cards/buttons:

#### Path A: "Let Claude set it up for you" (RECOMMENDED, prominent)
**Time:** ~5 minutes
**Difficulty:** Easy — you'll paste one thing into Terminal, then have a conversation

**Steps (progressively disclosed — show one at a time, "Done → Next" pattern):**

**Step 1: Open Terminal**
"Terminal is an app already on your Mac. Press `Cmd + Space`, type 'Terminal', and hit Enter."
(Include a small screenshot or visual hint of what Terminal looks like)

**Step 2: Install the battery tool**
"Copy and paste this into Terminal and press Enter:"
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && brew install batt && sudo brew services start batt && batt limit 80
```
"It will ask for your Mac password. When you type it, nothing appears on screen — that's normal. Just type it and press Enter."

(Note: This is a combined one-liner that installs Homebrew + batt + starts the service + sets 80% limit. If Homebrew is already installed, the first part will just note that and continue. Test this to make sure it works as a single paste.)

**Step 3: Open Claude and let it finish the setup**
"Go to [claude.ai](https://claude.ai) (free account works) and paste this prompt:"

```
I just installed batt on my MacBook to limit battery charging. I need you to help me:

1. Verify batt is running correctly (have me paste the output of `batt status`)
2. Help me choose between 70% and 80% charge limit based on how I use my laptop
3. Create a toggle script so I can switch between Desk Mode (charge limit) and Mobile Mode (100%) with one tap
4. Walk me through creating a macOS Shortcut so I can toggle from Control Center
5. Turn on MagSafe LED control so I can see when it's charging vs. holding
6. Disable Apple's Optimized Battery Charging (which conflicts with batt)
7. Explain what to expect day-to-day (the lightning bolt, MagSafe LED colors, the cycling behavior)

I'm not technical — please give me one step at a time and wait for me to confirm before moving on.
```

"Claude will walk you through the rest conversationally. If you hit any issues, just tell Claude what happened and it'll help you troubleshoot."

**Why this works messaging:** "Claude is an AI assistant that can see your Terminal output and guide you through each step. It's like having a tech-savvy friend sitting next to you."

#### Path B: "Do it yourself" (for technical users)
**Time:** ~10 minutes
**Difficulty:** Moderate — you'll paste several commands into Terminal

This is essentially the current site's step-by-step guide, but cleaned up and placed behind progressive disclosure (collapsible steps). Keep the existing content but restructure it:

1. Install Homebrew (with check-first command)
2. Install batt
3. Set charge limit
4. Disable Optimized Battery Charging
5. Create toggle script (with 70% and 80% variants)
6. Create macOS Shortcut
7. Add to Control Center

Each step should be a collapsible accordion — closed by default, user opens them one at a time.

---

### Section 6: WHAT TO EXPECT (important — prevents support anxiety)

**Goal:** Prevent people from thinking it's broken when it's working correctly.

**Heading:** "Everything is working. Here's what it looks like."

**Key expectation-setting points:**

1. **The lightning bolt stays.** The ⚡ icon in your menu bar just means "plugged in" — not "charging." This is Apple's UI, not a bug. Your MagSafe LED is the accurate indicator.

2. **MagSafe LED colors:**
   - **Green** = Battery is holding at your limit. Not charging. Running on wall power.
   - **Amber** = Actively charging (either because you toggled to Mobile Mode, or the battery dipped to the lower threshold and is topping back up).

3. **The small cycling is normal.** Your battery will slowly drift down 2–3% below your limit, then charge back up. This is by design — it prevents the charger from constantly toggling on/off. You might see your battery go from 70% → 68% → 70% → 68%. That's perfect.

4. **Your battery percentage will drop slowly.** If you set a 70% limit and your battery is currently at 85%, it will take several hours to coast down to 70%. The Mac runs on wall power during this time — the battery is just slowly discharging its excess.

5. **Shutdowns charge to 100%.** If your Mac fully shuts down (not sleep), it charges normally. This is a hardware limitation. It's fine for occasional shutdowns — just know it'll charge back up, and batt will resume limiting once you boot.

---

### Section 7: FAQ / TROUBLESHOOTING (collapsible accordion)

Keep the existing FAQ content but add:

- **"Apple just added a charge limit feature in macOS. Do I still need batt?"**
  Apple's built-in slider (added February 2026 in macOS Tahoe 26.4) caps at 80% minimum and doesn't offer a quick toggle between desk/mobile modes. If 80% works for you and you don't need one-tap toggling, Apple's built-in feature is a great option. batt gives you finer control (any percentage), a toggle workflow, and MagSafe LED feedback.

- **"Is this safe? Will it void my warranty?"**
  (Keep existing answer)

- **"What if I have an Intel Mac?"**
  batt only works on Apple Silicon (M1/M2/M3/M4). If you have an Intel Mac, check out AlDente as an alternative.

- **"How do I uninstall everything?"**
  (Keep existing answer)

- **"I'm having trouble. Where can I get help?"**
  "Open [claude.ai](https://claude.ai) and describe your issue. Paste any error messages you're seeing. Claude can troubleshoot batt issues in real-time." Also link to batt's GitHub issues page.

---

### Section 8: FOOTER

- "Built with [batt](https://github.com/charlie0129/batt) by charlie0129. Open source, GPL-2.0."
- "BetterBattery.org is a free community resource. Not affiliated with Apple."
- "Environmental data sourced from Battery University, UN Global E-waste Monitor 2024, Apple Product Environmental Reports, and peer-reviewed research."
- Optional: "Share this page" social links (Bluesky, X, LinkedIn, email)
- Optional: "BetterBattery App coming soon" teaser

---

## DESIGN DIRECTION

**Aesthetic:** Editorial environmental — think The Pudding meets Patagonia's "Don't Buy This Jacket" campaign. Clean, confident, data-driven. Not techy, not corporate, not "green-washed."

**Typography:**
- Display/heading font: Something with character and weight. Not generic. Consider a serif for authority (this is journalism-adjacent) or a distinctive geometric sans.
- Body font: Highly readable, clean, slightly warm. Not Inter, not Roboto, not system fonts.
- Monospace for code blocks: Something pleasant, not jarring.
- Load fonts from Google Fonts.

**Color palette:**
- Primary: A deep, grounded color (not tech-blue, not eco-green). Consider deep slate, warm charcoal, or a muted earth tone as the dominant.
- Accent: One strong accent color for CTAs and key stats. Could be amber/gold (ties to MagSafe LED, energy, warmth) or a bold coral/orange.
- Background: Off-white or very subtle warm gray for most sections. One dark section (the environmental case) for contrast and emotional weight.
- Avoid: Bright greens (greenwashing), tech purples, gradient backgrounds.

**Layout:**
- Full-width sections with generous padding
- Max content width ~720px for readability (prose-optimized)
- Stats/callouts can break wider for impact
- Cards for the two setup paths
- Collapsible/accordion sections for progressive disclosure (CSS-only if possible, minimal JS)

**Interactions:**
- Smooth scroll for anchor links
- Accordion open/close animations
- Copy-to-clipboard buttons on code blocks (with visual feedback)
- Optional: subtle scroll-triggered fade-ins for stat callouts
- The impact calculator (if built) should feel tactile — slider with real-time number updates

**Mobile:**
- Must be fully responsive
- Accordion pattern works well on mobile
- Code blocks should scroll horizontally if needed
- Touch-friendly tap targets

**Accessibility:**
- Semantic HTML (proper heading hierarchy, landmark elements)
- Sufficient color contrast (WCAG AA minimum)
- Keyboard-navigable accordions
- Visible focus states
- Alt text where applicable

---

## CONTENT TONE GUIDELINES

- **Direct and confident.** Not hedging, not apologetic. "This works." not "This might help."
- **Data-backed.** Every claim should feel grounded. Use specific numbers, not vague qualifiers.
- **Approachable.** A smart friend explaining something, not a manual. No jargon without explanation.
- **Environmentally honest.** Present the real data without catastrophizing or guilt-tripping. Let the numbers speak.
- **Not anti-Apple.** This isn't a criticism of Apple — Apple themselves added charge limiting in 2026. This is about giving users control they didn't know they had.

---

## TECHNICAL NOTES

- Single `index.html` file, inline `<style>` and `<script>` tags
- No build tools, no npm, no frameworks
- Google Fonts loaded via `<link>` tags
- CSS-only accordions where possible (checkbox hack or details/summary)
- Minimal JavaScript — only for: copy-to-clipboard, smooth scroll, and optional impact calculator
- Should work in all modern browsers (Safari, Chrome, Firefox, Edge)
- Total page weight should stay under 500KB including fonts
- Use semantic HTML5 elements throughout

---

## FILES TO PRODUCE

1. `index.html` — the complete site (single file, ready to deploy)

---

## IMPORTANT CONTEXT

- The site currently exists at betterbattery.org and has the technical content already (see current site for reference on the DIY steps)
- The major changes are: adding the environmental angle at the top, restructuring around Option C (Claude-assisted setup as primary path), progressive disclosure throughout, and the "What to Expect" section
- The Claude-assisted setup prompt (Step 3 of Path A) is the most important new addition — it turns a 7-step technical guide into a 3-step conversational experience
- The one-liner install command in Path A Step 2 needs to actually work — it should handle the case where Homebrew is already installed gracefully
- macOS Tahoe (26) now has a native charge limit slider — acknowledge this in the FAQ but position batt as offering more control and the toggle workflow
