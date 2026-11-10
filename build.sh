#!/usr/bin/env bash
# Build gdm-custom.gresource = stock Yaru GDM theme + login.css + blurred wallpaper.
# Usage: ./build.sh [wallpaper] [blur] [dim]
set -euo pipefail
cd "$(dirname "$0")"
WALL="${1:-$HOME/.config/background}"
BLUR="${2:-10}"
DIM="${3:-0.62}"
STOCK=/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
PREFIX=/org/gnome/shell/theme

rm -rf work && mkdir -p work/theme
for r in $(gresource list "$STOCK"); do
  out="work/theme/${r#$PREFIX/}"
  mkdir -p "$(dirname "$out")"
  gresource extract "$STOCK" "$r" > "$out"
done

cat login.css >> work/theme/gdm.css
python3 -I make_bg.py "$WALL" work/theme/login-bg.jpg "$BLUR" "$DIM" >/dev/null

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo "<gresources><gresource prefix=\"$PREFIX\">"
  (cd work/theme && find . -type f | sed 's|^\./||' | sort | sed 's|.*|  <file>&</file>|')
  echo '</gresource></gresources>'
} > work/theme/gdm-custom.gresource.xml

glib-compile-resources --sourcedir=work/theme --target=gdm-custom.gresource work/theme/gdm-custom.gresource.xml
echo "built $(pwd)/gdm-custom.gresource ($(du -h gdm-custom.gresource | cut -f1))"
