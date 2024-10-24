#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir"/utils.sh

musicplayer=fooyin

# Function to convert seconds to minutes:seconds format
convert_to_min_sec() {
    total_seconds=$1
    minutes=$((total_seconds / 60))
    seconds=$((total_seconds % 60))
    printf "%02d:%02d" $minutes $seconds
}

# Check if playerctl returns "No players found"
if playerctl -p $musicplayer metadata title 2>&1 | grep -q "No players found"; then
    exit 0
fi

if playerctl -p $musicplayer metadata artist 2>&1 | grep -q "No players found"; then
    exit 0
fi

# Get the song title and artist
song=$(playerctl -p $musicplayer metadata title)
artist=$(playerctl -p $musicplayer metadata artist)

# Get the song duration in microseconds (convert to seconds)
duration_microseconds=$(playerctl -p $musicplayer metadata mpris:length)
duration_seconds=$((duration_microseconds / 1000000))

# Get the current position in seconds (truncate to an integer)
position_seconds=$(playerctl -p $musicplayer position | cut -d. -f1)

# Convert duration and position to minutes:seconds format
duration=$(convert_to_min_sec $duration_seconds)
position=$(convert_to_min_sec $position_seconds)

# Combine them as 'song - artist'
main() {
  RATE=$(get_tmux_option "@tmux2k-refresh-rate" 5)
  echo "󰝚  [$position/$duration] $song - $artist"
  sleep "$RATE"
}

main
