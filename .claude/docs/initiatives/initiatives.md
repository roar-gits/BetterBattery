# Initiatives

Time-bound work streams. Unlike permanent reference docs, these track active projects.

## Active

| Initiative | File | Status |
|------------|------|--------|
<!-- CUSTOMIZE: Add active initiatives -->

## Completed

| Initiative | Outcome |
|------------|---------|
<!-- CUSTOMIZE: Move completed initiatives here -->

---

## Creating an Initiative

1. Create a new file: `initiative-name.md`
2. Include a status table at the top
3. Track progress with checkboxes
4. Update frequently during work

---

## Completing an Initiative

When an initiative completes:

1. Ensure key decisions are documented in the `## Decisions` section
2. Add a `## Retrospective` section with lessons learned
3. Move entry to "Completed" table above
4. Archive to `archive/` directory (initiative file IS the decision record)

---

## Template

```markdown
<!-- Last updated: YYYY-MM-DD | Status: Active -->

# Initiative: [Title]

## Overview

Brief description of what this initiative accomplishes.

**Goal**: [One-sentence success criteria]
**Owner**: [Who is driving this]
**Started**: YYYY-MM-DD
**Target completion**: YYYY-MM-DD

---

## Status

| Phase | Status |
|-------|--------|
| Phase 1: [Name] | Complete |
| Phase 2: [Name] | In Progress |
| Phase 3: [Name] | Pending |

---

## Decisions

<!-- Add decisions as they're made during work -->

| Date | Decision | Context | Implications |
|------|----------|---------|--------------|
| YYYY-MM-DD | [What was decided] | [Why this option over alternatives] | [What this affects going forward] |

---

## Phase Details

### Phase 1: [Name] - COMPLETE

**Goal**: [What this phase accomplishes]

- [x] Completed task
- [x] Completed task

**Outcome**: [What was delivered]

---

### Phase 2: [Name] - IN PROGRESS

**Goal**: [What this phase accomplishes]

- [x] Completed task
- [ ] Current task
- [ ] Pending task

**Blockers**: [If any]

---

### Phase 3: [Name] - PENDING

**Goal**: [What this phase accomplishes]

**Prerequisites**: [What must finish first]

---

## Cross-Project References

<!-- CUSTOMIZE: Uncomment if this initiative spans multiple projects -->
<!--
| Resource | Location | Purpose |
|----------|----------|---------|
| Source code | `../other-project/src/` | Reference implementation |
| Database schema | `../other-project/docs/schema.md` | Schema definitions |
| API specs | `../other-project/docs/api/` | Endpoint documentation |
-->

---

## Credentials

<!-- CUSTOMIZE: Add if initiative needs specific credentials -->
<!--
| Credential | Purpose | How to verify |
|------------|---------|---------------|
| API_KEY | Access service X | `echo $API_KEY` |
-->

---

## Notes

Ongoing observations, blockers, decisions made.

---

## Retrospective

<!-- Fill in when initiative completes -->

### What Went Well
- [Success 1]
- [Success 2]

### What Could Improve
- [Improvement 1]
- [Improvement 2]

### Key Learnings
- [Learning 1]
- [Learning 2]

### Follow-up Actions
- [ ] [Action item 1]
- [ ] [Action item 2]
```

---

## Tips

- **Decisions**: Record key decisions as you make them - the initiative file IS the decision record
- **Multi-phase initiatives**: Use the phase structure above for work spanning weeks
- **Cross-project work**: Document references to other projects in a table
- **Credentials**: List initiative-specific credentials if different from project defaults
- **Retrospectives**: Always capture learnings - they inform future work
