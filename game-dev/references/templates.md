# Game Development Document Templates

Ready-to-use templates for game development documents. Copy the template, fill in the bracketed placeholders, and remove the instructional comments.

---

## 1. Game Design Document (GDD)

```markdown
# [Mechanic/System Name]

> **Status**: Draft | In Review | Approved | Implemented
> **Author**: [Agent or person]
> **Last Updated**: [Date]
> **Implements Pillar**: [Which game pillar this supports]

## Overview

[One paragraph that explains this mechanic to someone who knows nothing about
the project. What is it, what does the player do, and why does it exist?]

## Player Fantasy

[What should the player FEEL when engaging with this mechanic? What is the
emotional or power fantasy being served? This section guides all detail
decisions below.]

## Detailed Design

### Core Rules

[Precise, unambiguous rules. A programmer should be able to implement this
section without asking questions. Use numbered rules for sequential processes
and bullet points for properties.]

### States and Transitions

[If this system has states (e.g., weapon states, status effects, phases),
document every state and every valid transition between states.]

| State | Entry Condition | Exit Condition | Behavior |
|-------|----------------|----------------|----------|

### Interactions with Other Systems

[How does this system interact with combat? Inventory? Progression? UI?
For each interaction, specify the interface: what data flows in, what flows
out, and who is responsible for what.]

## Formulas

[Every mathematical formula used by this system. For each formula:]

### [Formula Name]

    result = base_value * (1 + modifier_sum) * scaling_factor

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|
| base_value | float | 1-100 | data file | The base amount before modifiers |
| modifier_sum | float | -0.9 to 5.0 | calculated | Sum of all active modifiers |
| scaling_factor | float | 0.5-2.0 | data file | Level-based scaling |

**Expected output range**: [min] to [max]
**Edge case**: When modifier_sum < -0.9, clamp to -0.9 to prevent negative results.

## Edge Cases

[Explicitly document what happens in unusual situations. Each edge case
should have a clear resolution.]

| Scenario | Expected Behavior | Rationale |
|----------|------------------|-----------|
| [What if X is zero?] | [This happens] | [Because of this reason] |
| [What if both effects trigger?] | [Priority rule] | [Design reasoning] |

## Dependencies

[List every system this mechanic depends on or that depends on this mechanic.]

| System | Direction | Nature of Dependency |
|--------|-----------|---------------------|
| [Combat] | This depends on Combat | Needs damage calculation results |
| [Inventory] | Inventory depends on this | Provides item effect data |

## Tuning Knobs

[Every value that should be adjustable for balancing. Include the current
value, the safe range, and what happens at the extremes.]

| Parameter | Current Value | Safe Range | Effect of Increase | Effect of Decrease |
|-----------|--------------|------------|-------------------|-------------------|

## Visual/Audio Requirements

[What visual and audio feedback does this mechanic need?]

| Event | Visual Feedback | Audio Feedback | Priority |
|-------|----------------|---------------|----------|

## UI Requirements

[What information needs to be displayed to the player and when?]

| Information | Display Location | Update Frequency | Condition |
|-------------|-----------------|-----------------|-----------|

## Acceptance Criteria

[Testable criteria that confirm this mechanic is working as designed.]

- [ ] [Criterion 1: specific, measurable, testable]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] Performance: System update completes within [X]ms
- [ ] No hardcoded values in implementation

## Open Questions

[Anything not yet decided. Each question should have an owner and deadline.]

| Question | Owner | Deadline | Resolution |
|----------|-------|----------|-----------|
```

---

## 2. Architecture Decision Record (ADR)

