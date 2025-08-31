#!/usr/bin/env bash

THEMES_DIR="$HOME/.config/hypr/themes"
CURRENT_THEME_FILE="$HOME/.config/hypr/theme-current/current_theme"
CURRENT_INDEX_FILE="$HOME/.config/hypr/theme-current/.current_wp"

# Get current theme
if [ ! -f "$CURRENT_THEME_FILE" ]; then
    echo "No theme selected. Run theme-switch.sh first."
    exit 1
fi

THEME=$(cat "$CURRENT_THEME_FILE")
WALLPAPERS_DIR="$THEMES_DIR/$THEME/wallpapers"

# Ensure wallpapers dir exists
if [ ! -d "$WALLPAPERS_DIR" ]; then
    echo "No wallpapers found for theme: $THEME"
    exit 1
fi

# Collect wallpapers
FILES=("$WALLPAPERS_DIR"/*)
COUNT=${#FILES[@]}
if [ "$COUNT" -eq 0 ]; then
    echo "No wallpapers inside $WALLPAPERS_DIR"
    exit 1
fi

# Get wallpaper index
if [ -f "$CURRENT_INDEX_FILE" ]; then
    IDX=$(cat "$CURRENT_INDEX_FILE")
else
    IDX=0
fi

# Next wallpaper
IDX=$(((IDX + 1) % COUNT))
echo "$IDX" > "$CURRENT_INDEX_FILE"

# Kill old swaybg
pkill -x swaybg 2>/dev/null

# Apply wallpaper
swaybg -i "${FILES[$IDX]}" --mode fill &
