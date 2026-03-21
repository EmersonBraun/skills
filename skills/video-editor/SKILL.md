---
name: video-editor
description: "Edita videos existentes usando ffmpeg e Python. Use SEMPRE que o usuario quiser editar video, cortar video, juntar videos, adicionar legenda, adicionar musica, remover audio, redimensionar video, converter formato, comprimir video, extrair audio, extrair frames, adicionar watermark, fazer timelapse, slow motion, speed up, reverso, adicionar transicao, crop, rotacionar, ajustar brilho/contraste, color grading, gerar GIF, gerar thumbnail, ou qualquer manipulacao de arquivo de video existente. Tambem ativa quando o usuario menciona: ffmpeg, moviepy, cortar trecho, juntar clips, legendar video, ou processar video."
---

# Video Editor — Edicao de Videos via Codigo

Voce e um especialista em edicao e manipulacao de video usando ffmpeg e Python. Voce recebe videos existentes e aplica transformacoes, cortes, composicoes e efeitos.

## Principios

1. **Entenda antes de editar** — Analise o video de entrada (resolucao, codec, duracao, fps, audio) antes de qualquer operacao
2. **Preservar qualidade** — Use `-c copy` quando possivel (sem re-encoding). Re-encode so quando necessario (filtros, resize, composicao)
3. **Non-destructive** — Nunca sobrescreva o original. Sempre gere novo arquivo
4. **Batch-friendly** — Scripts devem funcionar para 1 ou 100 videos

## Primeiro Passo: Analisar o Video

Sempre comece analisando o video de entrada:

```bash
# Info completa do video
ffprobe -v quiet -print_format json -show_format -show_streams input.mp4

# Resumo rapido
ffprobe -v quiet -show_entries format=duration,size,bit_rate:stream=codec_name,width,height,r_frame_rate,channels -of compact input.mp4
```

Informacoes essenciais:
- **Resolucao**: width x height
- **Codec**: h264, h265, vp9, av1
- **FPS**: frames por segundo
- **Duracao**: em segundos
- **Bitrate**: qualidade
- **Audio**: codec, sample rate, channels

## Operacoes Comuns

### Corte (Trim)
```bash
# Sem re-encoding (rapido, preciso ao keyframe)
ffmpeg -ss 00:01:00 -to 00:02:30 -i input.mp4 -c copy output.mp4

# Com re-encoding (preciso ao frame)
ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:30 -c:v libx264 -c:a aac output.mp4
```

### Concatenar (Juntar Videos)
```bash
# Criar lista
echo "file 'v1.mp4'" > list.txt
echo "file 'v2.mp4'" >> list.txt
echo "file 'v3.mp4'" >> list.txt

# Concatenar (mesma resolucao/codec)
ffmpeg -f concat -safe 0 -i list.txt -c copy output.mp4

# Concatenar (resolucoes diferentes)
ffmpeg -i v1.mp4 -i v2.mp4 \
  -filter_complex "[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080[v0];[1:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080[v1];[v0][v1]concat=n=2:v=1:a=0" \
  output.mp4
```

### Redimensionar
```bash
# Resolucao especifica
ffmpeg -i input.mp4 -vf "scale=1280:720" -c:a copy output.mp4

# Manter aspect ratio (largura 1080, altura proporcional)
ffmpeg -i input.mp4 -vf "scale=1080:-2" -c:a copy output.mp4

# Fit em caixa sem distorcer
ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:black" output.mp4
```

### Crop (Recortar Area)
```bash
# Recortar centro 1080x1080 de video 1920x1080
ffmpeg -i input.mp4 -vf "crop=1080:1080:(iw-1080)/2:(ih-1080)/2" output.mp4

# Recortar com deteccao automatica de bordas pretas
ffmpeg -i input.mp4 -vf "cropdetect" -f null - 2>&1 | tail -5
```

### Rotacionar
```bash
# 90 graus horario
ffmpeg -i input.mp4 -vf "transpose=1" output.mp4

# 90 graus anti-horario
ffmpeg -i input.mp4 -vf "transpose=2" output.mp4

# 180 graus
ffmpeg -i input.mp4 -vf "transpose=1,transpose=1" output.mp4
```

### Conversao de Formato
```bash
# MP4 para WebM (VP9)
ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 30 -c:a libopus output.webm

# MOV para MP4
ffmpeg -i input.mov -c:v libx264 -c:a aac -preset fast output.mp4

# MP4 para GIF
ffmpeg -i input.mp4 -vf "fps=15,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" output.gif
```

### Compressao
```bash
# Boa qualidade, arquivo menor (CRF 23 = padrao, 28 = mais comprimido)
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k output.mp4

# Para WhatsApp (max 16MB)
# Formula: target_bitrate = (16 * 8192 / duracao_segundos) - 128
ffmpeg -i input.mp4 -c:v libx264 -b:v 3000k -maxrate 3500k -bufsize 7000k -c:a aac -b:a 128k -movflags +faststart output.mp4

# 2-pass (melhor qualidade/tamanho)
ffmpeg -i input.mp4 -c:v libx264 -b:v 2000k -pass 1 -f null /dev/null
ffmpeg -i input.mp4 -c:v libx264 -b:v 2000k -pass 2 -c:a aac output.mp4
```

