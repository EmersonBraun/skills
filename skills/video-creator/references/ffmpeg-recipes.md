# FFmpeg Recipes — Comandos Prontos

## Indice
1. [Basicos](#basicos)
2. [Slideshow](#slideshow)
3. [Texto e Legendas](#texto-e-legendas)
4. [Composicao](#composicao)
5. [Audio](#audio)
6. [Transicoes](#transicoes)
7. [Social Media](#social-media)
8. [Otimizacao](#otimizacao)
9. [Efeitos](#efeitos)
10. [Automacao com Python](#python)

---

## Basicos

### Converter formato
```bash
ffmpeg -i input.mov -c:v libx264 -c:a aac -preset fast output.mp4
```

### Redimensionar
```bash
# Para 1080p mantendo aspect ratio
ffmpeg -i input.mp4 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" output.mp4

# Para 9:16 (vertical/reels)
ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:black" output.mp4
```

### Cortar duracao
```bash
# Primeiros 30 segundos
ffmpeg -i input.mp4 -t 30 -c copy output.mp4

# De 1:00 a 2:30
ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:30 -c copy output.mp4
```

### Extrair audio
```bash
ffmpeg -i video.mp4 -vn -acodec libmp3lame audio.mp3
```

### Extrair frames
```bash
# 1 frame por segundo
ffmpeg -i video.mp4 -vf "fps=1" frame_%04d.png

# Frame especifico (aos 5 segundos)
ffmpeg -i video.mp4 -ss 00:00:05 -vframes 1 thumbnail.png
```

---

## Slideshow

### Basico (imagens em sequencia)
```bash
# 3 segundos por imagem, fade in/out
ffmpeg -framerate 1/3 -i img_%d.png \
  -c:v libx264 -r 30 -pix_fmt yuv420p \
  slideshow.mp4
```

### Com zoom (Ken Burns effect)
```bash
ffmpeg -loop 1 -i img.png -t 5 \
  -vf "zoompan=z='min(zoom+0.0015,1.5)':d=150:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1920x1080" \
  -c:v libx264 -pix_fmt yuv420p zoom.mp4
```

### Slideshow com musica
```bash
# Criar slideshow e adicionar audio
ffmpeg -framerate 1/4 -i img_%d.png -i musica.mp3 \
  -c:v libx264 -r 30 -pix_fmt yuv420p \
  -shortest slideshow_music.mp4
```

---

## Texto e Legendas

### Texto simples sobreposto
```bash
ffmpeg -i video.mp4 \
  -vf "drawtext=text='Hello World':fontcolor=white:fontsize=72:x=(w-text_w)/2:y=(h-text_h)/2:shadowcolor=black:shadowx=2:shadowy=2" \
  output.mp4
```

### Texto com fundo (lower third)
```bash
ffmpeg -i video.mp4 \
  -vf "drawbox=x=0:y=ih-120:w=iw:h=120:color=black@0.7:t=fill, \
       drawtext=text='Titulo Aqui':fontcolor=white:fontsize=48:x=40:y=h-100" \
  output.mp4
```

### Texto animado (aparece e desaparece)
```bash
ffmpeg -i video.mp4 \
  -vf "drawtext=text='Texto Animado':fontcolor=white:fontsize=64:x=(w-text_w)/2:y=(h-text_h)/2:enable='between(t,2,5)':alpha='if(lt(t,2.5),((t-2)*2),if(gt(t,4.5),(5-t)*2,1))'" \
  output.mp4
```

### Legendas SRT
```bash
ffmpeg -i video.mp4 -vf "subtitles=legendas.srt:force_style='FontSize=24,PrimaryColour=&Hffffff,OutlineColour=&H000000,Outline=2'" output.mp4
```

---

## Composicao

### Picture-in-picture
```bash
ffmpeg -i main.mp4 -i pip.mp4 \
  -filter_complex "[1:v]scale=320:240[pip];[0:v][pip]overlay=W-w-20:H-h-20" \
  output.mp4
```

### Logo/watermark
```bash
ffmpeg -i video.mp4 -i logo.png \
  -filter_complex "[1:v]scale=100:-1[logo];[0:v][logo]overlay=W-w-20:20:format=auto" \
  output.mp4
```

### Grid (4 videos)
```bash
ffmpeg -i v1.mp4 -i v2.mp4 -i v3.mp4 -i v4.mp4 \
  -filter_complex "[0:v]scale=960:540[a];[1:v]scale=960:540[b];[2:v]scale=960:540[c];[3:v]scale=960:540[d];[a][b]hstack[top];[c][d]hstack[bottom];[top][bottom]vstack" \
  -c:v libx264 grid.mp4
```

### Background colorido com texto
```bash
ffmpeg -f lavfi -i "color=c=0x667eea:s=1080x1920:d=5" \
  -vf "drawtext=text='Seu texto':fontcolor=white:fontsize=72:x=(w-text_w)/2:y=(h-text_h)/2" \
  -c:v libx264 -pix_fmt yuv420p bg_text.mp4
```

---

## Audio

### Adicionar musica de fundo
```bash
ffmpeg -i video.mp4 -i music.mp3 \
  -filter_complex "[1:a]volume=0.2[bg];[0:a][bg]amix=inputs=2:duration=first" \
  -c:v copy output.mp4
```

### Substituir audio
```bash
ffmpeg -i video.mp4 -i new_audio.mp3 \
  -c:v copy -map 0:v -map 1:a -shortest output.mp4
```

### Fade in/out no audio
```bash
ffmpeg -i video.mp4 \
  -af "afade=t=in:st=0:d=2,afade=t=out:st=28:d=2" \
  output.mp4
```

### Normalizar volume
```bash
ffmpeg -i video.mp4 -af "loudnorm=I=-14:LRA=11:TP=-1.5" output.mp4
```

### Remover audio
```bash
ffmpeg -i video.mp4 -an -c:v copy output_silent.mp4
```

---

## Transicoes

### Fade entre 2 videos
```bash
ffmpeg -i v1.mp4 -i v2.mp4 \
  -filter_complex "[0:v]fade=t=out:st=4:d=1[v0];[1:v]fade=t=in:st=0:d=1[v1];[v0][v1]concat=n=2:v=1:a=0" \
  output.mp4
```

### Crossfade
```bash
ffmpeg -i v1.mp4 -i v2.mp4 \
  -filter_complex "xfade=transition=fade:duration=1:offset=4" \
  output.mp4
```

### Transicoes disponiveis no xfade
fade, wipeleft, wiperight, wipeup, wipedown, slideleft, slideright, slideup, slidedown, circlecrop, rectcrop, distance, fadeblack, fadewhite, radial, smoothleft, smoothright, smoothup, smoothdown, circleopen, circleclose, vertopen, vertclose, horzopen, horzclose, dissolve, pixelize, diagtl, diagtr, diagbl, diagbr, hlslice, hrslice, vuslice, vdslice, hblur, fadegrays, squeezev, squeezeh, zoomin

---

## Social Media

### Reels/TikTok (vertical 9:16)
```bash
# Converter horizontal para vertical com blur background
ffmpeg -i horizontal.mp4 \
  -filter_complex "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20[bg];[0:v]scale=1080:-1[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2" \
  -c:v libx264 -c:a aac reels.mp4
```

### YouTube thumbnail
```bash
ffmpeg -i video.mp4 -ss 00:00:05 -vframes 1 \
  -vf "scale=1280:720" thumbnail.jpg
```

### GIF para redes sociais
```bash
ffmpeg -i video.mp4 -ss 0 -t 3 \
  -vf "fps=15,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
  output.gif
```

---

## Otimizacao

### Reduzir tamanho (manter qualidade)
```bash
# CRF 23 = boa qualidade, arquivo menor
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k output.mp4
```

### Web-optimized (fast start)
```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -movflags +faststart output.mp4
```

### Comprimir para WhatsApp (<16MB)
```bash
# Calcular bitrate: (16MB * 8192) / duracao_em_segundos - 128 (audio)
# Exemplo para 30s: (16*8192)/30 - 128 = ~4240 kbps
ffmpeg -i input.mp4 -c:v libx264 -b:v 4000k -maxrate 4500k -bufsize 8000k -c:a aac -b:a 128k output.mp4
```

---

## Efeitos

### Velocidade (speed up / slow motion)
```bash
# 2x mais rapido
ffmpeg -i input.mp4 -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" fast.mp4

# 0.5x mais lento
ffmpeg -i input.mp4 -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" slow.mp4
```

### Reverse
```bash
ffmpeg -i input.mp4 -vf reverse -af areverse reversed.mp4
```

### Color grading basico
```bash
# Aumentar contraste e saturacao
ffmpeg -i input.mp4 -vf "eq=contrast=1.2:saturation=1.3:brightness=0.05" output.mp4

# Cinematic look (lift shadows, lower highlights)
ffmpeg -i input.mp4 -vf "curves=m='0/0.05 0.5/0.5 1/0.95'" output.mp4
```

### Vinheta
```bash
ffmpeg -i input.mp4 -vf "vignette=PI/4" output.mp4
```

---

## Python

### MoviePy — Composicao de video
```python
from moviepy.editor import *

# Slideshow com texto
clips = []
for i, img_path in enumerate(image_paths):
    clip = ImageClip(img_path).set_duration(3).resize((1920, 1080))
    txt = TextClip(titles[i], fontsize=48, color='white', font='Arial-Bold')
    txt = txt.set_position(('center', 'bottom')).set_duration(3)
    clips.append(CompositeVideoClip([clip, txt]).crossfadein(0.5))

final = concatenate_videoclips(clips, method="compose")
final.write_videofile("slideshow.mp4", fps=30)
```

### Pillow — Gerar frames com texto
```python
from PIL import Image, ImageDraw, ImageFont

def create_text_frame(text, size=(1080, 1920), bg_color="#1a1a2e", text_color="white"):
    img = Image.new('RGB', size, bg_color)
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype("/path/to/font.ttf", 64)
    bbox = draw.textbbox((0, 0), text, font=font)
    x = (size[0] - (bbox[2] - bbox[0])) // 2
    y = (size[1] - (bbox[3] - bbox[1])) // 2
    draw.text((x, y), text, fill=text_color, font=font)
    return img
```
