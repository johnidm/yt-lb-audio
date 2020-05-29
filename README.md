This is a tool to download and create labeled audio datasets from YouTube videos.

You need to execute two steps:

### First step: download audio files and subtitles and convert audio format

 - Add the YouTube video URLs to the `download.txt` file. The selected videos must have subtitles for the desired language.

 - Run the script `./download.sh <subtitle lang>`, where `<subtitle lang>` is the two-letter language code, e.g. `pt`, `es`, `en`, `ru`, etc. 

 - The files are written to the `downloads` folder. 
 
 For each video, three files will be created with the following extensions:
    - `vtt`: subtitles
    - `mp3`: original audio
    - `wav`: converted audio

### Second step: split audios and subtitles to create the corpus

- Install dependencies: `pip install -r requirements.txt` 

- Run the script `python main.py <subtitle lang>`, where `<subtitle lang>` should be the same as in the first step.

- The labeled audio dataset is written to the `corpus` folder.

The `corpus` folder will have the following structure:

```
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

If you would like to learn more about labeled audio datasets, please read []().
