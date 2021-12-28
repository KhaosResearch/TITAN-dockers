import json
import os

import typer
from pymongo import MongoClient, errors


def import2db(
    filepath: str = typer.Option(..., help="Name of the JSON file"),
    username: str = typer.Option(..., help="Host of MongoDB"),
    password: str = typer.Option(..., help="Password of MongoDB"),
    collection: str = typer.Option(..., help="Collection of MongoDB"),
):
    os.chdir("data")

    # Read Data
    f = open(filepath)
    data = json.load(f)

    # Mongo Client
    c = MongoClient("mongodb://192.168.213.38:27017/", username=str(username), password=str(password))
    db = c.floraInventory
    collection = db[collection]

    # Upload file
    for d in data:
        try:
            collection.insert_one(d)
        except (errors.OperationFailure):
            print("Can not insert document ", str(d))


if __name__ == "__main__":
    typer.run(import2db)
