from fastapi import FastAPI
import uvicorn
from dotenv import load_dotenv
import os
from app.routes import auth, check

fastAPI = FastAPI()
load_dotenv()

fastAPI.include_router(auth.router, prefix="/api/auth", tags=["auth"])
fastAPI.include_router(check.router, prefix="/api/check", tags=["check"])

port = os.getenv('PORT')

if __name__ == "__main__":
    uvicorn.run("main:fastAPI", host="0.0.0.0", port=int(port), reload=True)
