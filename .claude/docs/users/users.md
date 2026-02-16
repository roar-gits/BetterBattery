# User Research

User documentation organized by Jobs To Be Done framework.

---

## Quick Start

### 1. Define User Types

Create a directory for each major user category:

```
users/
├── README.md          (this file)
├── _templates/        (optional)
├── customers/
│   └── README.md      (strategic summary)
└── providers/
    └── README.md      (strategic summary)
```

### 2. Add Personas

One file per persona, combining profile + jobs:

```
customers/
├── README.md
├── busy-bob.md        # Persona + their 2-3 jobs
└── CU-BOB-001.md      # User story
```

### 3. Story ID Format

`{TYPE}-{PERSONA}-{NUM}` → e.g., `CU-BOB-001`

---

## Philosophy

- **Describe problems, not solutions** - Focus on needs, not features
- **Organize by user type** - Primary navigation dimension
- **Keep personas lean** - 300-400 lines max with embedded jobs

---

## When to Create

Create user documentation when:
- Starting a new product or major feature
- Unclear about who you're building for
- Team needs alignment on user needs

Skip if:
- Solo project with clear target user
- Technical tool with obvious use case
