#!/bin/bash

# Fetch current wallpaper path from swww
wallpaper_path=$(swww query | grep "image:" | awk -F'image: ' '{print $2}' | head -n 1)

# Fallback if no active wallpaper found
if [ -z "$wallpaper_path" ] || [ ! -f "$wallpaper_path" ]; then
    echo "$HOME/.config/hypr/default_wallpaper" # fallback wallpaper
else
    echo "$wallpaper_path"
fi

