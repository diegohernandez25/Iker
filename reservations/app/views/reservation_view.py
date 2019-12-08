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

reservation_blueprint = Blueprint('reservation_view', __name__)

@reservation_blueprint.route('/<id>/owner/<id_owner>/domain/<id_domain>/element/<id_element>',
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

@reservation_blueprint.route('/<id>/client/<id_client>/reservation', methods=['GET'])
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

@reservation_blueprint.route('/<id>/client/<id_client>/reservation/<id_reservation>', methods=['GET', 'DELETE', 'PUT'])
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
