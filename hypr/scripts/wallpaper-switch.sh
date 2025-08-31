#!/usr/bin/env bash

THEMES_DIR="$HOME/.config/hypr/themes"
CURRENT_THEME_FILE="$HOME/.config/hypr/theme-current"
CURRENT_WP_FILE="$HOME/.config/hypr/theme-current/wallpapers/1.png"

# Get current theme
if [ ! -f "$CURRENT_THEME_FILE" ]; then
    echo "No theme selected. Run switch-theme.sh first."
    exit 1
fi

THEME=$(cat "$CURRENT_THEME_FILE")
WALLPAPERS_DIR="$THEMES_DIR/$THEME/wallpapers"

# Ensure wallpapers dir exists
if [ ! -d "$WALLPAPERS_DIR" ]; then
    echo "No wallpapers found for theme: $THEME"
    exit 1
fi

# Get wallpaper index
if [ -f "$CURRENT_WP_FILE" ]; then
    IDX=$(cat "$CURRENT_WP_FILE")
else
    IDX=0
fi

# Collect wallpapers
FILES=("$WALLPAPERS_DIR"/*)
COUNT=${#FILES[@]}

if [ "$COUNT" -eq 0 ]; then
    echo "No wallpapers inside $WALLPAPERS_DIR"
    exit 1
fi

# Next wallpaper
IDX=$(((IDX + 1) % COUNT))
echo "$IDX" > "$CURRENT_WP_FILE"

# Kill old swaybg
pkill -x swaybg 2>/dev/null

# Apply wallpaper
swaybg -i "${FILES[$IDX]}" --mode fill &
