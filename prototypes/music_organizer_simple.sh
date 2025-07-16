#!/bin/bash

get_album() {
    ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "$1"
}

get_artist() {
    ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$1"
}

input=$1
output=$2

mkdir -p "$output/Unknown artist"

# Loop through every file in input
for file in "$input"/*; do
    artist=$(get_artist "$file")
    album=$(get_album "$file")
    # If no artist: move to "Unknown artist/"
    if [[ -z "$artist" ]]; then
        mv "$file" "$output/Unknown artist"
    else
        # Create folder for artist
        mkdir -p "$output/$artist"
        # If no album, move to "artist/"
        if [[ -z "$album" ]]; then
            mv "$file" "$output/$artist"
        else
            # If both artist and album are found, make "artist/album/" and move there
            mkdir -p "$output/$artist/$album"
            mv "$file" "$output/$artist/$album"
        fi
    fi
done 
