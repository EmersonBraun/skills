---
name: remotion
description: "Programmatic video creation with Remotion (React). Use when user mentions Remotion, React video, programmatic video, animated video with React, video composition, video rendering, @remotion packages, or wants to create videos using React components. Also triggers on 'render video with React', 'create video composition', 'animated explainer video', 'social media video with code'. Prefer this over video-creator when the user is in a React/TypeScript project or wants component-based video creation."
metadata:
  author: EmersonBraun
  version: "1.0.0"
---

# Remotion — Programmatic Video with React

You are an expert in Remotion, the framework for building videos with React and TypeScript. You create data-driven, component-based videos that are reproducible, parameterizable, and renderable via CLI or API.

## When to Use Remotion vs ffmpeg

| Concern | Use Remotion | Use ffmpeg |
|---|---|---|
| Video construction | Component-based, React-driven layouts | File-level splice, trim, concat |
| Data-driven content | Props, JSON schemas, calculateMetadata | Not suitable |
| Animations | Spring, interpolate, frame-accurate | Limited (xfade, overlay) |
| Text/captions | Styled React components, word highlighting | drawtext filter |
| Iteration speed | Hot-reload in Remotion Studio | Re-run full command |
| Batch at scale | renderMedia() API + queue | Shell loops, GNU parallel |
| Simple file edits | Overkill | Correct tool |
| Audio manipulation | <Audio>, volume interpolation | ffmpeg audio filters |

**Rule of thumb**: Remotion for dynamic, data-driven, or animation-heavy content. ffmpeg for file manipulation, batch conversion, and silence removal.

## Project Setup

```bash
# Bootstrap a new project
npx create-video@latest

# Key packages
npx remotion add @remotion/media          # <Video>, <Audio>, <Img>
npx remotion add @remotion/transitions    # Scene transitions
npx remotion add @remotion/captions       # Subtitle/caption utilities
npx remotion add @remotion/google-fonts   # Google Fonts loader
npx remotion add @remotion/fonts          # Local font loader
npx remotion add @remotion/zod-types      # Color picker and Zod integration

# Dev server (Remotion Studio)
npx remotion studio

# Render
npx remotion render <CompositionId> output.mp4
```

## Core Concepts

### Composition

The root unit of a Remotion video. Defines component, resolution, FPS, and duration.

```tsx
// src/Root.tsx
import { Composition } from 'remotion';
import { MyVideo } from './MyVideo';

export const RemotionRoot = () => (
  <Composition
    id="MyVideo"
    component={MyVideo}
    durationInFrames={300}
    fps={30}
    width={1920}
    height={1080}
    defaultProps={{ title: 'Hello World' }}
  />
);
```

### useCurrentFrame + useVideoConfig

The two fundamental hooks. All animations MUST be driven by `useCurrentFrame()`. CSS transitions and Tailwind animate classes are forbidden — they do not render correctly.

```tsx
import { useCurrentFrame, useVideoConfig, interpolate, spring } from 'remotion';

const frame = useCurrentFrame();
const { fps, durationInFrames, width, height } = useVideoConfig();

// Linear interpolation (always clamp to avoid overshoot)
const opacity = interpolate(frame, [0, 2 * fps], [0, 1], { extrapolateRight: 'clamp' });

// Spring animation (natural, physics-based)
const scale = spring({ frame, fps, config: { damping: 200 } });
```

### Sequence

The primary tool for timeline scheduling. `useCurrentFrame()` returns a local frame (starts at 0) inside any Sequence.

```tsx
import { Sequence } from 'remotion';

// Always premount to preload assets
<Sequence from={0} durationInFrames={60} premountFor={fps}>
  <TitleCard />
</Sequence>
<Sequence from={60} durationInFrames={90} premountFor={fps}>
  <BodySlide />
</Sequence>
```

### Series

Use `<Series>` when scenes play back-to-back without computing offsets manually.

```tsx
import { Series } from 'remotion';

<Series>
  <Series.Sequence durationInFrames={60}><Intro /></Series.Sequence>
  <Series.Sequence durationInFrames={90}><MainContent /></Series.Sequence>
  <Series.Sequence durationInFrames={30}><Outro /></Series.Sequence>
</Series>
```

### interpolate + spring

```tsx
// Spring configs
const smooth  = { damping: 200 };           // No bounce — use for reveals
const snappy  = { damping: 20, stiffness: 200 }; // UI elements
const bouncy  = { damping: 8 };             // Playful entrances
const heavy   = { damping: 15, stiffness: 80, mass: 2 };

// Map spring output to arbitrary range
const y = interpolate(spring({ frame, fps }), [0, 1], [100, 0]);

// Easing
import { Easing } from 'remotion';
const eased = interpolate(frame, [0, 60], [0, 1], {
  easing: Easing.inOut(Easing.quad),
  extrapolateLeft: 'clamp',
  extrapolateRight: 'clamp',
});
```

## Key Patterns

### Frame-Based Animation

Write all timings in seconds, multiply by `fps`:

```tsx
const ENTER_START = 0;
const ENTER_DURATION = 1.5 * fps;
const HOLD_START = ENTER_DURATION;
const EXIT_START = durationInFrames - 1 * fps;

const enterProgress = spring({ frame: frame - ENTER_START, fps, config: { damping: 200 } });
const exitProgress  = spring({ frame: frame - EXIT_START,  fps, config: { damping: 200 } });
const scale = enterProgress - exitProgress;
```

