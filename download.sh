#!/bin/bash
#
# Downloads audio + subtitles in the specified language from YouTube
# Converts the audio to 16 KHz mono WAV
#
# How to use:
#       Add the YouTube video URLs to download.txt.
#       Run the script './download.sh <subtitle lang>' (check README for list of languages).
#       All files will be written to the 'downloads directory.
#
# Author: Johni Douglas Marangon - https://github.com/johnidm

if [ -z $1 ]; then
    echo ""
    echo "Subtitle language is required!"
    echo "Usage: './download.sh <subtitle lang>'"
    echo ""
    exit 1
fi

exists() {
    command -v "$1" >/dev/null 2>&1
}

if ! exists youtube-dl; then
    echo "'youtube-dl' is required!"
    echo "Please, follow the instructions to install http://ytdl-org.github.io/youtube-dl/download.html"
    exit 1
fi

if ! exists ffmpeg; then
    echo "'ffmpeg' is required!"
    echo "Please, follow the instructions to install https://ffmpeg.org/download.html"
    exit 1
fi

download_dir="./downloads"
lang=$1

if [ -d "$download_dir" ]; then
    while true; do
        read -p "Do you wish to remove existing ${download_dir} folder before proceeding [y/n] ? " answer
        case $answer in
        [Yy]*)
            rm -rf $download_dir
            break
            ;;
        [Nn]*) break ;;
        *) echo "Please answer [y] or [n]." ;;
        esac
    done
else
    mkdir -p $download_dir
fi

for url in $(<download.txt); do
    youtube-dl $url --write-sub --sub-lang $lang --sub-format vtt --extract-audio --audio-format mp3 -f bestaudio -o "${download_dir}/%(title)s.%(ext)s"
done

for audio_file in $download_dir/*.mp3; do
    [ -f "$audio_file" ] || break

    basename=${audio_file%.*}

    echo "$basename"

    subtitle_file=${basename}.$lang.vtt
    wav_file=${basename}.$lang.wav

    ffmpeg -y -i "$audio_file" -acodec pcm_s16le -ac 1 -ar 16000 "$wav_file"
done
