#!/bin/bash
if [ ! -f "./info.json" ]; then exit 1; fi
mod_name=$(jq -r '.name' ./info.json)
output_file=./${mod_name}_$(jq -r '.version' ./info.json).zip
zip -r "${output_file}" ../${mod_name}/* -x "*/twemoji/*" "*/emojibase/*" "*/data-preprocessing/*" "*/assets/emoji-ordering.txt" "*/.git*" "*/zipper.sh"