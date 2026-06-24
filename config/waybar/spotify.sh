#!/usr/bin/env bash

if ! playerctl -p spotify status >/dev/null 2>&1; then
    exit 0
fi

STATUS=$(playerctl -p spotify status)
METADATA=$(playerctl -p spotify metadata --format '{{ artist }} - {{ title }}')

if [ "$STATUS" = "Playing" ]; then
    echo "{\"text\":\"  $METADATA\",\"class\":\"playing\",\"tooltip\":\"Playing on Spotify\"}"
else
    echo "{\"text\":\"  $METADATA\",\"class\":\"paused\",\"tooltip\":\"Paused on Spotify\"}"
fi
