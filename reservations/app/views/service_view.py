from typing import List, Dict
from flask import Flask, redirect, url_for, request, jsonify, Blueprint, render_template
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

service_blueprint = Blueprint('service_view', __name__)

@service_blueprint.route('/service', methods=['POST'])
def create_service_api()->str:

    session = Session()
    body = request.json
    service = create_service(session, body['name'], body['information'],None,datetime.datetime.now())
    service.url="/service/%d" % (service.id)
    session.commit()

    response = service.get_dict()
    session.close()

    return json.dumps(response)

@service_blueprint.route('/<id>', methods=['GET'])
def get_service_api(id):

    session = Session()
    service = get_service(session, id)
    if service is not None:
        response = get_json_service(service)
        session.close()
        return response

    session.close()
    return "ERROR"
