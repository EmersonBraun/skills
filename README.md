# NoxSkills — Plugin de Skills para Claude Code

Skills curadas para founders, frontend extremo e criacao/edicao de video.

## Skills Incluidas

| Skill | Comando | Descricao |
|-------|---------|-----------|
| **Founder** | `/nox-skills:founder` | Consultor estrategico para startups. Validacao de ideias, MVP, PMF, growth, fundraising, unit economics. |
| **Frontend Extreme** | `/nox-skills:frontend-extreme` | Design engineering de nivel mundial. Next.js + Tailwind + shadcn/ui. Pixel-perfect, acessivel, animado. |
| **Video Creator** | `/nox-skills:video-creator` | Cria videos do zero via ffmpeg/Python. Slideshows, reels, demos, motion graphics. |
| **Video Editor** | `/nox-skills:video-editor` | Edita videos existentes. Corte, legendas, compressao, efeitos, batch processing. |

## Instalacao

```bash
/plugin install https://github.com/EmersonBraun/nox-skills
```

## Uso

Apos instalar, use os comandos diretamente:

```
/nox-skills:founder      → Consultor de startup
/nox-skills:frontend-extreme  → Design engineering
/nox-skills:video-creator     → Criar videos
/nox-skills:video-editor      → Editar videos
```

As skills tambem ativam automaticamente por contexto (ex: mencionar "startup", "MVP", "ffmpeg", "criar video", etc).

## Estrutura

```
nox-skills/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── founder/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── tools-and-stack.md
│   │       ├── fundraising-guide.md
│   │       ├── growth-and-marketing.md
│   │       └── learning-resources.md
│   ├── frontend-extreme/
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── animation-recipes.md
│   │       ├── color-palettes.md
│   │       ├── component-patterns.md
│   │       ├── inspiration-patterns.md
│   │       ├── layout-patterns.md
│   │       └── templates.md
│   ├── video-creator/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── ffmpeg-recipes.md
│   └── video-editor/
│       └── SKILL.md
└── README.md
```

## Licenca

MIT
