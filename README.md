# Music Organizer

A Bash script I wrote for organizing my messy audio files by artist and album using metadata tags via `ffprobe`. Searches recursively through the specified directory and moves every audio file into `artist/album/` (creating folders as necessary) based on the tags found, or into `Unknown artist/` if not found.

**Example.** Input directory:

```
Input directory/
├── Random folder/
│   ├── In the End.mp3
│   └── Bring Me to Life.mp3
├── Nemo.mp3
├── My Immortal.mp3
├── Original_recording.mp3
```

Output directory after running the script:

```
Output directory/
├── Linkin Park/
│   └── Hybrid Theory/
│       └── In the End.mp3
├── Evanescence/
│   └── Fallen/
│       ├── Bring Me to Life.mp3
│       └── My Immortal.mp3
├── Nightwish/
│   └── Once/
│       └── Nemo.mp3
├── Unknown artist/
│   └── Original_recording.mp3
```

(Full disclosure: the simpler script in the `prototypes/` folder is how far I got by myself before letting GPT take the wheel and vibe coding the recursive search and string sanitization.)

## Dependencies

- `ffprobe`: part of [ffmpeg](https://ffmpeg.org/download.html), `sudo apt install ffmpeg` on Ubuntu

## Installation

Clone the repo and copy the script to your path:

```
git clone https://github.com/MJKagone/music-organizer.git
cd music-organizer
chmod u+x music-organizer.sh
cp music-organizer.sh ~/.local/bin/music-organizer # or whatever folder included in $PATH
```

## Usage
```
music-organizer <input_directory> <output_directory>
```

## Possible improvements:

- [ ] Custom processing (or skipping) for non-audio files: currently moved to `Unknown artist/`
- [ ] Performance optimization / switching `ffprobe` for another tool: takes ~10 minutes to process ~1000 files
