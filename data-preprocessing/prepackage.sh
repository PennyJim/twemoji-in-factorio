#!/bin/bash

echo "processing shortcodes"
node ./data-preprocessing/shortcodes.js
error=$?
if [[ $error -ne 0 ]]; then
	echo "Something went wrong with processing the shortcodes"
	exit $error
fi

echo "fetching emoji-ordering.txt"
curl https://www.unicode.org/emoji/charts/emoji-ordering.txt -o ./data-preprocessing/emoji-ordering.txt
error=$?
if [[ $error -ne 0 ]]; then
	echo "Something went wrong with obtaining emoji-ordering.txt"
	exit $error
fi

# echo "staging emoji-ordering.txt"
# git stage ./data-preprocessing/emoji-ordering.txt
# error=$?
# if [[ $error -ne 0 ]]; then
# 	echo "Something went wrong with staging the new emoji-ordering.txt"
# 	exit $error
# fi

echo "processing emoji-ordering.txt"
lua ./data-preprocessing/ordering.lua
error=$?
if [[ $error -ne 0 ]]; then
	echo "Something went wrong with processing the new ordering"
	exit $error
fi

echo "Currently cannot exclude the images in 'missing-codes.txt'"