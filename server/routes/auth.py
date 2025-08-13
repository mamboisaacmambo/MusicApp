import json
from fastapi.params import Header
import jwt
import bcrypt
import uuid
from fastapi import  Depends, HTTPException
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserGet
router = APIRouter()
@router.post('/signup',status_code=201)
def signup_user(user: UserCreate,db:Session=Depends(get_db)):
    #extract user data from the request
    print(user.name, user.email, user.password)
    # check if user already exists
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        # if user exists, return an error response
        print("User already exists")
        raise HTTPException(status_code=400,detail="User already exists")
    else:
        # if user does not exist, create a new user
        hash_pw = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt())
        new_user = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hash_pw)
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        print(type(new_user))
        return new_user

@router.post('/login')
def login_user(user:UserGet,db:Session=Depends(get_db)):
    print(user.email,user.password)
    user_db2 = db.query(User).filter(User.email==user.email).first()
    if not user_db2:
        raise HTTPException(400,"User with this email does not exist")
    
    is_match = bcrypt.checkpw(user.password.encode('utf-8'), user_db2.password)
    if is_match:
        token = jwt.encode({'id': user_db2.id,},'password_key', algorithm='HS256')
        return {'token':token ,'user':user_db2}
    else:
        raise HTTPException(400, "Incorrect password")

@router.get('/')
def get_user_data(db: Session = Depends(get_db),user_dict: dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user