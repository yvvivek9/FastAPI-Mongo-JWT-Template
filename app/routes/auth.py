from fastapi import APIRouter, Depends, HTTPException

from app.config import auth

router = APIRouter()


@router.post('/start')
async def start():
    return await auth.sign_jwt('125')


@router.post('/check')
async def check(uid: str = Depends(auth.verify_jwt)):
    return uid
