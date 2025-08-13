from pydantic import BaseModel


class UserGet(BaseModel):
    email:str
    password:str