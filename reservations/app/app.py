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


@app.route('/service', methods=['POST'])
def create_service_api()->str:

    body = request.json
    service = create_service(session, body['name'], body['information'],None,datetime.datetime.now())
    service.url="/service/%d" % (service.id)
    session.commit()

    return json.dumps(service.get_dict())


@app.route('/<id>', methods=['GET'])
def get_service_api(id)->str():

    service = get_service(session, id)
    if service is not None:
        return get_json_service(service)

    return "ERROR"

@app.route('/<id>/owner', methods=['POST'])
def create_owner_api(id)->str:

    body = request.json

    service = get_service(session, id)
    if service is not None:
        owner = create_owner(session, service, body['name'], body['information'],None,datetime.datetime.now())
        owner.url="/service/%d/owner/%d" % (service.id,owner.id)
        session.commit()

        return json.dumps(owner.get_dict())

    return "ERROR"

@app.route('/<id>/owner/<id_owner>', methods=['GET'])
def get_owner_api(id, id_owner)->str:

    service = get_service(session, id)
    owner = get_owner(session, id_owner)

    if (service is not None) and (owner is not None) and (owner in service.owner):

        return get_json_owner(owner)

    return "ERROR"



@app.route('/<id>/owner/<id_owner>/domain', methods=['POST'])
def create_domain_api(id, id_owner)->str:

    body = request.json

    service = get_service(session,id)
    owner = get_owner(session, id_owner)
    if (service is not None) and (owner is not None) and (owner in service.owner):
            domain = create_domain(session, owner, body['name'],
                                   body['information'],None,
                                   datetime.datetime.now())

            domain.url = "/service/%d/owner/%d/domain/%d" % (service.id, owner.id, domain.id)
            session.commit()
            return json.dumps(domain.get_dict())

    return "ERROR"

@app.route('/<id>/owner/<id_owner>/domain/<id_domain>', methods=['GET'])
def get_domain_api(id, id_owner, id_domain)->str:

    service = get_service(session, id)
    owner   = get_owner(session, id_owner)
    domain  = get_domain(session, id_domain)

    if (service is not None) and (owner is not None)\
        and (domain is not None) and (owner in service.owner) \
            and (domain in owner.domain):

        return get_json_domain(domain)

    return "ERROR"


@app.route('/<id>/owner/<id_owner>/domain/<id_domain>/element', methods=['POST'])
def create_element_api(id, id_owner, id_domain)->str:

    body = request.json

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
        return json.dumps(element.get_dict())

    return "ERROR"

@app.route('/<id>/owner/<id_owner>/domain/<id_domain>/element/<id_element>',
           methods=['GET'])
def get_element_api(id, id_owner, id_domain, id_element)->str:

    service = get_service(session, id)
    owner   = get_owner(session, id_owner)
    domain  = get_domain(session, id_domain)
    element = get_element(session, id_element)

    if (service is not None) and (owner is not None) \
        and (domain is not None) and (element is not None)\
         and (owner in service.owner) and (domain in owner.domain)\
          and (element in domain.element):

        return json.dumps(element.get_dict())

    return "ERROR"


@app.route('/<id>/element/<id_element>', methods=['GET'])
def get_element_byid_api(id, id_element)->str:
    service = get_service(session, id)
    element = get_element(session, id_element)

    if(service is not None) and (element is not None):
        return json.dumps(element.get_dict())

    return "ERROR"

@app.route('/<id>/domain/<id_domain>', methods=['GET'])
def get_domain_byid_api(id, id_domain)->str:
    service = get_service(session, id)
    domain = get_domain(session, id_domain)

    if(service is not None) and (domain is not None):
        return get_json_domain(domain)

    return "ERROR"


@app.route('/<id>/client', methods=['POST'])
def create_client_api(id)->str:

    body = request.json

    service = get_service(session, id)
    if service is not None:
        client = create_client(session, service, body['name'], body['information'],None,datetime.datetime.now())
        client.url="/service/%d/client/%d" % (service.id,client.id)
        session.commit()
        return json.dumps(client.get_dict())

    return "ERROR"

@app.route('/<id>/client/<id_client>', methods=['GET'])
def get_client_api(id, id_client)->str:

    service = get_service(session, id)
    client = get_client(session, id_client)

    if (service is not None) and (client is not None)\
        and (client in service.client):

        return get_json_client(client)

    return "ERROR"

@app.route('/<id>/owner/<id_owner>/domain/<id_domain>/element/<id_element>',
           methods=['POST'])
def create_reservation_api(id, id_owner, id_domain, id_element)->str:

    body    = request.json
    service = get_service(session,id)
    owner   = get_owner(session, id_owner)
    domain  = get_domain(session, id_domain)
    element = get_element(session, id_element)
    client  = get_client(session, body["id_client"])

    if (element is not None) and (element.reserved == True):
        return "RESERVED"

    if (service is not None) and (owner is not None) and (domain is not None)\
        and (owner in service.owner) and (domain in owner.domain)\
         and (client is not None) and (element in domain.element)\
            and (client in service.client) and (element.reserved ==False):

         element.reserved = True
         reservation = create_reservation(session, client, element,
                                          body["name"], body["information"],
                                          None, datetime.datetime.now())

         reservation.url = "/service/%d/client/%d/reservation/%d" % (service.id, client.id, reservation.id)
         client.reservation.append(reservation)
         element.reservation.append(reservation)
         session.commit()
         return json.dumps(reservation.get_dict())


    return "ERROR"

@app.route('/<id>/client/<id_client>/reservation/<id_reservation>', methods=['GET'])
def get_reservation_api(id, id_client, id_reservation)->str:

    service     = get_service(session, id)
    client      = get_client(session, id_client)
    reservation = get_reservation(session, id_reservation)

    if (service is not None) and (client is not None)\
        and (reservation is not None) and (client in service.owner)\
            and (reservation in client.reservation):

            return json.dumps(reservation.get_dict())

    return "ERROR"

if __name__ == '__main__':
    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0', port=5002)