```markdown
# ADR-[NNNN]: [Title]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-XXXX]

## Date

[YYYY-MM-DD]

## Decision Makers

[Who was involved in this decision]

## Context

### Problem Statement

[What problem are we solving? Why must this decision be made now? What is the
cost of not deciding?]

### Current State

[How does the system work today? What is wrong with the current approach?]

### Constraints

- [Technical constraints -- engine limitations, platform requirements]
- [Timeline constraints -- deadline pressures, dependencies]
- [Resource constraints -- team size, expertise available]
- [Compatibility requirements -- must work with existing systems]

### Requirements

- [Functional requirement 1]
- [Functional requirement 2]
- [Performance requirement -- specific, measurable]
- [Scalability requirement]

## Decision

[The specific technical decision, described in enough detail for someone to
implement it without further clarification.]

### Architecture

    [ASCII diagram showing the system architecture this decision creates.
    Show components, data flow direction, and key interfaces.]

### Key Interfaces

    [Pseudocode or language-specific interface definitions that this decision
    creates. These become the contracts that implementers must respect.]

### Implementation Guidelines

[Specific guidance for the programmer implementing this decision.]

## Alternatives Considered

### Alternative 1: [Name]

- **Description**: [How this approach would work]
- **Pros**: [What is good about this approach]
- **Cons**: [What is bad about this approach]
- **Estimated Effort**: [Relative effort compared to chosen approach]
- **Rejection Reason**: [Why this was not chosen]

### Alternative 2: [Name]

[Same structure as above]

## Consequences

### Positive

- [Good outcomes of this decision]

### Negative

- [Trade-offs and costs we are accepting]

### Neutral

- [Changes that are neither good nor bad, just different]

## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|-----------|

## Performance Implications

| Metric | Before | Expected After | Budget |
|--------|--------|---------------|--------|
| CPU (frame time) | [X]ms | [Y]ms | [Z]ms |
| Memory | [X]MB | [Y]MB | [Z]MB |
| Load Time | [X]s | [Y]s | [Z]s |
| Network (if applicable) | [X]KB/s | [Y]KB/s | [Z]KB/s |

## Migration Plan

[If this changes existing systems, the step-by-step plan to migrate.]

1. [Step 1 -- what changes, what breaks, how to verify]
2. [Step 2]
3. [Step 3]

**Rollback plan**: [How to revert if this decision proves wrong]

## Validation Criteria

[How we will know this decision was correct after implementation.]

- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [Performance criterion]

## Related

- [Link to related ADRs]
- [Link to related design documents]
- [Link to relevant code files]
```

---

## 3. Sprint Plan

```markdown
# Sprint [N] -- [Start Date] to [End Date]

## Sprint Goal

[One sentence: what does this sprint achieve toward the current milestone?]

## Milestone Context

- **Current Milestone**: [Name]
- **Milestone Deadline**: [Date]
- **Sprints Remaining**: [N]

## Capacity

| Resource | Available Days | Allocated | Buffer (20%) | Remaining |
|----------|---------------|-----------|-------------|-----------|
| Programming | | | | |
| Design | | | | |
| Art | | | | |
| Audio | | | | |
| QA | | | | |
| **Total** | | | | |

## Tasks

### Must Have (Critical Path)

| ID | Task | Owner | Est. Days | Dependencies | Acceptance Criteria | Status |
|----|------|-------|-----------|-------------|-------------------|--------|
| S[N]-001 | | | | None | | Not Started |
| S[N]-002 | | | | S[N]-001 | | Not Started |

### Should Have

| ID | Task | Owner | Est. Days | Dependencies | Acceptance Criteria | Status |
|----|------|-------|-----------|-------------|-------------------|--------|
| S[N]-010 | | | | | | Not Started |

### Nice to Have (Cut First)

| ID | Task | Owner | Est. Days | Dependencies | Acceptance Criteria | Status |
|----|------|-------|-----------|-------------|-------------------|--------|
| S[N]-020 | | | | | | Not Started |

## Carryover from Sprint [N-1]

| Original ID | Task | Reason for Carryover | New Estimate | Priority Change |
|------------|------|---------------------|-------------|----------------|

## Risks to This Sprint

| Risk | Probability | Impact | Mitigation | Owner |
|------|------------|--------|-----------|-------|

## External Dependencies

| Dependency | Status | Impact if Delayed | Contingency |
|-----------|--------|------------------|-------------|

## Definition of Done

- [ ] All Must Have tasks completed and passing acceptance criteria
- [ ] No S1 or S2 bugs in delivered features
- [ ] Code reviewed and merged to develop
- [ ] Design documents updated for any deviations from spec
- [ ] Test cases written and executed for all new features
- [ ] Asset naming and format standards met

## Daily Status Tracking

| Day | Tasks Completed | Tasks In Progress | Blockers | Notes |
|-----|----------------|------------------|----------|-------|
| Day 1 | | | | |
| Day 2 | | | | |
| Day 3 | | | | |
```

