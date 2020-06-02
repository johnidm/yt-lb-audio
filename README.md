# yt-lb-audio

This is a tool to download and create labeled audio datasets from YouTube videos.

You need to execute two steps:

## First step: download audio files and subtitles and convert audio format

- Add the YouTube video URLs, one per line, to the `download.txt` file. The selected videos must have subtitles for the desired language.

- Run the script `./download.sh <subtitle lang>`.
    * Subtitle languages are typically two-letter codes e.g. `pt`, `es`, `en`, `ru` etc., but some videos might have subtitles with more specific language tags, e.g. `en-US`, `pt-BR`.
    * To list the available subtitles for a given video URL, you may run
      `youtube-dl --list-subs <video URL>`.

- The files are written to the `downloads` folder.
    * If the `downloads` folder already exists, the script will ask if it should be recreated. Answering `y` means existing data will be erased.

For each video, three files will be created with the following extensions:
    * `vtt`: subtitles.
    * `mp3`: original audio.
    * `wav`: converted audio.

## Second step: split audios and subtitles to create the corpus

- Install dependencies: `pip install -r requirements.txt`.
    * Works with any Python 3.x version.

- Run the script `python main.py <subtitle lang>`, where `<subtitle lang>` should be the same as in the first step.

- The labeled audio dataset is written to the `corpus` folder.
    * If the `corpus` folder already exists, the python script will ask if it should be recreated. Answering `y` means existing data will be erased.

The `corpus` folder will have the following structure:

```markdown
corpus/
    - <randon UUID>
        01.txt
        01.wav
        02.txt
        02.wav
        ...

    - <randon UUID>
        01.txt
        01.wav
        02.txt
        02.wav
        03.txt
        03.wav
        ...
    ...
```

### Testing the tool :rocket:

If you would like to quickly test the scripts, just run the commands below:

```shell
./download.sh pt
```

```python
python main.py pt
```

If everything works, a `corpus` folder should have been created and it should contain the labeled audio data.
