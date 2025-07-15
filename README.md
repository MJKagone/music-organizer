# music-organizer

A Bash script for organizing music files by artist and album using metadata tags via `ffprobe`. Searches recursively through the specified directory and groups every audio file into "artist/album/" based on the tags found, or into "Unknown artist" if not found. 

## Dependencies

- `ffprobe` (part of [ffmpeg](https://ffmpeg.org/download.html), `sudo apt install ffprobe` on Ubuntu)

## Installation

Clone the repo and copy the script to your path:

```
git clone https://github.com/MJKagone/music-organizer.git
cd music-organizer
chmod u+x music-organizer.sh
cp music-organizer.sh ~/.local/bin/music-organizer # or wherever you store your scripts
```

## Usage
```
music-organizer <input_directory> <output_directory>
```
