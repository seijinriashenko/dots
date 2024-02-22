#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the `main' bar
# polybar -c ~/.config/polybar/themes/modus-vivendi.ini main
polybar -c ~/.config/polybar/themes/gruvbox-dark.ini main
