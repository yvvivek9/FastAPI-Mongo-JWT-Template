from fastapi import APIRouter, Depends

from app.config.auth import *

router = APIRouter()


@router.post('/normal')
async def normal(uid: str = Depends(verify_jwt)):
    return uid


@router.post('/admin')
async def admin(uid: str = Depends(verify_jwt_and_admin)):
    return uid
