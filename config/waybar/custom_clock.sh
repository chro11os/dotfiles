#!/usr/bin/env bash
TEXT=$(date +'%I:%M %p - %a, %Y-%m-%d' | tr '[:lower:]' '[:upper:]')
CAL=$(cal | sed 's/$/\\n/' | tr -d '\n')
echo "{\"text\":\"$TEXT\",\"tooltip\":\"<tt><small>$CAL</small></tt>\"}"
