#!/usr/bin/env bash
THEMES_DIR="$HOME/.config/hypr/themes"
CURRENT_THEME_FILE="$HOME/.config/hypr/current_theme"

# Pick next theme
[ -f "$CURRENT_THEME_FILE" ] && CURRENT_THEME=$(cat "$CURRENT_THEME_FILE") || CURRENT_THEME=""
THEME=$(ls "$THEMES_DIR" | sort | awk -v cur="$CURRENT_THEME" '
    BEGIN{found=0}
    {
        if(found) {print; exit}
        if($0==cur) found=1
    }
    END{if(!found) print $0}
')
echo "$THEME" > "$CURRENT_THEME_FILE"

# Load env variables from colors.conf
eval $(grep '^env' "$THEMES_DIR/$THEME/colors.conf" | sed 's/env = //')

# Reload Hyprland (must source theme in main hyprland.conf)
hyprctl reload

# Apply Waybar + Mako themes
ln -sf "$THEMES_DIR/$THEME/waybar.css" ~/.config/waybar/style.css
ln -sf "$THEMES_DIR/$THEME/mako.conf" ~/.config/mako/config

# GTK theme (make sure your colors.conf defines THEME_FONT & THEME_ICON)
[ -n "$THEME_FONT" ] && gsettings set org.gnome.desktop.interface font-name "$THEME_FONT"
[ -n "$THEME_ICON" ] && gsettings set org.gnome.desktop.interface icon-theme "$THEME_ICON"

# Restart services
killall -q waybar mako
sleep 0.5
waybar &
mako &
