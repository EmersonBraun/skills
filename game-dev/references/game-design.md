# Game Design Reference

Comprehensive game design reference covering document templates, design frameworks, player psychology, economy design, level design, and production planning.

---

## GDD Template (Game Design Document)

Every mechanic or system gets its own GDD. Each GDD must have these 8 required sections:

### Structure

```markdown
# [Mechanic/System Name]

> **Status**: Draft | In Review | Approved | Implemented
> **Author**: [Author]
> **Last Updated**: [Date]
> **Implements Pillar**: [Which game pillar this supports]

## 1. Overview
[One paragraph explaining this mechanic to someone who knows nothing about the
project. What is it, what does the player do, and why does it exist?]

## 2. Player Fantasy
[What should the player FEEL when engaging with this mechanic? What is the
emotional or power fantasy being served? This section guides all detail
decisions below.]

## 3. Detailed Design

### Core Rules
[Precise, unambiguous rules. A programmer should be able to implement this
section without asking questions. Use numbered rules for sequential processes
and bullet points for properties.]

### States and Transitions
[If this system has states, document every state and every valid transition.]

| State | Entry Condition | Exit Condition | Behavior |
|-------|----------------|----------------|----------|

### Interactions with Other Systems
[How does this system interact with other systems? For each interaction,
specify: what data flows in, what flows out, who is responsible for what.]

## 4. Formulas
[Every mathematical formula used by this system.]

### [Formula Name]
result = base_value * (1 + modifier_sum) * scaling_factor

| Variable | Type | Range | Source | Description |
|----------|------|-------|--------|-------------|

**Expected output range**: [min] to [max]
**Edge case**: [Clamping and boundary behavior]

## 5. Edge Cases
[What happens in unusual situations. Each edge case must have a clear resolution.]

| Scenario | Expected Behavior | Rationale |
|----------|------------------|-----------|

## 6. Dependencies
[Every system this mechanic depends on or that depends on this mechanic.]

| System | Direction | Nature of Dependency |
|--------|-----------|---------------------|

## 7. Tuning Knobs
[Every value that should be adjustable for balancing.]

| Parameter | Current Value | Safe Range | Effect of Increase | Effect of Decrease |
|-----------|--------------|------------|-------------------|-------------------|

## 8. Acceptance Criteria
[Testable criteria that confirm this mechanic is working as designed.]

- [ ] [Criterion 1: specific, measurable, testable]
- [ ] Performance: System update completes within [X]ms
- [ ] No hardcoded values in implementation
```

### Visual/Audio Requirements (Optional Section)

| Event | Visual Feedback | Audio Feedback | Priority |
|-------|----------------|---------------|----------|

### UI Requirements (Optional Section)

| Information | Display Location | Update Frequency | Condition |
|-------------|-----------------|-----------------|-----------|

### Open Questions (Optional Section)

| Question | Owner | Deadline | Resolution |
|----------|-------|----------|-----------|

---

## MDA Framework (Mechanics, Dynamics, Aesthetics)

The MDA Framework (Hunicke, LeBlanc, Zubek, 2004) is the foundational lens for game design. Design from aesthetics backward to mechanics.

### The 8 Aesthetic Categories

| Aesthetic | What the Player Feels | Example Games |
|-----------|----------------------|---------------|
| **Sensation** | Sensory pleasure, visual/audio delight | Journey, Flower, Tetris Effect |
| **Fantasy** | Make-believe, role-playing, being someone else | Skyrim, The Witcher, Animal Crossing |
| **Narrative** | Drama, story arc, emotional journey | The Last of Us, Disco Elysium |
| **Challenge** | Obstacle mastery, skill testing, overcoming | Dark Souls, Celeste, Super Meat Boy |
| **Fellowship** | Social connection, cooperation, community | It Takes Two, Monster Hunter, MMOs |
| **Discovery** | Exploration, secrets, understanding systems | Outer Wilds, Breath of the Wild |
| **Expression** | Self-expression, creativity, identity | Minecraft, Sims, Dreams |
| **Submission** | Relaxation, comfort, low-stress engagement | Stardew Valley, Euro Truck Sim |

### How to Apply MDA

1. **Rank target aesthetics** for your game (primary, secondary, tertiary)
2. **Define desired dynamics** -- what emergent behaviors should arise?
3. **Design mechanics** that produce those dynamics and deliver those aesthetics
4. **Validate**: Does playing the mechanic produce the target feeling?

### MDA Alignment Checklist

