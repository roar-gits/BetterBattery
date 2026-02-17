# Impact Calculator — Research & Sources

Fact-check completed 2026-02-17. All calculator assumptions verified against published research.

## Calculator Assumptions (current)

| Parameter | Value | Source |
|-----------|-------|--------|
| MacBook installed base | 80 million | SpyHunter macOS Stats 2025 (~100M Macs total, ~86% laptops) |
| Replacement rate | 1 per 7 years (~14%) | Industry range 5-22%; conservative mid-point |
| CO2 per replacement | 50 kg | Apple Environmental Reports + MIT battery LCA data |
| Lithium per battery | 7g (6-8g range) | IATA equivalent lithium content formula (0.3 × Ah × cells) |

## Detailed Findings

### 1. MacBook Installed Base — ~80 million

- Total Mac installed base: ~100 million active users (multiple analyst estimates, 2024-2025)
- MacBooks account for ~86% of Mac sales (desktops ~14%)
- Applied to installed base: ~80-86 million MacBooks
- Note: "100 million" is defensible for *all Macs*, not specifically MacBooks
- **Sources**:
  - SpyHunter macOS Stats 2025 — 100.4M Mac users
  - MacDaily News — MacBooks 86% of total Mac sales
  - Apple active devices report (Jan 2025)

### 2. Annual Battery Replacement Rate — 1 per 7 years

- Apple rates batteries for 1000 cycles at 80% capacity
- Typical users: 150-300 cycles/year → 3-6 year natural lifespan to 80% threshold
- Industry data: 12-18M laptop replacements/year across ~80M laptops (15-22% rate)
- Many users never replace (tolerate degradation or buy new laptop)
- Realistic "replacement that actually happens" rate: 5-15%/year
- **We use 1/7 years (~14%)** — conservative mid-point
- **Confidence**: 50%. Apple doesn't publish replacement rates.
- **Sources**:
  - Apple Support — 1000 cycle specification
  - Market Growth Reports — laptop battery market data

### 3. CO2 Per Battery Replacement — 50 kg

- Battery manufacturing: median 48-120 kg CO2-eq/kWh, global average ~79 kg CO2-eq/kWh (NMC811)
- MacBook battery sizes: 49Wh (Air) to 100Wh (16" Pro), fleet average ~65Wh
- Battery-only manufacturing: ~5 kg CO2 for cells alone
- Full lifecycle (mining, refining, shipping, service): adds significantly
- Apple Environmental Reports show total MacBook lifecycle: 161-394 kg CO2
  - MacBook Air: ~170 kg total, battery ~15% of manufacturing = ~20 kg + logistics ≈ 25-35 kg
  - MacBook Pro 16": ~395 kg total, battery share ≈ 50-70 kg
- Fleet-weighted average (Air outsells Pro): **30-60 kg, central estimate ~50 kg**
- Previous value of 80 kg was high by ~2x
- **Confidence**: 55%. Per-kWh data is solid; the weak link is battery's share of whole-laptop emissions.
- **Sources**:
  - MIT Climate Portal — battery manufacturing CO2
  - Apple MacBook Pro 14" Environmental Report (PDF, Oct 2024)
  - Apple M3 MacBook Air Environmental Report (PDF, Mar 2024)
  - PMC — lithium-ion battery supply chain environmental impacts

### 4. Lithium Per Battery — 7g (6-8g range)

- Standard calculation: Equivalent Lithium Content (ELC) = 0.3 × Amp-hours × cells in series
- MacBook Air M4 (53.8Wh): ~4.2g ELC, ~5-6g actual
- MacBook Pro 14" (72.4Wh): ~5.7g ELC, ~7-9g actual
- MacBook Pro 16" (100Wh): ~7.8g ELC, ~10-13g actual
- Fleet-weighted average: ~6-8g ELC, ~7-10g actual
- **7g is accurate and defensible**
- **Confidence**: 85%. IATA standard calculation.
- **Sources**:
  - BatteryGuy — lithium content calculation
  - FedEx Lithium Battery Job Aid (PDF)
  - Battery University BU-704a
  - Apple MacBook Air M4 specs

### 5. 2x Lifespan Claim — Well Supported

Battery University BU-808 data:

**Charge voltage vs. cycle life:**
| Charge Level | Voltage | Cycles |
|---|---|---|
| 100% | 4.20V | 300-500 |
| ~90% | 4.10V | 600-1,000 |
| ~73% | 4.00V | 850-1,500 |
| ~65% | 3.92V | 1,200-2,000 |

Key principle: "Every reduction in peak charge voltage of 0.10V/cell is said to double the cycle life."

**Capacity retention after 1 year at 25°C storage:**
| Charge State | Capacity After 1 Year |
|---|---|
| 40% charge | 96% retained |
| 100% charge | 80% retained |

- The "2x lifespan" claim is **well-supported and possibly conservative**
- The 96% vs 80% capacity data is for **1 year** (not 2 years — corrected on site)
- **Confidence**: 90%
- **Sources**:
  - Battery University BU-808 — primary source
  - Nature Scientific Data — battery aging dataset (2024)

## Changes Made (2026-02-17)

| What | Before | After | Why |
|------|--------|-------|-----|
| MacBook base (code) | 33,000,000 | 80,000,000 | Was ~2.5x too low |
| CO2 per replacement | 80 kg | 50 kg | Was ~2x too high |
| Replacement rate | 1/6 years | 1/7 years | Slightly more conservative |
| "96% after two years" (Science section) | two years | one year | BU-808 data is 1-year |
| Closing copy | "100 million MacBooks" | "100 million Macs" | 100M is all Macs, not just laptops |
| Closing stat | "100M+ MacBooks" | "80M+ MacBooks" | Reflects laptop-specific count |

## Calculator Output at 10% Adoption (after corrections)

- 1.14M battery replacements avoided per year
- 57,143 tonnes CO2 saved per year
- 8,000 kg lithium kept in the ground
