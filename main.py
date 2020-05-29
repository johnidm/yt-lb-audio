#
# Splits the WAV audio file according to the times in the subtitle file.
#
# How to use:
#       Run the script 'python main.py <subtitle lang>'.
#       Output will be written to the 'corpus' directory.
#
# Author: Johni Douglas Marangon - https://github.com/johnidm
#

import webvtt
import uuid
from pydub import AudioSegment
from datetime import datetime
import os
import glob
import shutil
import sys
from unidecode import unidecode
import string


if len(sys.argv) != 2:
    print("")
    print("Subtitle language is required!")
    print("Usage: 'python main.py <subtitle lang>'")
    print("")

    exit(1)


def to_sec(t):
    """
        Convert canonical time format to milliseconds
        Example:
            - 00:00:10.930 to 10930
    """
    td = datetime.strptime(t, '%H:%M:%S.%f') - datetime(1900, 1, 1)
    return int(td.total_seconds() * 1000)


def text_cleaner(text):
    """
        Clean up the source text
        Steps:
            - remove accents
            - remove punctuation
            - remove newlines and double spaces
            - convert to lowercase  
    """
    text = unidecode(text)
    text = text.translate(str.maketrans('', '', string.punctuation))
    text = " ".join(text.split())
    text = text.lower()
    return text


directory = 'corpus'

lang = sys.argv[1]

if os.path.exists(directory):
    shutil.rmtree(directory)


os.makedirs(directory)


files = glob.glob(f'downloads/*.{lang}.wav')


for audio_file in files:
    root_file, _ = os.path.splitext(audio_file)

    subtitle_file = f"{root_file}.vtt"

    audio = AudioSegment.from_wav(audio_file)

    basename = f"{directory}/{str(uuid.uuid4())}"

    os.makedirs(basename)

    for index, caption in enumerate(webvtt.read(subtitle_file), start=1):

        basename_file = f"{basename}/{str(index)}"

        part_audio_filename = f"{basename_file}.wav"
        part_sub_filename = f"{basename_file}.txt"

        t1 = to_sec(caption.start)
        t2 = to_sec(caption.end)

        part_audio = audio[t1:t2]
        part_audio.export(part_audio_filename, format="wav")

        with open(part_sub_filename, 'w') as f:
            f.write(text_cleaner(caption.text))

print("Done! The labeled audio datasets are avaliable in 'corpus' folder.")