---

## 4. Bug Report

```markdown
# BUG-[NNNN]: [Short Title]

## Severity

[S1-Critical | S2-Major | S3-Minor | S4-Cosmetic]

## Priority

[P1-Immediate | P2-Next Sprint | P3-Backlog | P4-Won't Fix]

## Environment

- **Build**: [Version/commit hash]
- **Platform**: [PC/Console/Mobile]
- **Engine Version**: [Version]

## Description

[Clear, concise description of what is wrong.]

## Steps to Reproduce

1. [Step 1]
2. [Step 2]
3. [Step 3]

**Reproduction Rate**: [Always | Intermittent (X/10) | Rare]

## Expected Behavior

[What should happen]

## Actual Behavior

[What actually happens]

## Evidence

[Screenshots, video links, or log snippets]

## Impact

- **Gameplay Impact**: [What is broken for the player?]
- **Affected Systems**: [Which systems are involved?]
- **Workaround**: [Is there a temporary workaround?]

## Root Cause (if known)

[Technical analysis of why this happens]

## Fix Verification

- [ ] Bug no longer reproduces
- [ ] No regression in related systems
- [ ] Performance not degraded
- [ ] Design intent preserved

## History

| Date | Action | By |
|------|--------|-----|
| [Date] | Filed | [Name] |
```

---

## 5. Playtest Feedback

```markdown
# Playtest Report: [Session Name/Date]

## Session Info

| Field | Value |
|-------|-------|
| **Date** | [Date] |
| **Build** | [Version] |
| **Duration** | [X minutes] |
| **Testers** | [Number and type: internal, external, target audience] |
| **Focus Area** | [What was being tested] |
| **Hypothesis** | [What we expected to learn] |

## Key Findings

### Critical Issues (Blocks Fun)

1. [Issue]: [Description] -- Observed in [X/Y] sessions
2. [Issue]: [Description]

### Major Observations

1. [Finding]: [Description and evidence]
2. [Finding]: [Description and evidence]

### Positive Signals

1. [What worked well]: [Evidence]
2. [What worked well]: [Evidence]

## Metrics (if tracked)

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Session length | [X min] | [Y min] | [Met/Under/Over] |
| Completion rate | [X%] | [Y%] | [Status] |
| Deaths per area | [X] | [Y] | [Status] |
| Time to first "aha" moment | [X min] | [Y min] | [Status] |

## Player Quotes

[Direct quotes from testers that capture the experience]

- "[Quote 1]" -- Tester context
- "[Quote 2]" -- Tester context

## Recommendations

### Immediate Actions

1. [Action]: [Why and expected impact]

### Next Playtest Focus

1. [What to test next based on findings]

## Raw Notes

[Unfiltered observations during the session]
```

---

## 6. Technical Design Document (TDD)

