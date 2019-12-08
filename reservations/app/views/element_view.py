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

element_blueprint = Blueprint('element_view', __name__)

@element_blueprint.route('/<id>/owner/<id_owner>/domain/<id_domain>/element', methods=['POST'])
def create_element_api(id, id_owner, id_domain)->str:

    body = request.json

    session = Session()
    service = get_service(session,id)
    owner = get_owner(session, id_owner)
    domain = get_domain(session, id_domain)
    if (service is not None) and (owner is not None) and (domain is not None)\
        and (owner in service.owner) and (domain in owner.domain):

        element = create_element(session, domain, body["name"],
                                 body["information"], None,
                                 datetime.datetime.now(),
                                 body["init_time"], body["end_time"],
                                 body["price"])

        element.url = "/service/%d/owner/%d/domain/%d/element/%d" % (service.id, owner.id, domain.id, element.id)
        element.reserved = False
        session.commit()
        response = element.get_dict()
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"


@element_blueprint.route('/<id>/owner/<id_owner>/domain/<id_domain>/element/<id_element>',
           methods=['GET', 'DELETE'])
def get_element_api(id, id_owner, id_domain, id_element)->str:

    session = Session()
    service = get_service(session, id)
    owner   = get_owner(session, id_owner)
    domain  = get_domain(session, id_domain)
    element = get_element(session, id_element)

    if request.method == 'GET':
        if (service is not None) and (owner is not None) \
            and (domain is not None) and (element is not None)\
             and (owner in service.owner) and (domain in owner.domain)\
              and (element in domain.element):

              response = element.get_dict()
              session.close()
              return json.dumps(response)

        session.close()
        return "ERROR"

    delete_element(session, element=element)
    session.close()
    return "DELETED"

@element_blueprint.route('/<id>/element/<id_element>', methods=['GET', 'DELETE', 'POST'])
def get_element_byid_api(id, id_element):

    session = Session()
    service = get_service(session, id)
    element = get_element(session, id_element)

    client_id   = request.args.get('client_id')

    client = get_client(session, client_id)

    if (service is not None) and (element is not None):
        #Get Reservation
        if request.method == 'GET':
            response = element.get_dict()
            session.close()
            return json.dumps(response)

        #Make Reservation
        elif request.method == 'POST' and (client is not None):
            body        = request.json


            if isinstance(body["information"], dict):
                body["information"]= json.dumps(body["information"])

            reservation = create_reservation(session, service, client, element,
                                             body["name"], body["information"],
                                             None, datetime.datetime.now())

            if reservation is not None:
                reservation.url = "/service/%d/client/%d/reservation/%d" % (service.id, client.id, reservation.id)
                session.commit()
                response = reservation.get_dict()
                session.close()
                return jsonify(response)

            else:
                session.close()
                return "RESERVED"

        #Delete element
        delete_element(session, element=element)
        session.close()
        return "DELETED"

    session.close()
    return "ERROR"
