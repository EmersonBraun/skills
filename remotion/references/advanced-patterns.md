# Remotion Advanced Patterns

Patterns extracted from the video-generator codebase at
`/Users/rebecabraun/workspace/EmersonBraun/post-generation/video-generator/`.

---

## Director DSL

A typed JSON script drives a single Remotion composition, decoupling content from rendering logic. This enables AI/LLM generation of video scripts without touching React code.

### Core Types (`src/director/types.ts`)

```ts
type Mood = 'energetic' | 'reflective' | 'technical' | 'provocative';
type ColorTheme = 'amber' | 'cyan' | 'green' | 'purple' | 'red';
type LayoutType = 'fullscreen' | 'split' | 'card' | 'code' | 'badge-list' | 'top-bottom' | 'impact';
type TransitionType = 'cut' | 'fade' | 'slideLeft' | 'slideUp' | 'zoom' | 'wipe' | 'glitch' | 'flip' | 'clockWipe' | 'blur' | 'zoomIn';
type ElementType = 'heading' | 'text' | 'badge' | 'code' | 'divider' | 'logo' | 'counter' | 'topic-icon' | 'profile' | 'social-icon' | 'arrow' | 'decorative' | 'stack-viz' | 'array-viz' | 'balance-scale' | 'comparison-table' | 'terminal-session' | 'code-diff' | 'timeline' | 'state-machine' | 'radar-chart';
type EnterAnimation = 'instant' | 'fadeIn' | 'typewriter' | 'typingCursor' | 'wordByWord' | 'scalePunch' | 'slideFromLeft' | 'slideFromRight' | 'slideFromBottom' | 'revealMask' | 'glitchIn' | 'countUp' | 'zoomIn';
type EmphasisEffect = 'shake' | 'pulse' | 'glow' | 'textGlow' | 'handwrittenUnderline';

interface DirectorMeta {
  postDate: string;
  topic: string;
  slug: string;
  mood: Mood;
  duration: 'short' | 'medium' | 'long';
  colorTheme: ColorTheme;
  fps: 30;
  loopEdit?: boolean;
}

interface SfxCue {
  sfx: string;    // key in SFX manifest
  atFrame: number; // relative to scene start
  volume?: number;
}

interface Scene {
  id: string;
  duration: number; // in frames
  layout: LayoutType;
  transition: { in: TransitionType; out?: TransitionOutType };
  background?: 'solid' | 'gradient' | 'pattern-dots' | 'pattern-grid';
  backgroundFilter?: 'none' | 'sepia';
  decorative?: 'particles' | 'stars-field' | 'spinning-globe' | 'orbit-rings' | 'floating-nodes' | 'rocket' | 'spotlight-vignette';
  elements: SceneElement[];
  platform?: 'instagram' | 'twitter' | 'youtube';
  sfxCues?: SfxCue[];
}

interface DirectorScript {
  meta: DirectorMeta;
  scenes: Scene[];
}
```

### DirectorComposition Pattern (`src/director/DirectorComposition.tsx`)

A single composition iterates scenes, accumulates frame offsets, and wraps each scene in a `<Sequence>`. An `<AudioLayer>` runs alongside at the top level:

```tsx
export const DirectorComposition: React.FC<{ script: DirectorScript }> = ({ script }) => {
  const theme = COLOR_THEMES[script.meta.colorTheme];
  let frameOffset = 0;

  return (
    <AbsoluteFill style={{ backgroundColor: theme.background }}>
      {script.scenes.map((scene) => {
        const start = frameOffset;
        frameOffset += scene.duration;
        return (
          <Sequence key={scene.id} from={start} durationInFrames={scene.duration}>
            <SceneRenderer scene={scene} theme={theme} />
          </Sequence>
        );
      })}
      <AudioLayer script={script} />
    </AbsoluteFill>
  );
};
```

---

## AudioLayer Pattern (`src/director/audio/AudioLayer.tsx`)

Separates audio concerns entirely from the visual scene tree. Computes global frame offsets for SFX cues in a pre-render loop, then renders them as `<Sequence>` + `<Audio>` pairs:

```tsx
export const AudioLayer: React.FC<{ script: DirectorScript }> = ({ script }) => {
  // 1. Compute SFX cues with global frame positions
  let frameOffset = 0;
  const cues: Array<{ sfx: string; globalFrame: number; volume: number }> = [];

  for (const scene of script.scenes) {
    if (scene.sfxCues) {
      for (const cue of scene.sfxCues) {
        cues.push({
          sfx: cue.sfx,
          globalFrame: frameOffset + cue.atFrame,
          volume: cue.volume ?? 0.8,
        });
      }
    }
    frameOffset += scene.duration;
  }

  // 2. Select mood-based music bed
  const musicBedSrc = MUSIC_BEDS[script.meta.mood];

  return (
    <>
      {/* Full-duration music bed */}
      {musicBedSrc && (
        <Sequence from={0} durationInFrames={frameOffset}>
          <Audio src={musicBedSrc} volume={0.6} startFrom={0} />
        </Sequence>
      )}
      {/* Frame-accurate SFX cues */}
      {cues.map((cue, i) => {
        const src = SFX[cue.sfx as SfxName];
        if (!src) return null;
        return (
          <Sequence key={`sfx-${i}`} from={cue.globalFrame}>
            <Audio src={src} volume={cue.volume} />
          </Sequence>
        );
      })}
    </>
  );
};
```

