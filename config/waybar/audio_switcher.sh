#!/usr/bin/env bash

# audio_switcher.sh
# Switch audio input/output devices using wofi and pactl

MODE=$1

if [ "$MODE" = "source" ] || [ "$MODE" = "input" ]; then
    # Input Switcher (Microphone)
    CHOICE=$(pactl list sources | awk '/Name:/ {name=$2} /Description:/ {sub(/^[ \t]*Description:[ \t]*/, ""); if (name !~ /\.monitor$/) print $0}' | wofi -dmenu -p "Select Input Device")
    if [ -n "$CHOICE" ]; then
        NAME=$(pactl list sources | awk -v desc="$CHOICE" '/Name:/ {name=$2} /Description:/ {sub(/^[ \t]*Description:[ \t]*/, ""); if ($0 == desc) print name}')
        if [ -n "$NAME" ]; then
            pactl set-default-source "$NAME"
        fi
    fi
else
    # Output Switcher (Sink / Speakers / Headphones)
    CHOICE=$(pactl list sinks | awk '/Name:/ {name=$2} /Description:/ {sub(/^[ \t]*Description:[ \t]*/, ""); print $0}' | wofi -dmenu -p "Select Output Device")
    if [ -n "$CHOICE" ]; then
        NAME=$(pactl list sinks | awk -v desc="$CHOICE" '/Name:/ {name=$2} /Description:/ {sub(/^[ \t]*Description:[ \t]*/, ""); if ($0 == desc) print name}')
        if [ -n "$NAME" ]; then
            pactl set-default-sink "$NAME"
        fi
    fi
fi
