import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from sqlalchemy.orm import Session
from models.song import Song
from database import get_db
from middleware.auth_middleware import auth_middleware

router = APIRouter()

cloudinary.config( 
    cloud_name = "dypzio4rm", 
    api_key = "488759228113154", 
    api_secret = "hUBVkEYQTRFYHxjCbBkgxduC0Js",
    secure=True
)

@router.post("/upload", status_code=201)
def upload_song(
    audio: UploadFile = File(...),
    thumbnail:UploadFile =File(...),
    artist:str=Form(...),
    song_name:str=Form(...),
    hex_code:str=Form(...),
    db:Session= Depends(get_db),
    auth_dict =Depends(auth_middleware)  # Assuming you have a get_db dependency to get the database session
    ):
    try:
        song_id = str(uuid.uuid4())
        song_res = cloudinary.uploader.upload(audio.file, resource_type="auto", folder=f'songs/{song_id}')

        thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type="image", folder=f'songs/{song_id}')

        new_song = Song(
            id=song_id,
            artist=artist,
            song_name=song_name,
            hex_code=hex_code,
            audio_url=song_res['url'],
            thumbnail_url=thumbnail_res['url']
        )
        db.add(new_song)
        db.commit()
        db.refresh(new_song)
        return new_song
    except Exception as e:
        print(f"Error uploading files: {e}")
        raise HTTPException(400, "Error uploading files")