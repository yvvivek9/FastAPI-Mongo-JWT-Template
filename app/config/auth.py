from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import time
import jwt
import os

from app.utils.error import CustomError
from app.repos.user import find_user_by_id

JWT_SECRET = os.getenv('JWT_SECRET')
JWT_ALGORITHM = os.getenv('JWT_ALGORITHM')
JWT_VALIDITY = os.getenv('JWT_VALIDITY')  # in seconds


async def sign_jwt(user_id: str) -> str:
    payload = {
        "user_id": user_id,
        "expires": time.time() + float(JWT_VALIDITY)
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


async def verify_jwt(security: HTTPAuthorizationCredentials = Depends(HTTPBearer(scheme_name='Bearer'))) -> str:
    try:
        decoded = jwt.decode(security.credentials, JWT_SECRET, algorithms=[JWT_ALGORITHM])
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
        if decoded["expires"] >= time.time():
            uid = decoded["user_id"]
            user = await find_user_by_id(uid)
            if user and user.userType == "admin":
                return str(user.id)
            else:
                raise CustomError("Access forbidden")
        else:
            raise CustomError("Authorization expired")
    except CustomError as e:
        raise HTTPException(status_code=401, detail=e.message)
    except Exception as e:
        print(f"Error verifying JWT: {e}")
        raise HTTPException(status_code=401, detail="Invalid authentication")
