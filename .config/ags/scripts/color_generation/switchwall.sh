XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$XDG_CONFIG_HOME/ags"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALLPAPER_SYMLINK="$HOME/.config/hypr/wallpaper/.current_wallpaper"

switch() {
    imgpath=$1
    read scale screenx screeny screensizey < <(hyprctl monitors -j | jq '.[] | select(.focused) | .scale, .x, .y, .height' | xargs)
    cursorposx=$(hyprctl cursorpos -j | jq '.x' 2>/dev/null) || cursorposx=960
    cursorposx=$(bc <<< "scale=0; ($cursorposx - $screenx) * $scale / 1")
    cursorposy=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null) || cursorposy=540
    cursorposy=$(bc <<< "scale=0; ($cursorposy - $screeny) * $scale / 1")
    cursorposy_inverted=$((screensizey - cursorposy))

    if [ -z "$imgpath" ]; then
        echo 'Aborted'
        exit 0
    fi

    # Update symlink
    mkdir -p "$(dirname "$CURRENT_WALLPAPER_SYMLINK")"
    ln -sf "$imgpath" "$CURRENT_WALLPAPER_SYMLINK"

    # Apply wallpaper
    swww img "$imgpath" --transition-step 100 --transition-fps 120 \
        --transition-type grow --transition-angle 30 --transition-duration 1 \
        --transition-pos "$cursorposx, $cursorposy_inverted"

    # Generate colors for AGS
    "$CONFIG_DIR"/scripts/color_generation/colorgen.sh "$imgpath" --apply --smart
}

if [ "$1" == "--noswitch" ]; then
    imgpath=$(swww query | awk -F 'image: ' '{print $2}')
elif [[ "$1" ]]; then
    switch "$1"
else
    # Select and set image
    cd "$WALLPAPER_DIR" || { echo "Failed to change directory to $WALLPAPER_DIR"; exit 1; }
    selected_image=$(yad --width 1200 --height 800 --file --add-preview --large-preview --title='Choose wallpaper')
    if [ -n "$selected_image" ]; then
        switch "$selected_image"
    fi
fi
