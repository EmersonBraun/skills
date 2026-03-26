# Skills

[![Validate Skills](https://github.com/EmersonBraun/skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/EmersonBraun/skills/actions/workflows/validate-skills.yml)

[Agent Skills](https://agentskills.io/) for founders, marketing, frontend engineering, game development, dev workflow, QA, code review, architecture, and video production.

Compatible with **Claude Code, Cursor, Copilot, VS Code, OpenCode, Gemini CLI, Codex, Roo Code, Kiro**, and [30+ other tools](https://agentskills.io/).

## Install

```bash
npx skills add EmersonBraun/skills
```

Install a single skill:

```bash
npx skills add EmersonBraun/skills/founder
```

## Available Skills

### Standalone

| Skill | Description |
|-------|-------------|
| **[founder](./founder)** | Strategic consultant for startup founders. Idea validation, MVP, PMF, growth, fundraising, unit economics, go-to-market. |
| **[senior-frontend](./senior-frontend)** | World-class design engineering. Pixel-perfect, accessible, animated interfaces with Next.js + Tailwind + shadcn/ui. Anti-AI-slop patterns, OKLCH color, motion rules. Supersedes `web-design-guidelines`. |
| **[game-dev](./game-dev)** | Game development for Godot 4, Unity, and Unreal Engine 5. GDD templates, MDA framework, engine-specific coding standards, production workflows. |
| **[remotion](./remotion)** | Programmatic video creation with Remotion (React). Compositions, data-driven video, Director DSL, audio patterns, advanced rendering. |
| **[senior-qa](./senior-qa)** | Comprehensive QA and testing. Test suite generation, coverage analysis, E2E scaffolding with Playwright. |
| **[video-creator](./video-creator)** | Create videos from scratch using ffmpeg and Python. Slideshows, reels, demos, tutorials, motion graphics, silence removal. |
| **[video-editor](./video-editor)** | Edit existing videos with ffmpeg. Trim, concat, subtitles, overlay compositing, transcript-based editing, batch processing. |
| **[marketing](./marketing)** | Full-stack marketing execution. Audits, copywriting, email sequences, social calendars, ad campaigns, funnel analysis, SEO, brand voice, launch playbooks. Complements `founder`. |
| **[grill-me](./grill-me)** | Interview you relentlessly about a plan or design until reaching shared understanding. Stress-test your ideas. |

### Workflow Orchestrators

| Skill | Orchestrates | Description |
|-------|-------------|-------------|
| **[dev-workflow](./dev-workflow)** | `write-a-prd` → `prd-to-issues` → `senior-qa` → `code-review` | End-to-end development lifecycle. Spec-driven with structured templates, clarification pass, and constitution support. |

### Building Blocks

Used by workflow skills or independently:

| Skill | Description |
|-------|-------------|
| **[code-review](./code-review)** | Multi-agent PR review with confidence scoring, blast-radius analysis, and structured output. |
| **[write-a-prd](./write-a-prd)** | Create PRDs through user interview, codebase exploration, and module design. Submit as GitHub issue. |
| **[prd-to-issues](./prd-to-issues)** | Break PRDs into independently-grabbable GitHub issues using tracer-bullet vertical slices. |
| **[improve-codebase-architecture](./improve-codebase-architecture)** | Find architectural improvement opportunities. Module-deepening refactors as GitHub issue RFCs. |
| **[web-design-guidelines](./web-design-guidelines)** | Review UI code for Web Interface Guidelines compliance. Accessibility, UX, best practices. |

## Skill Dependency Graph

```
dev-workflow
├── write-a-prd
├── prd-to-issues
├── senior-qa
└── code-review

senior-frontend
└── supersedes: web-design-guidelines

founder ←→ marketing (strategy ↔ execution)

remotion
└── complements: video-creator, video-editor
```

## Also Available On

- [SkillUse](https://github.com/skilluse/skilluse) — `skilluse install EmersonBraun/skills`
- [ClawHub](https://www.clawhub.com) — Browse and install via registry

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on adding or improving skills.

## License

MIT