Key design decisions:
- Music bed at `volume={0.6}` — sits under speech/SFX
- `startFrom={0}` ensures the music always plays from the beginning regardless of where the preview starts
- SFX manifest (`SFX`, `MUSIC_BEDS`) maps string keys to `staticFile()` paths — never inline URLs

---

## Silence Removal Pipeline (`src/overlay/silence-remover.ts`)

Removes dead air from talking-head footage while preserving natural pauses, using ffmpeg's `silencedetect` filter and the concat demuxer.

### Algorithm

1. **Detect silences** — `ffmpeg -af silencedetect=noise=-30dB:d=0.5` outputs silence ranges to stderr
2. **Build trim segments** — for each silence gap `[gap.start, gap.end]`, keep `halfPause` (0.15s) on each side as a natural pause
3. **Extract segments to .ts files** — stream copy (`-c copy -avoid_negative_ts make_zero`) preserves quality
4. **Reassemble** — `ffmpeg -f concat -safe 0 -i list.txt -c copy output.mp4`

### Key Parameters

```ts
interface SilenceRemoverOptions {
  videoPath: string;
  outputPath?: string;
  threshold?: number;    // default: -30 dB
  minDuration?: number;  // default: 0.5s — minimum silence to cut
  naturalPause?: number; // default: 0.3s — total pause preserved (split evenly)
}
```

### Shell Commands

```bash
# Step 1: Detect silences (output goes to stderr)
ffmpeg -i input.mp4 -af silencedetect=noise=-30dB:d=0.5 -f null - 2>&1 | grep silence

# Parse output — look for silence_start and silence_end timestamps

# Step 2: Extract non-silence segment (repeat for each segment)
ffmpeg -y -i input.mp4 \
  -ss 0.000 -to 4.350 \
  -c copy -avoid_negative_ts make_zero \
  _seg_0000.ts

# Step 3: Write concat list
echo "file '_seg_0000.ts'" > _concat_list.txt
echo "file '_seg_0001.ts'" >> _concat_list.txt

# Step 4: Reassemble
ffmpeg -y -f concat -safe 0 -i _concat_list.txt -c copy output.mp4

# Step 5: Clean up temp files
rm _seg_*.ts _concat_list.txt
```

### Silence Detection Regex

```ts
const startRegex = /silence_start:\s*([\d.]+)/g;
const endRegex   = /silence_end:\s*([\d.]+)/g;
```

### Natural Pause Preservation

```ts
// halfPause = naturalPause / 2 = 0.15s
// For each silence [gap.start, gap.end]:
segmentEnd   = gap.start + halfPause  // keep 0.15s tail before silence
nextCursor   = gap.end   - halfPause  // skip to 0.15s into post-silence speech
```

---

## faster-whisper Transcription (`src/overlay/transcribe.ts`)

Produces word-level timestamps from audio using `faster-whisper` (Python). Output is the `Transcription` type used across the overlay pipeline.

### Output Type

```ts
interface TranscriptWord    { word: string; start: number; end: number; } // seconds
interface TranscriptSegment { id: number; start: number; end: number; text: string; words: TranscriptWord[]; }
interface Transcription     { language: string; segments: TranscriptSegment[]; }
```

### Python Script (embedded, run via execSync)

```python
from faster_whisper import WhisperModel
import json, sys

audio_path = sys.argv[1]
model = WhisperModel("medium", device="cpu", compute_type="int8")
segments, info = model.transcribe(
    audio_path,
    beam_size=5,
    word_timestamps=True,
    vad_filter=True,      # VAD filter removes non-speech regions automatically
)

result = {"language": info.language, "segments": []}
for seg in segments:
    words = [{"word": w.word.strip(), "start": round(w.start, 3), "end": round(w.end, 3)} for w in seg.words]
    result["segments"].append({"id": seg.id, "start": round(seg.start, 3), "end": round(seg.end, 3), "text": seg.text.strip(), "words": words})

print(json.dumps(result))
```

### Shell Usage

```bash
pip install faster-whisper

# Run transcription (outputs JSON to stdout)
python3 transcribe.py audio.wav > transcription.json

# Or via the TypeScript pipeline
# transcribe({ audioPath: 'audio.wav', outputDir: './out' })
```