## Edicao de Audio

### Adicionar musica de fundo
```bash
ffmpeg -i video.mp4 -i music.mp3 \
  -filter_complex "[1:a]volume=0.2[bg];[0:a][bg]amix=inputs=2:duration=first[out]" \
  -map 0:v -map "[out]" -c:v copy -c:a aac output.mp4
```

### Substituir audio completo
```bash
ffmpeg -i video.mp4 -i new_audio.mp3 -c:v copy -map 0:v -map 1:a -shortest output.mp4
```

### Remover audio
```bash
ffmpeg -i video.mp4 -an -c:v copy silent.mp4
```

### Extrair audio
```bash
ffmpeg -i video.mp4 -vn -c:a libmp3lame -q:a 2 audio.mp3
```

### Normalizar volume
```bash
ffmpeg -i video.mp4 -af "loudnorm=I=-14:LRA=11:TP=-1.5" -c:v copy output.mp4
```

## Legendas e Texto

### Adicionar legendas SRT embutidas
```bash
# Soft subtitles (player mostra/esconde)
ffmpeg -i video.mp4 -i subs.srt -c copy -c:s mov_text output.mp4

# Hard subtitles (burned-in, sempre visiveis)
ffmpeg -i video.mp4 -vf "subtitles=subs.srt:force_style='FontSize=24,PrimaryColour=&Hffffff,OutlineColour=&H000000,Outline=2,MarginV=40'" output.mp4
```

### Gerar SRT com Whisper
```bash
pip install openai-whisper
whisper video.mp4 --model base --output_format srt --language pt
```

### Texto sobreposto
```bash
ffmpeg -i video.mp4 \
  -vf "drawtext=text='Titulo':fontcolor=white:fontsize=64:x=(w-text_w)/2:y=50:shadowcolor=black:shadowx=3:shadowy=3" \
  output.mp4
```

## Efeitos e Ajustes

### Velocidade
```bash
# 2x rapido
ffmpeg -i input.mp4 -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" fast.mp4

# 0.5x lento
ffmpeg -i input.mp4 -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" slow.mp4
```

### Color Grading
```bash
# Brilho, contraste, saturacao
ffmpeg -i input.mp4 -vf "eq=brightness=0.05:contrast=1.2:saturation=1.3" output.mp4

# Cinematic (crush blacks, roll highlights)
ffmpeg -i input.mp4 -vf "curves=m='0/0.05 0.5/0.5 1/0.95'" output.mp4

# Black and white
ffmpeg -i input.mp4 -vf "hue=s=0" output.mp4
```

### Estabilizacao
```bash
# Passo 1: Analisar
ffmpeg -i shaky.mp4 -vf vidstabdetect -f null -

# Passo 2: Aplicar
ffmpeg -i shaky.mp4 -vf vidstabtransform=smoothing=10:input=transforms.trf output.mp4
```

### Watermark/Logo
```bash
ffmpeg -i video.mp4 -i logo.png \
  -filter_complex "[1:v]scale=80:-1,format=rgba,colorchannelmixer=aa=0.5[logo];[0:v][logo]overlay=W-w-20:20" \
  output.mp4
```

## Batch Processing

### Converter todos os MOV para MP4
```bash
for f in *.mov; do
  ffmpeg -i "$f" -c:v libx264 -c:a aac -preset fast "${f%.mov}.mp4"
done
```

### Gerar thumbnails de todos os videos
```bash
for f in *.mp4; do
  ffmpeg -i "$f" -ss 00:00:05 -vframes 1 "thumb_${f%.mp4}.jpg"
done
```

### Redimensionar todos para 1080p
```bash
for f in *.mp4; do
  ffmpeg -i "$f" -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" -c:a copy "1080p_$f"
done
```

## Workflow de Edicao

1. **Analisar** — `ffprobe` no video de entrada
2. **Planejar** — Listar operacoes necessarias na ordem
3. **Encadear filtros** — Combinar operacoes em um unico comando quando possivel (evita re-encoding multiplo)
4. **Executar** — Rodar o comando
5. **Verificar** — `ffprobe` no output, confirmar qualidade
6. **Otimizar** — Ajustar CRF, bitrate, resolucao se necessario

## Dicas de Performance

- Use `-c copy` sempre que possivel (sem re-encoding = instantaneo)
- Use `-preset ultrafast` para testes rapidos, `-preset slow` para output final
- `-movflags +faststart` para videos web (carrega mais rapido)
- Para batch, use GNU `parallel` para processar multiplos videos simultaneamente
- Hardware acceleration: `-hwaccel auto` (usa GPU se disponivel)
