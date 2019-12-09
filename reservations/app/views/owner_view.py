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

owner_blueprint = Blueprint('owner_view', __name__)

@owner_blueprint.route('/<id>/owner', methods=['POST'])
def create_owner_api(id)->str:

    body = request.json
    session = Session()
    service = get_service(session, id)
    if service is not None:
        owner = create_owner(session, service, body['name'], body['information'],None,datetime.datetime.now())
        owner.url="/service/%d/owner/%d" % (service.id,owner.id)
        session.commit()
        response = owner.get_dict()
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"

@owner_blueprint.route('/<id>/owner/<id_owner>', methods=['GET', 'DELETE'])
def get_owner_api(id, id_owner)->str:

    session = Session()
    service = get_service(session, id)
    owner = get_owner(session, id_owner)

    if request.method == 'GET':
        if (service is not None) and (owner is not None) and (owner in service.owner):
            response = get_json_owner(owner)
            session.close()
            return response

        session.close()
        return "ERROR"

    delete_owner(session,owner=owner)
    session.close()
    return "DELETED"
