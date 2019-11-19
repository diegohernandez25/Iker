from typing import List, Dict
from flask import Flask, redirect, url_for, request, jsonify
import mysql.connector
import json
import requests
import datetime
import json

from logging.config import dictConfig
from sqlalchemy import create_engine
from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from database.operations import *
from database.base import Base, engine, Session

dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': 'ext://flask.logging.wsgi_errors_stream',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})

app = Flask(__name__)

session = Session()

@app.route('/')
def index() -> str:
    return "Booking"

@app.route('/create_usr')
def create_user():
    #Get the authentication id of the user obtained by the authentication service
    auth_id = request.args.get('id_auth')

if __name__ == '__main__':
    app.run(host='0.0.0.0')


@app.route("/test_trip", methods=['POST'])
def test_trip():
	print(requests.post("localhost:8081/probe_trip",data=request.json))

@app.route("/put_trip", methods=['POST'])
def put_trip():
	requests.post("localhost:8081/register_trip",data=request.json)