### Data-Driven Compositions

Pass a JSON schema as props; use `calculateMetadata` to set duration dynamically:

```tsx
import { CalculateMetadataFunction } from 'remotion';

const calculateMetadata: CalculateMetadataFunction<Props> = async ({ props }) => {
  const totalFrames = props.scenes.reduce((sum, s) => sum + s.durationInFrames, 0);
  return { durationInFrames: totalFrames };
};

<Composition
  id="DynamicVideo"
  component={DynamicVideo}
  calculateMetadata={calculateMetadata}
  defaultProps={{ scenes: [] }}
  durationInFrames={300} // placeholder
  fps={30} width={1080} height={1920}
/>
```

### Zod Schema for Parameterization

```tsx
import { z } from 'zod'; // must be exactly zod@3.22.3
import { zColor } from '@remotion/zod-types';

export const VideoSchema = z.object({
  title: z.string(),
  accentColor: zColor(),
  durationSecs: z.number().min(5).max(60),
});
```

### Audio Sync

```tsx
import { Audio, Sequence } from 'remotion';
import { staticFile } from 'remotion';

// Music bed for full composition
<Sequence from={0} durationInFrames={totalFrames}>
  <Audio src={staticFile('music-bed.mp3')} volume={0.6} loop />
</Sequence>

// SFX cue at a specific frame
<Sequence from={sfxFrame}>
  <Audio src={staticFile('whoosh.mp3')} volume={0.9} />
</Sequence>

// Volume interpolation (fade in)
<Audio
  src={staticFile('narration.mp3')}
  volume={(f) => interpolate(f, [0, fps], [0, 1], { extrapolateRight: 'clamp' })}
/>
```

### Director DSL Pattern

For complex, structured videos, define a typed script DSL and drive a single composition from it. See `references/advanced-patterns.md` for the full DirectorScript approach from the video-generator codebase.

### Transitions

```tsx
import { TransitionSeries, linearTiming, springTiming } from '@remotion/transitions';
import { fade } from '@remotion/transitions/fade';
import { slide } from '@remotion/transitions/slide';
import { wipe } from '@remotion/transitions/wipe';

<TransitionSeries>
  <TransitionSeries.Sequence durationInFrames={90}>
    <SceneA />
  </TransitionSeries.Sequence>
  <TransitionSeries.Transition
    presentation={slide({ direction: 'from-left' })}
    timing={springTiming({ config: { damping: 200 }, durationInFrames: 20 })}
  />
  <TransitionSeries.Sequence durationInFrames={90}>
    <SceneB />
  </TransitionSeries.Sequence>
</TransitionSeries>
```

Note: transitions shorten total duration. `60 + 60 - 15 (overlap) = 105` frames total.

### Captions / Subtitles

```tsx
import { createTikTokStyleCaptions, parseSrt } from '@remotion/captions';
import type { Caption } from '@remotion/captions';

// Word-level highlighting
const { pages } = createTikTokStyleCaptions({
  captions,
  combineTokensWithinMilliseconds: 1200,
});

// Per-page sequence with active-word highlighting
{pages.map((page, i) => (
  <Sequence key={i} from={Math.floor(page.startMs / 1000 * fps)} durationInFrames={...}>
    {page.tokens.map(token => {
      const isActive = token.fromMs <= currentMs && token.toMs > currentMs;
      return <span style={{ color: isActive ? '#39E508' : 'white' }}>{token.text}</span>;
    })}
  </Sequence>
))}
```

## Rendering

### Remotion Studio (dev)
```bash
npx remotion studio
```

### CLI render
```bash
npx remotion render MyComposition output.mp4
npx remotion render MyComposition output.mp4 --props='{"title":"Hello"}'
```

### renderMedia() API (programmatic)
```ts
import { bundle } from '@remotion/bundler';
import { renderMedia, selectComposition } from '@remotion/renderer';

const bundled = await bundle({ entryPoint: './src/index.ts' });
const composition = await selectComposition({
  serveUrl: bundled,
  id: 'MyComposition',
  inputProps: { title: 'Hello' },
});
await renderMedia({
  composition,
  serveUrl: bundled,
  codec: 'h264',
  outputLocation: 'output.mp4',
  inputProps: { title: 'Hello' },
});
```

## Fonts

```tsx
// Google Fonts (recommended)
import { loadFont } from '@remotion/google-fonts/Inter';
const { fontFamily } = loadFont('normal', { weights: ['400', '700'], subsets: ['latin'] });

// Local font
import { loadFont } from '@remotion/fonts';
import { staticFile } from 'remotion';
await loadFont({ family: 'MyFont', url: staticFile('MyFont.woff2'), weight: '400' });
```

## Images

Always use `<Img>` from `remotion`, never native `<img>`:

```tsx
import { Img, staticFile } from 'remotion';
<Img src={staticFile('photo.png')} style={{ width: 500, height: 300, objectFit: 'cover' }} />
```

Use `delayRender` / `continueRender` for async image loading.

## Tailwind

Tailwind can be used in Remotion projects if installed. Never use `transition-*` or `animate-*` classes — always drive animations via `useCurrentFrame()`.

## Reference Files

- `references/best-practices.md` — Consolidated performance, audio, transition, and rendering best practices
- `references/advanced-patterns.md` — Director DSL, AudioLayer, silence removal, transcription, overlay compositor
