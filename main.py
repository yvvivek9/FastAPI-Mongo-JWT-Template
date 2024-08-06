from fastapi import FastAPI
import uvicorn
from dotenv import load_dotenv
import os
from app.routes import auth, hospital

fastAPI = FastAPI()
load_dotenv()

fastAPI.include_router(auth.router, prefix="/api/auth", tags=["auth"])
fastAPI.include_router(hospital.router, prefix="/api/hospital", tags=["hospital"])

port = os.getenv('PORT')

if __name__ == "__main__":
    uvicorn.run("main:fastAPI", host="0.0.0.0", port=int(port), reload=True)