```markdown
# Technical Design: [System Name]

## Document Status
- **Version**: 1.0
- **Last Updated**: [Date]
- **Author**: [Name]
- **Reviewer**: [Name]
- **Related ADR**: [ADR-XXXX if applicable]
- **Related Design Doc**: [Link to game design doc this implements]

## Overview
[2-3 sentence summary of what this system does and why it exists]

## Requirements

### Functional Requirements
- [FR-1]: [Description]
- [FR-2]: [Description]

### Non-Functional Requirements
- **Performance**: [Budget -- e.g., "< 1ms per frame"]
- **Memory**: [Budget -- e.g., "< 50MB at peak"]
- **Scalability**: [Limits -- e.g., "Support up to 1000 entities"]
- **Thread Safety**: [Requirements]

## Architecture

### System Diagram

    [ASCII diagram showing components and data flow]

### Component Breakdown

| Component | Responsibility | Owns |
| --------- | -------------- | ---- |
| [Name] | [What it does] | [What data it owns] |

### Public API

    [Interface/API definition in pseudocode or target language]

### Data Structures

    [Key data structures with field descriptions]

### Data Flow

[Step by step: how data moves through the system during a typical frame]

## Implementation Plan

### Phase 1: [Core Functionality]
- [ ] [Task 1]
- [ ] [Task 2]

### Phase 2: [Extended Features]
- [ ] [Task 3]
- [ ] [Task 4]

### Phase 3: [Optimization/Polish]
- [ ] [Task 5]

## Dependencies

| Depends On | For What |
| ---------- | -------- |
| [System] | [Reason] |

| Depended On By | For What |
| -------------- | -------- |
| [System] | [Reason] |

## Testing Strategy

- **Unit Tests**: [What to test at unit level]
- **Integration Tests**: [Cross-system tests needed]
- **Performance Tests**: [Benchmarks to create]
- **Edge Cases**: [Specific scenarios to test]

## Known Limitations

[What this design intentionally does NOT support and why]

## Future Considerations

[What might need to change if requirements evolve -- but do NOT build for this now]
```

---

## 7. Economy Balance Sheet

```markdown
# Economy Model: [System Name]

*Created: [Date]*
*Owner: [Name]*
*Status: [Draft / Balanced / Live]*

## Overview

[What resources, currencies, and exchange systems does this economy cover?
What player behaviors does it incentivize?]

## Currencies

| Currency | Type | Earn Rate | Sink Rate | Cap | Notes |
| ---- | ---- | ---- | ---- | ---- | ---- |
| [Gold] | Soft | [per hour] | [per hour] | [max or none] | [Primary transaction currency] |
| [Gems] | Premium | [per day F2P] | [varies] | [max] | [Premium currency, purchasable] |
| [XP] | Progression | [per action] | [level-up cost] | [none] | [Cannot be traded] |

### Currency Rules
- [Rule 1]
- [Rule 2]

## Sources (Faucets)

| Source | Currency | Amount | Frequency | Conditions |
| ---- | ---- | ---- | ---- | ---- |
| [Quest completion] | Gold | [50-200] | [per quest] | [Scales with difficulty] |
| [Enemy drops] | Gold | [1-10] | [per kill] | [Modified by luck stat] |
| [Daily login] | Gems | [5] | [daily] | [Streak bonus: +1 per day] |

## Sinks (Drains)

| Sink | Currency | Cost | Frequency | Purpose |
| ---- | ---- | ---- | ---- | ---- |
| [Equipment purchase] | Gold | [100-5000] | [as needed] | [Power progression] |
| [Repair costs] | Gold | [10-100] | [per death] | [Death penalty, gold drain] |
| [Cosmetic shop] | Gems | [50-500] | [optional] | [Vanity, premium sink] |

## Balance Targets

| Metric | Target | Rationale |
| ---- | ---- | ---- |
| Time to first meaningful purchase | [X minutes] | [Feel spending power early] |
| Hourly earn rate (mid-game) | [X/hr] | [Based on session length] |
| Days to max level (F2P) | [X days] | [Retain without frustrating] |
| Sink-to-source ratio | [0.7-0.9] | [Slight surplus feels wealthy] |

## Progression Curves

### Level XP Requirements

| Level | XP Required | Cumulative XP | Estimated Time |
| ---- | ---- | ---- | ---- |
| 1-2 | [100] | [100] | [10 min] |
| 5-6 | [500] | [1,500] | [2 hrs] |
| 10-11 | [1,500] | [7,500] | [8 hrs] |

*Formula*: `XP(n) = [formula, e.g., 100 * n^1.5]`

### Item Price Scaling
*Formula*: `Price(tier) = [formula, e.g., base_price * 2^(tier-1)]`

## Loot Tables

### [Drop Source Name]

| Item | Rarity | Drop Rate | Pity Timer | Notes |
| ---- | ---- | ---- | ---- | ---- |
| [Common item] | Common | [60%] | [N/A] | [Always useful] |
| [Uncommon item] | Uncommon | [25%] | [N/A] | [Noticeable upgrade] |
| [Rare item] | Rare | [12%] | [10 drops] | [Build-defining] |
| [Legendary item] | Legendary | [3%] | [30 drops] | [Game-changing] |

### Pity System
[Describe how the pity system prevents extreme bad luck streaks.]

## Economy Health Metrics

| Metric | Healthy Range | Warning Threshold | Action if Breached |
| ---- | ---- | ---- | ---- |
| Average player gold | [X-Y at level Z] | [>Y or <X] | [Adjust faucets/sinks] |
| Gold Gini coefficient | [<0.4] | [>0.5] | [Wealth too concentrated] |
| % hitting currency cap | [<5%] | [>10%] | [Raise cap or add sinks] |

## Ethical Guardrails

- No pay-to-win: premium currency cannot buy gameplay power advantages
- Pity timers on all random drops: guaranteed outcome within X attempts
- Transparent drop rates displayed to players
- Spending limits for minor accounts
- No artificial scarcity pressure (FOMO timers) on essential items

## Dependencies

- Depends on: [combat balance, quest design, crafting system]
- Affects: [difficulty curve, player retention, monetization]
```

