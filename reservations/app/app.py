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

@app.route('/')
def index() -> str:
    return "Booking"


@app.route('/service', methods=['POST'])
def create_service_api()->str:

    session = Session()
    body = request.json
    service = create_service(session, body['name'], body['information'],None,datetime.datetime.now())
    service.url="/service/%d" % (service.id)
    session.commit()

    response = service.get_dict()
    session.close()

    return json.dumps(response)


@app.route('/<id>', methods=['GET'])
def get_service_api(id):

    session = Session()
    service = get_service(session, id)
    if service is not None:
        response = get_json_service(service)
        session.close()
        return response

    session.close()
    return "ERROR"

@app.route('/<id>/owner', methods=['POST'])
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



@app.route('/<id>/owner/<id_owner>', methods=['GET', 'DELETE'])
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




@app.route('/<id>/owner/<id_owner>/domain', methods=['POST'])
def create_domain_api(id, id_owner)->str:

    body = request.json

    session = Session()
    service = get_service(session,id)
    owner = get_owner(session, id_owner)
    if (service is not None) and (owner is not None) and (owner in service.owner):
            domain = create_domain(session, owner, body['name'],
                                   body['information'],None,
                                   datetime.datetime.now())

            domain.url = "/service/%d/owner/%d/domain/%d" % (service.id, owner.id, domain.id)
            session.commit()
            response = domain.get_dict()
            session.close()
            return json.dumps(response)

    session.close()
    return "ERROR"

@app.route('/<id>/owner/<id_owner>/domain/<id_domain>', methods=['GET', 'DELETE'])
def get_domain_api(id, id_owner, id_domain)->str:

    session = Session()
    service = get_service(session, id)
    owner   = get_owner(session, id_owner)
    domain  = get_domain(session, id_domain)

    if request.method == 'GET':
        if (service is not None) and (owner is not None)\
            and (domain is not None) and (owner in service.owner) \
                and (domain in owner.domain):

            response = get_json_domain(domain)
            session.close()
            return response

        session.close()
        return "ERROR"

    delete_domain(session,domain=domain)
    session.close()
    return "DELETED"



@app.route('/<id>/owner/<id_owner>/domain/<id_domain>/element', methods=['POST'])
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

@app.route('/<id>/owner/<id_owner>/domain/<id_domain>/element/<id_element>',
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



@app.route('/<id>/element/<id_element>', methods=['GET', 'DELETE', 'POST'])
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


@app.route('/<id>/domain/<id_domain>', methods=['GET', 'DELETE', 'POST'])
def get_domain_byid_api(id, id_domain)->str:

    session = Session()
    service = get_service(session, id)
    domain = get_domain(session, id_domain)

    if(service is not None) and (domain is not None):
        if request.method == 'GET':
            response = get_json_domain(domain)
            session.close()
            return response

        #Reserve one of the available elements from domain
        elif request.method == 'POST':
            body = request.json

            elems = get_domain_aval_elements(session, domain=domain)
            if len(elems)!= 0 and\
                set(["name", "information", "client"]).issubset(set(body.keys())):

                #Get Client
                client = get_client(session, body["client"])
                if client is None:
                    session.close()
                    return "ERROR CLIENT"

                #Get Element
                element = get_element(session, elems[0])
                if element is None:
                    session.close()
                    return "ERROR ELEMENT"

                if isinstance(body["information"], dict):
                    body["information"]= json.dumps(body["information"])

                #Create Reservation
                reservation = create_reservation(session, service, client, element,
                                                 body["name"], body["information"],
                                                 None, datetime.datetime.now())

                if reservation is not None:
                    reservation.url = "/service/%d/client/%d/reservation/%d" % (service.id, client.id, reservation.id)
                    session.commit()

                    response            = reservation.get_dict()
                    response["price"]   = element.price

                    session.close()
                    return jsonify(response)

                else:
                    session.close()
                    return "ALREADY RESERVED"

            else:
                session.close()
                return "ERROR"

        #delete domain
        delete_domain(session, domain=domain)
        session.close()
        return "DELETED"


    session.close()
    return "ERROR"

@app.route('/<id>/domain/<id_domain>/get_aval_elems', methods=['GET'])
def get_aval_elems(id, id_domain):
    session = Session()
    service = get_service(session, id)
    domain = get_domain(session, id_domain)

    if(service is not None) and (domain is not None):

        elements = get_domain_aval_elements_w_info(session, domain=domain)
        session.close()
        return jsonify(elements)

    session.close()
    return "ERROR"

@app.route('/<id>/domain/<id_domain>/get_dom_reservations', methods=['GET'])
def get_domain_reservations_api(id, id_domain):
    session = Session()
    service = get_service(session, id)
    domain = get_domain(session, id_domain)

    if (service is not None) and (domain is not None):

        reservations = get_domain_reservations(session, domain=domain)
        session.close()
        return jsonify(reservations)

    session.close()
    return "ERROR"


@app.route('/<id>/client', methods=['POST'])
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

@app.route('/<id>/client/<id_client>', methods=['GET', 'DELETE'])
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

@app.route('/<id>/owner/<id_owner>/domain/<id_domain>/element/<id_element>',
           methods=['POST'])
def create_reservation_api(id, id_owner, id_domain, id_element)->str:

    body    = request.json

    session = Session()
    service = get_service(session,id)
    owner   = get_owner(session, id_owner)
    domain  = get_domain(session, id_domain)
    element = get_element(session, id_element)
    client  = get_client(session, body["id_client"])

    if (element is not None) and (element.reserved == True):
        session.close()
        return "RESERVED"

    if (service is not None) and (owner is not None) and (domain is not None)\
        and (owner in service.owner) and (domain in owner.domain)\
         and (client is not None) and (element in domain.element)\
            and (client in service.client) and (element.reserved ==False):

         reservation = create_reservation(session, service, client, element,
                                          body["name"], body["information"],
                                          None, datetime.datetime.now())

         reservation.url = "/service/%d/client/%d/reservation/%d" % (service.id, client.id, reservation.id)
         session.commit()

         response = reservation.get_dict()
         session.close()
         return json.dumps(response)

    session.close()
    return "ERROR"

@app.route('/<id>/client/<id_client>/reservation', methods=['GET'])
def get_client_reservations_api(id, id_client):
    session = Session()
    service = get_service(session, id)
    client  = get_client(session, id_client)

    if (service is not None) and (client is not None) and\
        (client in service.client):

        response = get_client_reservations(session, client=client)
        session.close()
        return jsonify(response)

    session.close()
    return "ERROR"

@app.route('/<id>/client/<id_client>/reservation/<id_reservation>', methods=['GET', 'DELETE', 'PUT'])
def get_reservation_api(id, id_client, id_reservation)->str:

    session     = Session()
    service     = get_service(session, id)
    client      = get_client(session, id_client)
    reservation = get_reservation(session, id_reservation)

    if (service is not None) and (client is not None)\
        and (reservation is not None) and (client in service.client)\
            and (reservation in client.reservation):

            #Get Reservation
            if request.method == 'GET':
                response = reservation.get_dict()
                session.close()
                return json.dumps(response)

            #Update Information
            elif request.method == 'PUT':
                body = request.json

                if "information" in body.keys():

                    if isinstance(body["information"], dict):
                        body["information"]= json.dumps(body["information"])

                    reservation.information = body["information"]
                    session.commit()
                    response = reservation.get_dict()
                    session.close()

                    return jsonify(response)

            #Delete reservation
            delete_reservation(session, reservation=reservation)
            session.close()
            return "DELETED"

    session.close()
    return "ERROR"


if __name__ == '__main__':
    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0', port=5002)
