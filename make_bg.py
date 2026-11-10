#!/usr/bin/env python3
"""Turn a wallpaper into a frosted, darkened login background (1920x1080 JPEG)."""
import sys
from PIL import Image, ImageFilter, ImageEnhance, ImageDraw

src, dst = sys.argv[1], sys.argv[2]
blur = float(sys.argv[3]) if len(sys.argv) > 3 else 22
dim = float(sys.argv[4]) if len(sys.argv) > 4 else 0.58
W, H = 1920, 1080

im = Image.open(src).convert("RGB")
# cover-crop to 16:9
r = max(W / im.width, H / im.height)
im = im.resize((round(im.width * r), round(im.height * r)), Image.LANCZOS)
l, t = (im.width - W) // 2, (im.height - H) // 2
im = im.crop((l, t, l + W, t + H))

im = im.filter(ImageFilter.GaussianBlur(blur))
im = ImageEnhance.Color(im).enhance(1.15)
im = ImageEnhance.Brightness(im).enhance(dim)

# soft vignette: darker edges, plus a little extra shade behind the centred dialog column
mask = Image.new("L", (W // 8, H // 8), 0)
d = ImageDraw.Draw(mask)
w, h = mask.size
for i in range(40):
    a = int(255 * (i / 40) ** 1.6)
    d.ellipse((-w * 0.25 + i * w * 0.012, -h * 0.35 + i * h * 0.012,
               w * 1.25 - i * w * 0.012, h * 1.35 - i * h * 0.012), fill=a)
mask = mask.resize((W, H), Image.BILINEAR).filter(ImageFilter.GaussianBlur(40))
dark = ImageEnhance.Brightness(im).enhance(0.55)
im = Image.composite(im, dark, mask)

im.save(dst, "JPEG", quality=92, optimize=True, progressive=True)
print(dst)
