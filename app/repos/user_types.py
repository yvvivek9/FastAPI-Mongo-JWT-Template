from pydantic import BaseModel
from typing import List
from app.config.database import get_database

COLLECTION_NAME = "userTypes"


class UserType(BaseModel):
    name: str
    canDelete: bool = True
    canRegister: bool = False


async def list_registrable_user_types() -> List[UserType]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"canRegister": True}
    result = clc.find(query)
    ret_list = []
    for r in result:
        ret_list.append(UserType(**r))
    return ret_list