---

## 8. Game Concept Document

```markdown
# Game Concept: [Working Title]

*Created: [Date]*
*Status: [Draft / Under Review / Approved]*

## Elevator Pitch

> [1-2 sentences. Format: "It's a [genre] where you [core action] in a
> [setting] to [goal]."]

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | [Primary genre + subgenre(s)] |
| **Platform** | [PC / Console / Mobile / Cross-platform] |
| **Target Audience** | [See Player Profile below] |
| **Player Count** | [Single / Co-op / Multiplayer] |
| **Session Length** | [10 min / 30 min / 1 hr / 2+ hr] |
| **Monetization** | [Premium / F2P / none yet] |
| **Estimated Scope** | [Small (1-3 mo) / Medium (3-9 mo) / Large (9+ mo)] |
| **Comparable Titles** | [2-3 existing games] |

## Core Fantasy

[What power, experience, or feeling does the player get? What can they do
here that they can't do anywhere else?]

## Unique Hook

[What makes this different from everything else in its genre? Must pass the
"and also" test: "It's like [game], AND ALSO [unique thing]."]

## Player Experience Analysis (MDA Framework)

### Target Aesthetics

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| Sensation | [1-8 or N/A] | [How] |
| Fantasy | [Priority] | [How] |
| Narrative | [Priority] | [How] |
| Challenge | [Priority] | [How] |
| Fellowship | [Priority] | [How] |
| Discovery | [Priority] | [How] |
| Expression | [Priority] | [How] |
| Submission | [Priority] | [How] |

### Key Dynamics
[What behaviors should emerge from mechanics?]

### Core Mechanics
1. [Mechanic 1]
2. [Mechanic 2]
3. [Mechanic 3]

## Player Motivation Profile

### Self-Determination Theory

| Need | How Satisfied | Strength |
| ---- | ---- | ---- |
| Autonomy | [How?] | [Core / Supporting / Minimal] |
| Competence | [How?] | [Core / Supporting / Minimal] |
| Relatedness | [How?] | [Core / Supporting / Minimal] |

### Bartle Player Types

- [ ] **Achievers** -- How: [...]
- [ ] **Explorers** -- How: [...]
- [ ] **Socializers** -- How: [...]
- [ ] **Killers/Competitors** -- How: [...]

### Flow State Design

- **Onboarding curve**: [First 10 minutes]
- **Difficulty scaling**: [How challenge grows]
- **Feedback clarity**: [How player knows they're improving]
- **Recovery from failure**: [How quickly they try again]

## Core Loop

### Moment-to-Moment (30 seconds)
[Most basic repeated action. Must be intrinsically satisfying.]

### Short-Term (5-15 minutes)
[Objective cycle. "One more turn" psychology.]

### Session-Level (30-120 minutes)
[Full session arc. Natural stopping point + reason to return.]

### Long-Term Progression
[Days/weeks growth. What the player works toward.]

### Retention Hooks
- **Curiosity**: [Unanswered questions, locked content]
- **Investment**: [Progress, characters they care about]
- **Social**: [Friends, guilds, shared goals]
- **Mastery**: [Skills to improve, challenges to overcome]

## Game Pillars

### Pillar 1: [Name]
[Non-negotiable design principle]
*Design test*: [Decision it resolves]

### Pillar 2: [Name]
[Definition]
*Design test*: [Decision it resolves]

### Pillar 3: [Name]
[Definition]
*Design test*: [Decision it resolves]

### Anti-Pillars
- **NOT [thing]**: [Why excluded]
- **NOT [thing]**: [Why]

## Inspiration and References

| Reference | What We Take | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| Age range | [e.g., 18-35] |
| Gaming experience | [Casual / Mid-core / Hardcore] |
| Time availability | [Session patterns] |
| Platform preference | [Where they play] |
| Current games | [2-3 titles] |
| Unmet need | [What they're looking for] |
| Dealbreakers | [What would turn them away] |

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| Recommended Engine | [Godot / Unity / Unreal and why] |
| Key Technical Challenges | [What's hard?] |
| Art Style | [Pixel / 2D / 3D stylized / 3D realistic] |
| Networking | [None / P2P / Client-Server / Dedicated] |

## MVP Definition

**Core hypothesis**: [Single statement the MVP tests]

**Required for MVP**:
1. [Essential feature 1]
2. [Essential feature 2]
3. [Essential feature 3]

### Scope Tiers

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| MVP | [Minimal] | [Core loop only] | [X weeks] |
| Vertical Slice | [One area] | [Core + progression] | [X weeks] |
| Alpha | [All areas, placeholder] | [All features, rough] | [X weeks] |
| Full Vision | [Complete] | [All features, polished] | [X weeks] |
```

