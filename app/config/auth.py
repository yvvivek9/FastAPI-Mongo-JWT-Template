from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.utils.error import CustomError

import time
import jwt
import os

JWT_SECRET = os.getenv('JWT_SECRET')
JWT_ALGORITHM = os.getenv('JWT_ALGORITHM')
JWT_VALIDITY = float(os.getenv('JWT_VALIDITY'))  # in seconds


async def sign_jwt(user_id: str) -> str:
    payload = {
        "user_id": user_id,
        "expires": time.time() + JWT_VALIDITY
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


async def verify_jwt(security: HTTPAuthorizationCredentials = Depends(HTTPBearer(scheme_name='Bearer'))) -> str:
    try:
        decoded = jwt.decode(security.credentials, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        print(decoded)
        if decoded["expires"] >= time.time():
            return decoded["user_id"]
        else:
            raise CustomError("Authorization expired")
    except CustomError as e:
        raise HTTPException(status_code=401, detail=e.message)
    except Exception as e:
        print(f"Error verifying JWT: {e}")
        raise HTTPException(status_code=401, detail="Invalid authentication")


async def verify_jwt_and_admin(security: HTTPAuthorizationCredentials = Depends(HTTPBearer(scheme_name='Bearer'))) -> str:
    try:
        decoded = jwt.decode(security.credentials, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        print(decoded)
        if decoded["expires"] >= time.time():
            # TODO: finish this and write login, signup routes and models
            id = decoded["user_id"]
        else:
            raise CustomError("Authorization expired")
    except CustomError as e:
        raise HTTPException(status_code=401, detail=e.message)
    except Exception as e:
        print(f"Error verifying JWT: {e}")
        raise HTTPException(status_code=401, detail="Invalid authentication")
