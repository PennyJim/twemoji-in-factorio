#!/bin/bash
zip -r ~/Downloads/twemoji-in-factorio_$(jq -r '.version' ./info.json).zip * -x "twemoji/*" "assets/ordering-preprocessing.lua" "assets/emoji-ordering.txt" ".git*" "zipper.sh"