---

## 9. Pitch Document

```markdown
# Game Pitch: [Title]

*Version: [Draft Number]*
*Date: [Date]*

## The Hook

> [One powerful sentence that makes people curious.]

## What Is It?

[2-3 sentences: genre, setting, core mechanic, what makes it special.]

## Why Now?

[Market trends, audience gaps, technology enablers, cultural relevance.]

## Target Audience

**Primary**: [Specific audience]
**Secondary**: [Adjacent audience]
**Market Size**: [Estimated TAM from comparable titles]

## Comparable Titles

| Title | Similarity | Our Differentiation | Commercial Performance |
| ---- | ---- | ---- | ---- |

## Core Experience

### Player Fantasy
[What player gets to BE or DO]

### Core Loop (30 seconds)
[Primary activity]

### Session Flow (30 minutes)
[Typical session start to finish]

### Progression Hook
[Why players come back tomorrow]

## Key Features

1. **[Feature]**: [Description and player value]
2. **[Feature]**: [Description]
3. **[Feature]**: [Description]

## Visual Identity

**Art Style**: [Description with references]

## Audio Identity

**Music**: [Direction]
**SFX**: [Direction]

## Business Model

| Aspect | Plan |
| ---- | ---- |
| Model | [Premium / F2P] |
| Platforms | [Steam, Console, Mobile] |
| Price Point | [$X.XX] |
| DLC/Expansion Plans | [Post-launch strategy] |

## Development Plan

| Milestone | Duration | Deliverable |
| ---- | ---- | ---- |
| Concept | [X weeks] | Concept, pillars, vertical slice plan |
| Vertical Slice | [X weeks] | Playable slice |
| Alpha | [X weeks] | All features, content placeholder |
| Beta | [X weeks] | Content complete, polish |
| Launch | [Date] | Release build |

**Team Size**: [X people]
**Engine**: [Engine]

## Risks and Mitigation

| Risk | Likelihood | Impact | Mitigation |
| ---- | ---- | ---- | ---- |

## The Ask

[What you need: funding, publishing, team members, feedback.]
```

---

## 10. Level Design Document