### Model Recommendations

| Model | Speed | Accuracy | Use case |
|---|---|---|---|
| `tiny` | Fastest | Low | Quick drafts |
| `base` | Fast | Medium | Social clips |
| `medium` | Moderate | High | Production (default) |
| `large-v3` | Slow | Highest | Long-form accuracy |

All run on CPU with `compute_type="int8"` for memory efficiency.

---

## Overlay Compositor (`src/overlay/compositor.ts`)

Composites Remotion-rendered overlay animations onto edited footage using ffmpeg `filter_complex` with time-gated `enable='between(t,...)'`.

### filter_complex Pattern

```bash
ffmpeg -y \
  -i edited-footage.mp4 \
  -i overlay-scene-01.mov \
  -i overlay-scene-02.mov \
  -filter_complex "
    [0:v]copy[base];
    [1:v]setpts=PTS-STARTPTS[o0];
    [base][o0]overlay=0:1520:enable='between(t,12.5,18.3)'[v0];
    [2:v]setpts=PTS-STARTPTS[o1];
    [v0][o1]overlay=540:0:enable='between(t,22.1,30.0)'[vout]
  " \
  -map "[vout]" -map 0:a \
  -c:v libx264 -crf 18 -c:a aac -b:a 320k \
  final-output.mp4
```

### Key Techniques

- **`setpts=PTS-STARTPTS`**: Resets overlay PTS to 0 so it plays from its own beginning regardless of when it's inserted
- **`enable='between(t,start,end)'`**: Time-gates the overlay — the filter only activates between those seconds
- **Chained labels**: Each overlay step produces an intermediate label (`[v0]`, `[v1]`, ...) with the final step producing `[vout]`
- **`-map "[vout]" -map 0:a`**: Keeps the base audio stream unchanged

### Position Presets (1080x1920 vertical canvas)

```ts
const POSITION_OFFSETS = {
  'lower-third':       { x: 0,   y: 1520 },
  'full-screen':       { x: 0,   y: 0    },
  'right-panel':       { x: 540, y: 0    },
  'left-panel':        { x: 0,   y: 0    },
  'picture-in-picture':{ x: 740, y: 1347 },
};
```

---

## Transcript-Anchored Overlay Placement (`src/overlay/overlay-mapper.ts`)

Maps scene overlay windows to exact timestamps in the speech timeline using fuzzy phrase matching (Levenshtein distance) against word-level transcription data.

### Algorithm

1. Flatten all `TranscriptWord[]` from all segments into a single ordered array
2. Slide a window of `phraseLen` words across the array
3. Compute normalized Levenshtein similarity for each window
4. Accept match if similarity >= 0.7 (handles filler words, minor transcription errors)
5. Apply `anchor.offset` (default -15 frames) to trigger overlay slightly before the phrase is spoken
6. For `holdUntilPhrase`, find the end of a second phrase to determine the overlay exit time

### Fuzzy Match

```ts
// Normalized Levenshtein similarity
const similarity = 1 - levenshteinDistance(phraseText, windowText) /
  Math.max(phraseText.length, windowText.length);

if (similarity >= 0.7) { /* match accepted */ }
```

### TranscriptAnchor DSL

```ts
interface TranscriptAnchor {
  phrase: string;          // text to find in transcript
  offset?: number;         // frames before phrase (default: -15)
  holdUntilPhrase?: string; // hold overlay until this phrase is spoken
}
```

### Usage in DirectorScript

```ts
// Add to a scene definition (extended from DirectorScript base)
{
  id: 'scene-3',
  duration: 60,
  layout: 'lower-third',
  transcriptAnchor: { phrase: 'the key insight here', offset: -20 },
  overlayMode: { position: 'lower-third', transparency: 0.85, safeZone: true },
  // ... standard Scene fields
}
```

---

## Batch Rendering / Theme Classification

For high-volume video production, the pipeline classifies scripts by theme/template and manages a render queue:

### Slug Naming Convention

```ts
// Format: YYYY-MM-DD-<topic-slug>
const slug = `${postDate}-${topic.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '')}`;
```

### Queue Pattern

```ts
const queue: Array<{ script: DirectorScript; outputDir: string }> = [];

for (const scriptPath of scriptPaths) {
  const script: DirectorScript = JSON.parse(readFileSync(scriptPath, 'utf-8'));
  queue.push({ script, outputDir: path.join(OUTPUT_DIR, script.meta.slug) });
}

// Render sequentially (or use Promise.all with concurrency limit)
for (const job of queue) {
  await renderMedia({ /* ... */ inputProps: { script: job.script } });
}
```

### Template Classification

Scripts are classified by `meta.mood` and `meta.colorTheme` to select the appropriate visual template. The `DirectorComposition` uses `COLOR_THEMES[script.meta.colorTheme]` for all color decisions, making the same component work across all themes.
