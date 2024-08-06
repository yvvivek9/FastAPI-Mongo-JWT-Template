from pydantic import BaseModel
from app.config.database import get_database
from bson.objectid import ObjectId

COLLECTION_NAME = "users"


class User(BaseModel):
    username: str
    password: str
    userType: str


async def save_user(user: User):
    db = await get_database()
    clc = db[COLLECTION_NAME]
    clc.insert_one(user.model_dump())


async def find_user_by_username(username: str) -> User:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"username": username}
    return User(**clc.find_one(query))


async def find_user_by_id(uid: str) -> User:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"_id": ObjectId(uid)}
    return User(**clc.find_one(query))

