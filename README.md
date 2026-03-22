# Skills

[![Validate Skills](https://github.com/EmersonBraun/skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/EmersonBraun/skills/actions/workflows/validate-skills.yml)

[Agent Skills](https://agentskills.io/) for founders, frontend engineering, dev workflow, QA, code review, architecture, and video production.

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
| **[senior-frontend](./senior-frontend)** | World-class design engineering. Pixel-perfect, accessible, animated interfaces with Next.js + Tailwind + shadcn/ui. Supersedes `web-design-guidelines`. |
| **[senior-qa](./senior-qa)** | Comprehensive QA and testing. Test suite generation, coverage analysis, E2E scaffolding with Playwright. |
| **[video-creator](./video-creator)** | Create videos from scratch using ffmpeg and Python. Slideshows, reels, demos, tutorials, motion graphics. |
| **[video-editor](./video-editor)** | Edit existing videos with ffmpeg. Trim, concat, subtitles, compression, color grading, batch processing. |
| **[grill-me](./grill-me)** | Interview you relentlessly about a plan or design until reaching shared understanding. Stress-test your ideas. |

### Workflow Orchestrators

| Skill | Orchestrates | Description |
|-------|-------------|-------------|
| **[dev-workflow](./dev-workflow)** | `write-a-prd` → `prd-to-issues` → `senior-qa` → `code-review` | End-to-end development lifecycle. PRD to merged PR, fully autonomous. |

### Building Blocks

Used by workflow skills or independently:

| Skill | Description |
|-------|-------------|
| **[code-review](./code-review)** | Multi-agent PR review with confidence scoring. Checks bugs, CLAUDE.md compliance, git history, and previous PR comments. |
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
```

## Also Available On

- [SkillUse](https://github.com/skilluse/skilluse) — `skilluse install EmersonBraun/skills`
- [ClawHub](https://www.clawhub.com) — Browse and install via registry

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on adding or improving skills.

## License

MIT
