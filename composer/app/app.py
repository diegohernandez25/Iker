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
import time

from logging.config import dictConfig
from sqlalchemy import create_engine
from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from database.operations import *
from database.base import Base, engine, Session
from database.entities import *

from views.conf import *
from views.usr_view import usr_blueprint
from views.event_view import event_blueprint
from views.trip_view import trip_blueprint
from views.review_view import review_blueprint

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
app.register_blueprint(usr_blueprint)
app.register_blueprint(event_blueprint)
app.register_blueprint(trip_blueprint)
app.register_blueprint(review_blueprint)


def check_service()->Boolean:
    global BOOKING_SERVICE_ID

    r   = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID))

    if (r.text=="ERROR"):
        return False

    return True if (r.json()['name'] == BOOKING_SERVICE_NAME) else False


def create_service():
    global BOOKING_SERVICE_ID

    body = {    'name': 'carpooling-es-19',
                'information':{
                    'authors':['Diego','Andre','Rodrigo','Dinis']
                }
            }
    r = requests.post(URL_RESERVATION + "service", json=body)
    BOOKING_SERVICE_ID = r.json()['id']


if __name__ == '__main__':
    if not check_service():
        create_service()
    else:
        app.logger.info("Service was already created")

    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0')
