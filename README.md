# Skills

[![Validate Skills](https://github.com/EmersonBraun/skills/actions/workflows/validate-skills.yml/badge.svg)](https://github.com/EmersonBraun/skills/actions/workflows/validate-skills.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Skills: 21](https://img.shields.io/badge/Skills-21-green.svg)](#skills-by-category)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./CONTRIBUTING.md)

**From idea to revenue** — [Agent Skills](https://agentskills.io/) for the one-man army.

21 production-grade skills covering ideation, product, development, go-to-market, and operations. Built for solo founders, startup developers, and anyone who needs to wear every hat.

Compatible with **Claude Code, Cursor, Copilot, VS Code, OpenCode, Gemini CLI, Codex, Roo Code, Kiro**, and [30+ other tools](https://agentskills.io/).

## Install

```bash
npx skills add EmersonBraun/skills
```

Install a single skill:

```bash
npx skills add EmersonBraun/skills/founder
```

## The Journey: From Zero to Revenue

Each step links to a skill. Use them in order or jump to what you need.

| Step | Skill | What It Does |
|------|-------|-------------|
| 1. Validate | [`idea-validation`](./idea-validation) | Is this idea worth building? Market analysis, competitors, feasibility. |
| 2. Brainstorm | [`brainstorm`](./brainstorm) | Generate ideas, explore possibilities, creative frameworks. |
| 3. Stress-test | [`grill-me`](./grill-me) | Relentless questioning until your plan has no holes. |
| 4. Strategy | [`founder`](./founder) | Startup strategy: MVP, PMF, growth, fundraising, unit economics. |
| 5. Spec | [`write-a-prd`](./write-a-prd) | Create product requirements through user interview and codebase exploration. |
| 6. Plan | [`prd-to-issues`](./prd-to-issues) | Break PRDs into independently-grabbable GitHub issues. |
| 7. Architect | [`software-architect`](./software-architect) | System design, tech stack, C4 diagrams, ADRs. |
| 8. Build frontend | [`senior-frontend`](./senior-frontend) | Pixel-perfect, accessible interfaces with Next.js + Tailwind + shadcn/ui. |
| 9. Build backend | [`senior-backend`](./senior-backend) | Production-grade APIs, database modeling, auth, security. |
| 10. Test | [`senior-qa`](./senior-qa) | Test suite generation, coverage analysis, E2E testing. |
| 11. Review | [`code-review`](./code-review) | Multi-agent PR review with confidence scoring. |
| 12. Deploy | [`devops-deploy`](./devops-deploy) | Docker, CI/CD, cloud deploy, monitoring. |
| 13. Brand | [`branding`](./branding) | Color palette, typography, tone of voice, design tokens. |
| 14. Launch page | [`landing-page`](./landing-page) | High-conversion landing pages with copy that converts. |
| 15. SEO | [`seo`](./seo) | Technical SEO, keywords, schema markup, Core Web Vitals. |
| 16. Market | [`marketing`](./marketing) | Full-stack marketing: audits, email, social, ads, launches. |
| 17. Measure | [`analytics`](./analytics) | Product metrics, tracking plans, dashboards. |
| 18. Comply | [`legal-compliance`](./legal-compliance) | Privacy policy, terms of service, GDPR/LGPD templates. |

**Workflow orchestrator:** [`dev-workflow`](./dev-workflow) automates steps 5-11 end-to-end.

## Skills by Category

### Ideation

| Skill | Description |
|-------|-------------|
| [`idea-validation`](./idea-validation) | Validate business ideas: market analysis, competitor mapping, TAM/SAM/SOM, feasibility scoring. |
| [`brainstorm`](./brainstorm) | Divergent thinking sessions: SCAMPER, How Might We, Crazy 8s, mind mapping. |
| [`grill-me`](./grill-me) | Stress-test plans and designs through relentless questioning. |

### Product

| Skill | Description |
|-------|-------------|
| [`founder`](./founder) | Strategic consultant: idea validation, MVP, PMF, growth, fundraising, unit economics. |
| [`write-a-prd`](./write-a-prd) | Create PRDs through user interview, codebase exploration, and module design. |
| [`prd-to-issues`](./prd-to-issues) | Break PRDs into independently-grabbable GitHub issues using tracer-bullet slices. |

### Development

| Skill | Description |
|-------|-------------|
| [`software-architect`](./software-architect) | System design, C4 diagrams, tech stack selection, ADRs. |
| [`senior-frontend`](./senior-frontend) | Pixel-perfect, accessible, animated interfaces with Next.js + Tailwind + shadcn/ui. |
| [`senior-backend`](./senior-backend) | Production-grade APIs, database modeling, auth patterns, security. |
| [`senior-qa`](./senior-qa) | Test suite generation, coverage analysis, E2E testing with Playwright. |
| [`dev-workflow`](./dev-workflow) | End-to-end development lifecycle orchestrator. |
| [`code-review`](./code-review) | Multi-agent PR review with confidence scoring and blast-radius analysis. |
| [`improve-codebase-architecture`](./improve-codebase-architecture) | Find architectural improvement opportunities as GitHub issue RFCs. |

### Infrastructure

| Skill | Description |
|-------|-------------|
| [`devops-deploy`](./devops-deploy) | Docker, CI/CD, cloud deploy (Vercel, Railway, Fly.io, AWS), monitoring. |

### Go-to-Market

| Skill | Description |
|-------|-------------|
| [`branding`](./branding) | Brand identity: colors (OKLCH), typography, tone of voice, design tokens. |
| [`landing-page`](./landing-page) | High-conversion landing pages with copy frameworks and CTA optimization. |
| [`marketing`](./marketing) | Full-stack marketing: audits, email sequences, social calendars, ad campaigns, SEO, launches. |
| [`seo`](./seo) | Technical SEO, on-page optimization, schema markup, Core Web Vitals. |

### Operations

| Skill | Description |
|-------|-------------|
| [`analytics`](./analytics) | Product metrics, event tracking, dashboards, AARRR framework. |
| [`legal-compliance`](./legal-compliance) | Terms of service, privacy policy, GDPR/LGPD, cookie consent templates. |

### Content

| Skill | Description |
|-------|-------------|
| [`video-creator`](./video-creator) | Create videos from scratch using ffmpeg and Python. |
| [`video-editor`](./video-editor) | Edit existing videos with ffmpeg: trim, concat, subtitles, batch processing. |

## Skill Dependency Graph

```
dev-workflow (orchestrates the full dev cycle)
├── write-a-prd
├── prd-to-issues
├── software-architect
├── senior-frontend
├── senior-backend
├── senior-qa
└── code-review

founder ←→ marketing (strategy ↔ execution)

senior-frontend + branding (identity → implementation)
```

## Also Available On

- [SkillUse](https://github.com/skilluse/skilluse) — `skilluse install EmersonBraun/skills`
- [ClawHub](https://www.clawhub.com) — Browse and install via registry

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines on adding or improving skills.

## License

MIT
