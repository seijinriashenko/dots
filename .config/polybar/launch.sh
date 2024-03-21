#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the `i3_bar' bar
polybar i3_bar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bar is launched..."
