#!/usr/bin/env bash
# Install the built theme as GDM's login theme (needs sudo). Log out to see it.
set -euo pipefail
cd "$(dirname "$0")"
DEST=/usr/share/gnome-shell/theme/gdm-custom.gresource
[ -f gdm-custom.gresource ] || ./build.sh
[ -f "$DEST" ] && [ ! -f backup-gdm-custom.gresource ] && cp "$DEST" backup-gdm-custom.gresource
sudo install -m 644 gdm-custom.gresource "$DEST"
sudo update-alternatives --install /usr/share/gnome-shell/gdm-theme.gresource gdm-theme.gresource "$DEST" 50 >/dev/null
sudo update-alternatives --set gdm-theme.gresource "$DEST"
echo "Installed. Log out (or reboot) to see the new login screen."
