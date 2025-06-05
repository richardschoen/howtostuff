# How to install Python FastAPI Web Framework and Get Started on IBM i 
FastAPI is a Python high performance web framework

Uvicorn is a lightning fast ASGI web server

## Visit the FastAPI site
https://fastapi.tiangolo.com

## Visit the Uvicorn site
http://www.uvicorn.org  

## Sample site from Niels Liisberg  
https://github.com/NielsLiisberg/Python-FastAPI-demo     

## Installing on IBM i 

**Pre-requisite**

Make sure all ```Python 3``` options are installed by the ``Open Source Package Management``` menu option in ACS

Log in to an IBM i SSH terminal session and make sure bash is the current shell

**Install fastapi - latest**

```pip3 install fastapi```

**Install fastapi for Python 3.9 - Use fastapi Version 0.110.3**   
Did a stepped install of each of these versions. You might just be able to install ```0.110.3```
```pip3 install fastapi==0.83.0```   
```pip3 install fastapi==0.84.0```   
```pip3 install fastapi==0.89.0```   
```pip3 install fastapi==0.95.0```   
```pip3 install fastapi==0.99.1```   
```pip3 install fastapi==0.100.1```   
```pip3 install fastapi==0.108.0```   
```pip3 install fastapi==0.110.3```   
    
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


## Running Your App from the IBM i SSH/Bash Command Line

```
cd /pythonfastapi

uvicorn main:app --reload  --port 3434
```

This will start your app on port 3434. The results should look like the following. And the web app server will restart any time a page change is made.

```
INFO:     Will watch for changes in these directories: ['/home/RICHARD/richard/pythonfastapi']
INFO:     Uvicorn running on http://0.0.0.0:3434 (Press CTRL+C to quit)
INFO:     Started reloader process [2530954] using watchgod
INFO:     Started server process [2530956]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

## Exposing App to the Web
If you plan to expose your web app to the Internet, it's probably a good idea to set up an NGINX web server as a web front end that also uses SSL for secure communications. NGINX can proxy/pass all web traffic to youe Uvicorn server. 

Note: It's possible Uvicorn can be exposed without using NGINX, but I would recommend exploring this more on the Uvicorn web site and doing appropriate research before you expose your app server to the web. http://www.uvicorn.org/deployment


## Trying out your sample app from a web browser

The following URL will display the Hello World response

```http://[hostname]:3434```   

The following URL will display the /items route response

```http://[hostname]:3434/items/1/q=SampleQuery```   

Displaying Open API/Swagger Documentation and Testing API

```http://[hostname]:3434/docs```  

Displaying ReDoc Documentation and Testing API

```http://[hostname]:3434/redoc```  

## Sample Packages Needed for Fast API
``` pip3.9 install pyodbc```   
``` pip3.9 install itoolkit```   
``` pip3 install fastapi==0.83.0``` (You may just be able install 0.110.3)     
``` pip3 install fastapi==0.110.3```
``` pip3 install uvicorn```
``` pip3.9 install flask``` (Not actually needed for FastAPI, but I use flask as well)    






