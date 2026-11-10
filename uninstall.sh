#!/usr/bin/env bash
# Revert GDM to the stock Yaru login theme.
set -euo pipefail
sudo update-alternatives --set gdm-theme.gresource /usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource
echo "Reverted to stock Yaru. Log out to see it."
