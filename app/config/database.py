from pymongo import MongoClient
import os

DB_URL = os.getenv('MONGODB_URI')
DB_NAME = os.getenv('MONGODB_DB')


async def get_database():
    # Create a connection using MongoClient. You can import MongoClient or use pymongo.MongoClient
    client = MongoClient(DB_URL)

    # Specify the name of the database to be used
    return client[DB_NAME]


# This is added so that many files can reuse the function get_database()
if __name__ == "__main__":
    # Get the database
    db = get_database()
