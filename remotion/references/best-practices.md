# Remotion Best Practices

Consolidated from the remotion-best-practices skill (25 rule files) and real production patterns.

---

## Performance

- **Avoid re-renders**: Move static data (theme objects, font loads, SFX manifests) outside components so they are computed once, not on every frame.
- **Memoize heavy components**: Use `React.memo` and `useMemo` for components that depend only on frame-derived values, not on every render.
- **Use `staticFile()`**: Always reference assets in the `public/` folder via `staticFile('asset.mp3')`. Never use raw relative paths — they break in the renderer.
- **`<Img>` not `<img>`**: Remotion's `<Img>` blocks rendering until the image is loaded, preventing blank frames. The native `<img>` does not.
- **`premountFor` on every Sequence**: Preloads the component before it appears on-screen. Use at least `1 * fps`.
- **No CSS transitions or animations**: They are frame-independent and will not render correctly. All motion must be driven by `useCurrentFrame()`.
- **No Tailwind `animate-*` or `transition-*`**: Same reason — use `interpolate` or `spring` instead.
- **Chain filters in one pass**: When post-processing with ffmpeg, combine filters into a single `-filter_complex` call to avoid multiple re-encodings.

---

## Audio

### Music Beds

Wrap a looping music track in a `<Sequence>` spanning the full composition duration. Keep volume around 0.5–0.7 so it sits under narration:

```tsx
<Sequence from={0} durationInFrames={totalFrames}>
  <Audio src={musicBedSrc} volume={0.6} loop />
</Sequence>
```

### SFX Cues

Place each SFX in its own `<Sequence>` at the exact global frame:

```tsx
{cues.map((cue, i) => (
  <Sequence key={i} from={cue.globalFrame}>
    <Audio src={SFX[cue.sfxName]} volume={cue.volume ?? 0.8} />
  </Sequence>
))}
```

### Volume Interpolation

Use a callback to fade audio in or out:

```tsx
<Audio
  src={staticFile('music.mp3')}
  volume={(f) => interpolate(f, [0, fps, totalFrames - fps, totalFrames], [0, 0.6, 0.6, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  })}
/>
```

### Trimming Audio

Use `trimBefore` / `trimAfter` (in frames) to play only a portion of an audio file:

```tsx
<Audio src={staticFile('long-track.mp3')} trimBefore={2 * fps} trimAfter={10 * fps} />
```

### Pitch Shifting

`toneFrequency` adjusts pitch (0.01–2) without changing playback speed. Only works during server-side rendering:

```tsx
<Audio src={staticFile('voice.mp3')} toneFrequency={1.2} />
```

---

## Transitions

Use `@remotion/transitions` for all scene-to-scene transitions.

```bash
npx remotion add @remotion/transitions
```

### Available Presentations

```tsx
import { fade }      from '@remotion/transitions/fade';
import { slide }     from '@remotion/transitions/slide';
import { wipe }      from '@remotion/transitions/wipe';
import { flip }      from '@remotion/transitions/flip';
import { clockWipe } from '@remotion/transitions/clock-wipe';
```

### Timing Strategies

```tsx
import { linearTiming, springTiming } from '@remotion/transitions';

// Linear (constant speed)
linearTiming({ durationInFrames: 20 })

// Spring (organic, settles naturally)
springTiming({ config: { damping: 200 }, durationInFrames: 25 })
```

### Duration Impact

Transitions overlap adjacent sequences — total duration is reduced:

```
total = sum(scene durations) - sum(transition durations)
```

### Overlays (Non-Duration-Affecting)

Use `<TransitionSeries.Overlay>` for effects (like light leaks) that play across a cut without compressing the timeline:

```tsx
import { LightLeak } from '@remotion/light-leaks';

<TransitionSeries.Overlay durationInFrames={20}>
  <LightLeak />
</TransitionSeries.Overlay>
```

Overlays cannot be adjacent to other overlays or transitions.

---

## Captions / Subtitles

### Caption Type

```ts
import type { Caption } from '@remotion/captions';
// { text, startMs, endMs, timestampMs, confidence }
```

### TikTok-Style Pages with Word Highlighting

```tsx
import { createTikTokStyleCaptions } from '@remotion/captions';

const { pages } = createTikTokStyleCaptions({
  captions,
  combineTokensWithinMilliseconds: 1200, // words per page
});

// Per-page rendering with active word highlight
const HIGHLIGHT_COLOR = '#39E508';
{pages.map((page, i) => {
  const startFrame = Math.floor((page.startMs / 1000) * fps);
  return (
    <Sequence key={i} from={startFrame} durationInFrames={...}>
      <div style={{ fontSize: 80, whiteSpace: 'pre' }}>
        {page.tokens.map(token => {
          const absMs = page.startMs + (frame / fps) * 1000;
          const isActive = token.fromMs <= absMs && token.toMs > absMs;
          return <span key={token.fromMs} style={{ color: isActive ? HIGHLIGHT_COLOR : 'white' }}>{token.text}</span>;
        })}
      </div>
    </Sequence>
  );
})}
```

