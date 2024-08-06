from pydantic import BaseModel, Field, ConfigDict
from typing import Optional
from app.config.database import get_database
from bson.objectid import ObjectId

COLLECTION_NAME = "users"


class User(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    username: str
    password: str
    userType: str

    # class Config:
    #     arbitrary_types_allowed = True

    def __init__(self, **data):
        if '_id' in data and isinstance(data['_id'], ObjectId):
            data['_id'] = str(data['_id'])
        super().__init__(**data)


async def save_user(user: User):
    db = await get_database()
    clc = db[COLLECTION_NAME]
    user_json = user.model_dump(by_alias=True)
    user_json.pop('_id')
    clc.insert_one(user_json)


async def find_user_by_username(username: str) -> Optional[User]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"username": username}
    res = clc.find_one(query)
    if res:
        return User(**res)
    return None


async def find_user_by_id(uid: str) -> Optional[User]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"_id": ObjectId(uid)}
    res = clc.find_one(query)
    if res:
        return User(**res)
    return None

