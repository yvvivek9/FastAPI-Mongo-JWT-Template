from pydantic import BaseModel


class CustomResponse(BaseModel):
    detail: str


class LoginResponse(BaseModel):
    token: str
