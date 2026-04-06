# Contributing

Thanks for your interest in contributing to this skills collection! This project follows the open [Agent Skills](https://agentskills.io/) standard.

## Adding a New Skill

1. Create a new directory at the repo root with your skill name (lowercase, hyphens only):

```
my-skill/
├── SKILL.md          # Required
├── references/       # Optional: detailed docs loaded on demand
├── scripts/          # Optional: executable helpers
└── assets/           # Optional: templates, resources
```

2. Write your `SKILL.md` with proper frontmatter:

```yaml
---
name: my-skill
description: "Clear description of what it does and when to trigger. Include keywords for auto-detection."
---
```

3. Follow the [Agent Skills specification](https://agentskills.io/specification):
   - `name` must match the directory name exactly
   - `name`: lowercase alphanumeric + hyphens, 1-64 chars, no leading/trailing/consecutive hyphens
   - `description`: 1-1024 chars, describe both what and when
   - Keep `SKILL.md` body under 500 lines
   - Move detailed content to `references/` files

4. All content must be in **English**

5. Open a Pull Request with a clear description of what the skill does

## Modifying an Existing Skill

1. Fork the repo and create a branch
2. Make your changes
3. Test the skill locally:
   ```bash
   npx skills add /path/to/local/repo
   ```
4. Open a PR explaining the improvement

## Skill Organization

### By Category

| Category | Skills |
|----------|--------|
| **Ideation** | `idea-validation`, `brainstorm`, `grill-me` |
| **Product** | `founder`, `write-a-prd`, `prd-to-issues` |
| **Development** | `software-architect`, `senior-frontend`, `senior-backend`, `senior-qa`, `dev-workflow`, `code-review`, `improve-codebase-architecture` |
| **Infrastructure** | `devops-deploy` |
| **Go-to-Market** | `branding`, `landing-page`, `marketing`, `seo` |
| **Operations** | `analytics`, `legal-compliance` |
| **Content** | `video-creator`, `video-editor` |

### Workflow Orchestrator

- `dev-workflow` — Orchestrates: `write-a-prd` → `prd-to-issues` → `software-architect` → `senior-frontend` + `senior-backend` → `senior-qa` → `code-review`

## Quality Guidelines

- **Be opinionated**: Good skills encode expert knowledge, not generic advice
- **Be specific**: Include concrete examples, templates, and checklists
- **Be modular**: Use `references/` for detailed content, keep SKILL.md focused
- **Be practical**: Include scripts in `scripts/` for repeatable tasks
- **Don't depend on AI**: Skills should encode domain knowledge, not wrap AI prompts

## Code of Conduct

Be respectful, constructive, and focused on making skills better for everyone.