### Importing .srt Files

```tsx
import { parseSrt } from '@remotion/captions';

const response = await fetch(staticFile('subtitles.srt'));
const text = await response.text();
const { captions } = parseSrt({ input: text });
```

### Whitespace Preservation

Caption tokens include leading spaces. Use `whiteSpace: 'pre'` on the container to preserve them correctly.

---

## Rendering

### CLI

```bash
npx remotion render MyComposition output.mp4
npx remotion render MyComposition output.mp4 --props='{"title":"Hello"}'
npx remotion render MyComposition output.mp4 --codec=h264 --crf=18
```

### renderMedia() API

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
  onProgress: ({ progress }) => console.log(`${Math.round(progress * 100)}%`),
});
```

### Props Serialization

All composition props must be JSON-serializable. `Date`, `Map`, `Set`, and `staticFile()` return values are supported. Functions and class instances are not.

### Stills (Single Frames)

```tsx
import { Still } from 'remotion';
<Still id="Thumbnail" component={Thumbnail} width={1280} height={720} />
```

Render with:
```bash
npx remotion still Thumbnail thumbnail.png
```

---

## Font Loading

### Google Fonts (recommended)

```tsx
import { loadFont } from '@remotion/google-fonts/Inter';

const { fontFamily } = loadFont('normal', {
  weights: ['400', '700'],
  subsets: ['latin'],
});
```

Call `loadFont()` at module level (outside components) so it runs once.

### Local Fonts

```tsx
import { loadFont } from '@remotion/fonts';
import { staticFile } from 'remotion';

await Promise.all([
  loadFont({ family: 'MyFont', url: staticFile('MyFont-Regular.woff2'), weight: '400' }),
  loadFont({ family: 'MyFont', url: staticFile('MyFont-Bold.woff2'), weight: '700' }),
]);
```

---

## Image Handling

```tsx
import { Img, staticFile, useDelayRender } from 'remotion';

// Static image
<Img src={staticFile('photo.png')} style={{ objectFit: 'cover' }} />

// Remote image (requires CORS)
<Img src="https://example.com/image.png" />

// Image sequence
const frame = useCurrentFrame();
<Img src={staticFile(`frames/frame${frame}.png`)} />
```

For async image dimension checks, use `getImageDimensions()` inside `calculateMetadata`.

For GIFs, use `<Gif>` from `@remotion/gif`.

---

## Color and Styling

### Tailwind

Use Tailwind for layout and static styling. Never use `transition-*` or `animate-*` classes. Install per [Remotion Tailwind docs](https://www.remotion.dev/docs/tailwind).

### CSS-in-JS / Inline Styles

Prefer inline `style` props for anything that changes per-frame, since CSS classes cannot be driven by frame state:

```tsx
<div style={{
  opacity,
  transform: `scale(${scale}) translateY(${y}px)`,
  background: `linear-gradient(135deg, ${theme.primary}, ${theme.accent})`,
}} />
```

### Theme Systems

Define color themes as typed objects imported at the top level, never inside render functions:

```ts
export const COLOR_THEMES = {
  amber:  { background: '#0a0e14', primary: '#f59e0b', accent: '#fbbf24', text: '#f3f4f6' },
  cyan:   { background: '#0a0e14', primary: '#06b6d4', accent: '#22d3ee', text: '#f3f4f6' },
  // ...
} satisfies Record<string, Theme>;
```

---

## calculateMetadata

Use to make duration, dimensions, or props dynamic before rendering begins:

```tsx
import { CalculateMetadataFunction } from 'remotion';

const calculateMetadata: CalculateMetadataFunction<Props> = async ({ props, abortSignal }) => {
  const data = await fetch(props.dataUrl, { signal: abortSignal }).then(r => r.json());
  return {
    durationInFrames: Math.ceil(data.durationSecs * 30),
    props: { ...props, fetchedData: data },
    defaultOutName: `video-${props.slug}.mp4`,
  };
};
```

---

## FFmpeg in Remotion Projects

Remotion bundles its own ffmpeg — use `bunx remotion ffmpeg` instead of the system binary:

```bash
bunx remotion ffmpeg -ss 00:00:05 -i public/input.mp4 -to 00:00:10 -c:v libx264 -c:a aac public/output.mp4
bunx remotion ffprobe input.mp4
```

Re-encoding is required for frame-accurate trims (stream copy causes frozen frames at the start).

Alternatively, use `trimBefore` / `trimAfter` props on `<Video>` for non-destructive in-composition trimming.