- Does every core mechanic serve at least one target aesthetic?
- Do mechanics reinforce each other or create conflicts?
- Are there mechanics that serve aesthetics we DON'T target? (Cut candidates)
- Does the overall experience feel coherent across all aesthetics?

---

## Player Psychology

### Bartle Player Types (Bartle, 1996)

Four motivational profiles that exist on two axes: Acting vs. Interacting, Players vs. World.

| Type | Motivation | Wants | Design For Them With |
|------|-----------|-------|---------------------|
| **Achiever** | Points, status, completion | Goals, rewards, progression, leaderboards | Achievement systems, collectibles, clear milestones, completion percentages |
| **Explorer** | Knowledge, discovery, understanding | Hidden content, lore, systemic depth | Secrets, optional content, emergent systems, environmental storytelling |
| **Socializer** | Relationships, community | Communication, cooperation, shared spaces | Chat, guilds, co-op mechanics, trading, emotes, shared goals |
| **Killer** | Domination, competition | PvP, rankings, proving superiority | Competitive modes, leaderboards, PvP arenas, skill expression |

**Design tip**: Most games serve 1-2 types primarily. Trying to serve all 4 equally often results in serving none well. Identify your primary type and design the core loop for them.

### Flow State (Csikszentmihalyi, 1990)

Flow is the optimal experience state where challenge perfectly matches skill.

**Flow Channel Design**:
```
Difficulty
    ^
    |        /  ANXIETY
    |       / /
    |      / / FLOW CHANNEL
    |     / /
    |    / /  BOREDOM
    |   / /
    +--/--------> Player Skill
```

**Flow Requirements**:
1. **Clear goals**: The player always knows what they're trying to do
2. **Immediate feedback**: Every action has visible, understandable results
3. **Challenge-skill balance**: Not too easy (boredom), not too hard (anxiety)
4. **Sense of control**: The player feels their actions matter
5. **Concentration**: No unnecessary distractions during flow moments
6. **Intrinsic motivation**: The activity is rewarding in itself

**Flow Design Patterns**:
- Ramp difficulty gradually (no sudden spikes)
- Provide optional challenges for skilled players (higher skill ceiling)
- Allow recovery from failure quickly (short reload times, nearby checkpoints)
- Design intentional flow breaks for pacing (cutscenes, safe areas, shops)
- Use adaptive difficulty cautiously (players notice rubber-banding)

### Self-Determination Theory (Deci & Ryan, 1985)

Three innate psychological needs that drive intrinsic motivation:

| Need | Definition | Game Design Application |
|------|-----------|------------------------|
| **Autonomy** | Feeling of choice and self-direction | Multiple valid strategies, player-driven goals, open-ended problems, meaningful choices with consequences |
| **Competence** | Feeling of mastery and effectiveness | Clear skill progression, fair difficulty curve, visible improvement, satisfying feedback loops |
| **Relatedness** | Feeling of connection to others | Co-op mechanics, NPCs with personality, community features, shared experiences, emotional narratives |

**SDT Diagnostic Questions**:
- Does the player feel in control of their experience? (Autonomy)
- Does the player feel like they're getting better? (Competence)
- Does the player feel connected to something larger? (Relatedness)

If any answer is "no," that's a design weakness to address.

### Ludonarrative Consonance

Mechanics and narrative must reinforce each other. When mechanics contradict narrative themes (ludonarrative dissonance), players feel the disconnect even if they can't articulate it.

**Test**: If the story says "every life matters," do the mechanics reward killing? If the narrative emphasizes friendship, do mechanics pit players against each other? Align them.

---

## Game Economy Design Patterns

### Sink/Faucet Model

Every game economy is a system of resource sources (faucets) and drains (sinks). A healthy economy keeps these in balance.

**Faucets** (sources of currency/resources):
- Quest rewards, enemy drops, daily logins, achievements, crafting, trading

**Sinks** (drains of currency/resources):
- Purchases, repair costs, crafting costs, respec fees, consumables, taxes

**Balance Target**: Sink-to-source ratio of 0.7-0.9 (slight surplus keeps players feeling wealthy)

### Key Economy Metrics

| Metric | Healthy Target | Warning Signs |
|--------|---------------|---------------|
| Time to first meaningful purchase | 5-15 minutes | Too long = frustration, too short = no value |
| Hourly earn rate (mid-game) | Sustainable for session length | Too high = inflation, too low = grind |
| Days to max level (F2P) | 30-90 days | Too fast = no retention, too slow = churn |
| Premium conversion rate | 2-5% | <1% = nothing worth buying, >10% = pay-to-win concerns |
| Gold Gini coefficient | <0.4 | >0.5 = wealth too concentrated |

### Loot Table Design

