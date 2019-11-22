from typing import List, Dict
from flask import Flask, redirect, url_for, request, jsonify, request
import mysql.connector
import json
import requests
import datetime
import json
import requests
import string
import random
import logging
import sys

from logging.config import dictConfig
from sqlalchemy import create_engine
from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from database.operations import *
from database.base import Base, engine, Session
from database.entities import *


URL_RESERVATION = "http://localhost:5002/1/"
URL_TRIP_FOLLOWER = "http://localhost:8081/"

logging.basicConfig(level=logging.DEBUG)

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

@app.route("/test_trip", methods=['POST'])
def test_trip():
	print(requests.post("localhost:8081/probe_trip",data=request.json))

@app.route("/put_trip", methods=['POST'])
def put_trip():
	requests.post("localhost:8081/register_trip",data=request.json)

"""
Account Setup Flow
"""
#TODO: Check if it is not registered. DONE
@app.route("/create_usr", methods=['POST'])
def createUser():
    #Get Authentication Id from query parameter
    authentication_id = request.args.get('usr_id')

    #Create Owner in booking service
    body        = request.json
    if set(["name", "information"]).issubset(set(body.keys())) and\
        not usr_exists(session, authentication_id):
        #Get new owner id
        b_json  = {"name":body["name"],"information":body["information"]}
        r       = requests.post(URL_RESERVATION + "owner", json=b_json)

        owner_id = r.json()['id']

        #Get new client id
        b_json  = {"name":body["name"],"information":body["information"]}
        r       = requests.post(URL_RESERVATION + "client", json=b_json)
        client_id = r.json()['id']

        #generate random access_token
        access_token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(15))

        #create line register to the composer database
        usr = create_user(session, authentication_id, owner_id, client_id,
                            access_token)

        response = {"id": usr.id, "access_token":usr.access_token}
        return json.dumps(response)

    else:
        app.logger.error('Invalid JSON body. "name" or "information" fields may\
            not be explicit.')
        return "ERROR"

@app.route("/register_trip", methods=['POST'])
def book_trip()->str:

    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    body            = request.json

    if set(["StartCoords", "EndCoords","Consumption","AvoidTolls","StartTime",
            "EndTime","MaxDetour","FuelType"]).issubset(set(body.keys())) and\
            valid_usr(session, user_id, access_token):

        r       = requests.post(URL_TRIP_FOLLOWER + "register_trip", json=body)
        id_iptf = r.json()

        user    = get_usr(session, user_id)
        owner_id    = user.id_owner_booking
        url     = URL_RESERVATION+"owner/"+str(owner_id)+"/domain"
        d_json  = {"name": body["name"], "information": body["information"]}
        r       = requests.post(url, json=d_json)
        id_domain_booking   = r.json()['id']

        #Save trip mapping
        trip = create_trip(session, id_domain_booking, id_iptf, user_id)
        return json.dumps(trip.get_dict())

    else:
        return "ERROR"



if __name__ == '__main__':
    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0')
