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

client_blueprint = Blueprint('client_view', __name__)

@client_blueprint.route('/<id>/client', methods=['POST'])
def create_client_api(id)->str:
    body = request.json
    session = Session()
    service = get_service(session, id)
    if service is not None:
        client = create_client(session, service, body['name'], body['information'],None,datetime.datetime.now())
        client.url="/service/%d/client/%d" % (service.id,client.id)
        session.commit()
        response = client.get_dict()
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"


@client_blueprint.route('/<id>/client/<id_client>', methods=['GET', 'DELETE'])
def get_client_api(id, id_client)->str:

    session = Session()
    service = get_service(session, id)
    client = get_client(session, id_client)

    if request.method == 'GET':
        if (service is not None) and (client is not None)\
            and (client in service.client):

            response = get_json_client(client)
            session.close()
            return response

        session.close()
        return "ERROR"

    delete_client(session, client=client)
    session.close()
    return "DELETED"
