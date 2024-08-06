from fastapi import APIRouter, HTTPException
import bcrypt

from app.config.auth import sign_jwt
from app.repos.user import *
from app.utils.response import *

router = APIRouter()
salt = bcrypt.gensalt()


@router.post('/register')
async def register(user: User) -> CustomResponse:
    check_user = await find_user_by_username(user.username)
    if check_user:
        raise HTTPException(status_code=406, detail="User already exists")
    pwd_bytes = user.password.encode('utf-8')
    hashed_pwd = bcrypt.hashpw(pwd_bytes, salt)
    user.password = hashed_pwd.decode('utf-8')
    await save_user(user=user)
    return CustomResponse(detail="Registration successful")


class LoginRequestBody(BaseModel):
    username: str
    password: str


@router.post('/login')
async def login(body: LoginRequestBody) -> LoginResponse:
    user = await find_user_by_username(body.username)
    if user and bcrypt.checkpw(body.password.encode('utf-8'), user.password.encode('utf-8')):
        token = await sign_jwt(user_id=str(user.id))
        return LoginResponse(token=token)
    else:
        raise HTTPException(status_code=404, detail="Invalid credentials")

