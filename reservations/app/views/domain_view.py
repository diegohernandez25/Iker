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

domain_blueprint = Blueprint('domain_view', __name__)

@domain_blueprint.route('/<id>/owner/<id_owner>/domain', methods=['POST'])
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

@domain_blueprint.route('/<id>/owner/<id_owner>/domain/<id_domain>', methods=['GET', 'DELETE'])
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

@domain_blueprint.route('/<id>/domain/<id_domain>', methods=['GET', 'DELETE', 'POST'])
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

@domain_blueprint.route('/<id>/domain/<id_domain>/get_aval_elems', methods=['GET'])
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

@domain_blueprint.route('/<id>/domain/<id_domain>/get_dom_reservations', methods=['GET'])
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
