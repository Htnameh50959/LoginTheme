# LoginTheme

Custom GDM (GNOME 46) login screen: blurred, darkened wallpaper background, frosted-glass user card and password field, red accent.

- `login.css` — overrides appended to Yaru's `gdm.css`
- `make_bg.py` — wallpaper → blurred/dimmed 1920x1080 `login-bg.jpg`
- `./build.sh [wallpaper] [blur=10] [dim=0.62]` — builds `gdm-custom.gresource` from the stock Yaru resource
- `./install.sh` — installs it as GDM's theme (sudo); log out to see it
- `./uninstall.sh` — switches GDM back to stock Yaru

Rebuild and reinstall after changing the wallpaper.
