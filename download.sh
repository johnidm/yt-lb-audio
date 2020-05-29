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
# 

if [ -z $1 ] ; then
    echo ""
    echo "Subtitle language is required!"
    echo "Usage: './download.sh <subtitle lang>'"
    echo ""
    exit 1
fi

download_dir="./downloads"

lang=$1

rm -rf $download_dir
mkdir -p $download_dir

for url in $(<download.txt); do    
    youtube-dl $url --write-sub --sub-lang $lang --sub-format vtt --extract-audio --audio-format mp3 -f bestaudio -o "${download_dir}/%(title)s.%(ext)s"
done

for audio_file in $download_dir/*.mp3; do
    [ -f "$audio_file" ] || break

    basename=${audio_file%.*}

    echo "$basename"

    subtitle_file=${basename}.$lang.vtt
    wav_file=${basename}.$lang.wav

    ffmpeg -i "$audio_file" -acodec pcm_s16le -ac 1 -ar 16000 "$wav_file"
done