```markdown
# Level: [Level Name]

## Quick Reference

- **Area/Region**: [Where in the game world]
- **Type**: [Combat / Exploration / Puzzle / Hub / Boss / Mixed]
- **Estimated Play Time**: [X-Y minutes]
- **Difficulty**: [1-10 relative scale]
- **Prerequisite**: [What player must have done to reach this level]
- **Status**: [Concept | Layout | Graybox | Art Pass | Polish | Final]

## Narrative Context

- **Story Moment**: [Where in the narrative arc]
- **Narrative Purpose**: [What story beat this delivers]
- **Emotional Target**: [What the player should feel]
- **Lore Discoveries**: [World-building the player can find here]

## Layout

### Overview Map

    [ASCII diagram using: [S]=Start, [E]=Exit, [C]=Combat, [P]=Puzzle,
     [R]=Reward, [!]=Story, [?]=Secret, [>]=One-way, [=]=Two-way,
     [@]=NPC, [B]=Boss]

### Critical Path
1. Player enters at [S]
2. [Description]
3. Player exits at [E]

### Optional Paths

| Path | Access Requirement | Reward | Discovery Hint |
|------|-------------------|--------|---------------|

## Encounters

### Combat Encounters

| ID | Position | Enemy Composition | Difficulty | Arena Notes |
|----|----------|------------------|-----------|-------------|

### Non-Combat Encounters

| ID | Position | Type | Description | Solution Hint |
|----|----------|------|-------------|---------------|

## Pacing Chart

    Intensity
    10 |                              *
     8 |                         *   * *
     6 |            *  *        * * *   *
     4 |     *  *  * ** *   *  *
     2 | * ** ** *        * * *          *
     0 |S-----------------------------------------E

## Audio Direction

| Zone/Moment | Music | Ambience | Key SFX |
|-------------|-------|----------|---------|

## Visual Direction

- **Lighting**: [Description]
- **Color Palette**: [Colors and why]
- **Landmarks**: [Navigation aids]
- **Sight Lines**: [What player sees from key positions]

## Collectibles and Secrets

| Item | Location | Visibility | Hint | Required For |
|------|----------|-----------|------|-------------|

## Technical Notes

- **Estimated Object Count**: [N]
- **Streaming Zones**: [Where to break for streaming]
- **Performance Concerns**: [Heavy areas]
- **Required Systems**: [Active game systems]
```

---

## 11. Test Plan

```markdown
# Test Plan: [Feature/System Name]

## Overview

- **Feature**: [Name]
- **Design Doc**: [Link]
- **Implementation**: [Link to code or PR]
- **Author**: [QA owner]
- **Date**: [Date]
- **Priority**: [Critical / High / Medium / Low]

## Scope

### In Scope
- [What is being tested]

### Out of Scope
- [What is NOT being tested and why]

### Dependencies
- [Systems that must work for tests to be valid]

## Test Environment

- **Build**: [Minimum build version]
- **Platform**: [Target platforms]
- **Preconditions**: [Required game state]

## Test Cases

### Functional Tests -- Happy Path

| ID | Test Case | Steps | Expected Result | Status |
|----|-----------|-------|----------------|--------|

### Functional Tests -- Edge Cases

| ID | Test Case | Steps | Expected Result | Status |
|----|-----------|-------|----------------|--------|

### Negative Tests

| ID | Test Case | Steps | Expected Result | Status |
|----|-----------|-------|----------------|--------|

### Integration Tests

| ID | Test Case | Systems Involved | Steps | Expected | Status |
|----|-----------|-----------------|-------|----------|--------|

### Performance Tests

| ID | Test Case | Metric | Budget | Steps | Status |
|----|-----------|--------|--------|-------|--------|

### Regression Tests

| ID | Related Bug | Test Case | Steps | Expected | Status |
|----|------------|-----------|-------|----------|--------|

## Test Results Summary

| Category | Total | Passed | Failed | Blocked | Skipped |
|----------|-------|--------|--------|---------|---------|

## Bugs Found

| Bug ID | Severity | Test Case | Description | Status |
|--------|----------|-----------|-------------|--------|

## Sign-Off

- **QA Tester**: [Name] -- [Date]
- **QA Lead**: [Name] -- [Date]
- **Feature Owner**: [Name] -- [Date]
```
