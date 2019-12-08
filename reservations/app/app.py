from typing import List, Dict
from flask import Flask, redirect, url_for, request, jsonify
import mysql.connector
import json
import datetime
import json

from logging.config import dictConfig
from sqlalchemy import create_engine
from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from database.operations import *
from database.base import Base, engine, Session
from json_op import *

from views.service_view import service_blueprint
from views.owner_view import owner_blueprint
from views.domain_view import domain_blueprint
from views.element_view import element_blueprint
from views.client_view import client_blueprint
from views.reservation_view import reservation_blueprint

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
app.register_blueprint(service_blueprint)
app.register_blueprint(owner_blueprint)
app.register_blueprint(domain_blueprint)
app.register_blueprint(element_blueprint)
app.register_blueprint(client_blueprint)
app.register_blueprint(reservation_blueprint)


@app.route('/')
def index() -> str:
    return "Booking"

if __name__ == '__main__':
    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0', port=5002)