- **Common** (60%): Always useful, never feels bad to receive
- **Uncommon** (25%): Noticeable upgrade, satisfying
- **Rare** (12%): Exciting, build-defining, celebration moment
- **Legendary** (3%): Game-changing, memorable, shareable
- **Pity timer**: Guarantee drops within X attempts to prevent extreme bad luck

### Ethical Guardrails

- No pay-to-win: premium currency cannot buy gameplay power advantages
- Pity timers on all random drops
- Transparent drop rates displayed to players
- Spending limits for minor accounts
- No artificial scarcity pressure (FOMO timers) on essential items

---

## Level Design Principles

### Pacing

Levels should alternate between intensity and rest. Use this pattern:
```
Intensity: Low -> Medium -> High -> Rest -> Medium -> High -> CLIMAX -> Resolution
```

Never sustain maximum intensity for more than 2-3 encounters without a break.

### The Nintendo Method (Introduce, Develop, Twist, Conclude)

1. **Introduce**: Show the mechanic in a safe environment
2. **Develop**: Combine with existing knowledge in moderate-risk scenarios
3. **Twist**: Surprise the player with an unexpected application
4. **Conclude**: Let the player demonstrate mastery in a challenging finale

### Spatial Design Principles

- **Sight lines**: Players should always see their next objective or a landmark
- **Breadcrumbing**: Use rewards, lighting, and enemy placement to guide without explicit markers
- **Weenies** (Walt Disney term): Tall, visible landmarks that draw players forward
- **Safe spaces**: Visually distinct rest areas where players feel secure (warm colors, ambient sounds, no enemies)
- **Chokepoints and arenas**: Clearly telegraph combat areas with environmental cues

### Level Documentation

Every level needs:
- Narrative context (where in the story, emotional target)
- Layout diagram (critical path + optional paths)
- Encounter list with difficulty ratings
- Pacing chart showing intensity over time
- Audio and visual direction
- Technical notes (object count, streaming zones, performance concerns)

---

## Difficulty Curve Design

### Principles

- Difficulty should generally increase, but not linearly
- Include periodic difficulty dips for pacing (valleys between peaks)
- The hardest challenge should come 70-80% through the game, not at the end
- The final challenge should test mastery of combined skills, not introduce new ones
- Always provide clear feedback on WHY the player failed

### Difficulty Tiers (Accessibility)

| Tier | Target Player | Adjustments |
|------|--------------|-------------|
| Easy/Story | Wants narrative, low stress | More health, weaker enemies, generous checkpoints, optional hints |
| Normal | Average engagement | Default balance, the "designed" experience |
| Hard | Wants challenge | Less health, smarter AI, fewer resources, stricter timing |
| Custom | Wants control | Individual sliders for damage, speed, resources, assist features |

### Assist Features (Best Practice)

- Invincibility toggle (Celeste model)
- Adjustable game speed (slow-motion option)
- Skip encounter option (after N failures)
- Visual assists (colorblind modes, high-contrast)
- Input assists (hold vs. toggle, remapping, one-handed mode)

---

## Sprint/Milestone Planning for Games

### Sprint Structure (1-2 Weeks)

```
Sprint [N] -- [Start Date] to [End Date]

Sprint Goal: [One sentence: what does this sprint achieve?]

Capacity:
| Resource | Available Days | Allocated | Buffer (20%) |
|----------|---------------|-----------|-------------|

Tasks (prioritized):
| Must Have | (Critical path -- sprint fails without these)
| Should Have | (Important but sprint survives without them)
| Nice to Have | (Cut first if time runs out)
```

### Milestone Structure

| Milestone | What It Proves |
|-----------|---------------|
| **Concept** | The idea is compelling and feasible |
| **Vertical Slice** | The core loop is fun (one complete area, polished) |
| **Alpha** | All features in, content placeholder, everything playable |
| **Beta** | Content complete, polish pass, feature-frozen |
| **Release Candidate** | Ship-ready, all bugs triaged |
| **Gold/Launch** | Released to players |

### Definition of Done (Per Sprint)

- All Must Have tasks completed and passing acceptance criteria
- No S1 or S2 bugs in delivered features
- Code reviewed and merged
- Design documents updated for any deviations from spec
- Test cases written and executed for all new features
- Asset naming and format standards met

### Estimation Guidelines

- Always include 20% buffer for unknowns
- Break tasks into 1-3 day chunks (anything larger needs decomposition)
- Track carryover from previous sprints (recurring carryover = estimation problem)
- Sprint velocity stabilizes after 3-4 sprints -- don't trust early estimates
