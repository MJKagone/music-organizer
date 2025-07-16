#!/bin/bash

shopt -s globstar nullglob

get_album() {
    # Returns the album tag or an empty string if not found
    ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "$1"
}

get_artist() {
    # Returns the artist tag or an empty string if not found
    ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$1"
}

organize_music() {
    input=$1
    output=$2

    if [[ -z "$input" || -z "$output" ]]; then
        echo "Usage: organize_music <input_directory> <output_directory>"
        return 1
    fi
    
    declare -A created_dirs
    
    current_dir=""

    while IFS= read -r -d '' file; do
        [[ -f "$file" ]] || continue
        
        # Progress tracker
        dir=$(dirname "$file")
        if [[ "$dir" != "$current_dir" ]]; then
            current_dir="$dir"
            echo "Moving files from $current_dir..."
        fi

        # Get the first artist and album tags found
        artist=$(get_artist "$file" | cut -d';' -f1)
        album=$(get_album "$file" | cut -d';' -f1)

        # Trim whitespace
        artist="${artist#"${artist%%[![:space:]]*}"}"
        artist="${artist%"${artist##*[![:space:]]}"}"
        album="${album#"${album%%[![:space:]]*}"}"
        album="${album%"${album##*[![:space:]]}"}"

        # Sanitize by dropping problematic characters
        safe_artist=$(echo "$artist" | tr -d '/\\:*?"<>|')
        safe_album=$(echo "$album" | tr -d '/\\:*?"<>|')

        # If no artist tag, move to "Unknown artist" folder
        if [[ -z "$safe_artist" ]]; then
            dest="$output/Unknown artist"
        # Else if no album tag, move to artist folder
        elif [[ -z "$safe_album" ]]; then
            dest="$output/$safe_artist"
        # Else move to artist/album folder
        else
            dest="$output/$safe_artist/$safe_album"
        fi

        # Create destination folder if not encountered before
        if [[ -z "${created_dirs[$dest]}" ]]; then
            mkdir -p "$dest"
            created_dirs["$dest"]=1
        fi

        # Prepare filename and extension
        filename=$(basename "$file")
        base="${filename%.*}"
        ext="${filename##*.}"
        destination="$dest/$filename"

        # Handle collisions
        counter=1
        while [[ -e "$destination" ]]; do
            echo -e "\033[31mWarning:\033[0m collision at $destination. Renaming file."
            destination="$dest/${base}-$counter.$ext"
            ((counter++))
        done

        # Move the file safely
        mv "$file" "$destination"

    done < <(find "$input" -type f -print0)
}

# Run only if called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    organize_music "$@"
fi
