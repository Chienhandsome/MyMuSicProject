from fastapi import FastAPI, Query, HTTPException
from fastapi.responses import FileResponse
import subprocess
import uuid
import os

app = FastAPI()

DOWNLOAD_DIR = "downloads"
os.makedirs(DOWNLOAD_DIR, exist_ok=True)


@app.get("/mp3")
def download_mp3(url: str = Query(...)):
    file_id = str(uuid.uuid4())
    output_path = os.path.join(DOWNLOAD_DIR, f"{file_id}.%(ext)s")

    cmd = [
        "yt-dlp",
        "-x",
        "--audio-format", "mp3",
        "-o", output_path,
        url
    ]

    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        raise HTTPException(status_code=400, detail="Download failed")

    mp3_file = os.path.join(DOWNLOAD_DIR, f"{file_id}.mp3")
    if not os.path.exists(mp3_file):
        raise HTTPException(status_code=500, detail="MP3 not found")

    return FileResponse(mp3_file, media_type="audio/mpeg", filename="audio.mp3")
