from fastapi import HTTPException
from fastapi.params import Header
import jwt


def auth_middleware(x_auth_token = Header()):
    # This function will be used to handle authentication middleware
    try:
        #get the user token from the headers
        if not x_auth_token:
            raise HTTPException(status_code=401, detail="Authentication token is missing, access denied")
        #decode the token to get the user id
        verified_token =  jwt.decode(x_auth_token,'password_key', algorithms=["HS256"])
        if not verified_token:
            raise HTTPException(status_code=401, detail="Token verification failed, access denied")
        #get the id from the token
        uid = verified_token.get('id')
        return {'uid': uid,'token': x_auth_token}
        #get the user from the database using the id
    except jwt.PyJWTError as e:
        raise HTTPException(status_code=401, detail="Invalid token, access denied")