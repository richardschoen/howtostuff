# How to install Python FastAPI Web Framework and Get Started on IBM i 
FastAPI is a Python high performance web framework

Uvicorn is a lightning fast ASGI web server

## Visit the FastAPI site
https://fastapi.tiangolo.com

## Visit the Uvicorn site
https://uvicorn.org

## Installing on IBM i 

Pre-requisite

Make sure all ```Python 3``` options are installed by the ``Open Source Package Management``` menu option in ACS

Log in to an IBM i SSH terminal session and make sure bash is the current shell

**Install fastapi**
```pip3 install fastapi```

**Install uvicorn (The lightning fast ASGI server). This will be our web app server component**

```pip3 install uvicorn```  

**Note: Dont install with the [standard] option. This will possibly cause errors when trying to build some of the wheels.**

## Your First App in Less Than a Minute (Also with OpenAPI Docs).

Create an IFS folder for your project. 
```
cd /

mkdir /pythonfastapi
```

Create a new main.py file with the following lines:

```
from typing import Optional

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}
```


## Running Your App from the SSH/Bash Command Line

```
cd /pythonfastapi

uvicorn main:app --reload  --port 3434
```

This will start your app on port 3434

## Trying out your sample app from a web browser

The following URL will display the Hello World response
```http://[hostname]:3434/```   

The following URL will display the /items route response
```http://[hostname]:3434/items/1/q=SampleQuery```   

Displaying Open API/Swagger Documentation and Testing API
```http://[hostname]:3434/docs```  

Displaying ReDoc Documentation and Testing API
```http://[hostname]:3434/redoc```  
