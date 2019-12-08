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

from flask import Blueprint, render_template

usr_blueprint = Blueprint('usr_view', __name__)

@usr_blueprint.route("/create_usr", methods=['POST'])
def createUser():

    authentication_id = request.args.get('usr_id')
    body = request.json
    session = Session()

    if usr_exists(session, authentication_id):
        session.close()
        return "LOGGED IN"

    elif set(["name", "information"]).issubset(set(body.keys())):

        b_json  = {"name":body["name"],"information":body["information"]}
        r       = requests.post(URL_RESERVATION + str(BOOKING_SERVICE_ID) +"/owner", json=b_json)
        owner_id = r.json()['id']

        b_json  = {"name":body["name"],"information":body["information"]}
        r       = requests.post(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/client", json=b_json)
        client_id = r.json()['id']

        access_token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(15))

        usr = create_user(session, authentication_id, owner_id, client_id,
                            access_token, body["name"],body["img_url"],
                            body["mail"])

        response = {"id": usr.id, "access_token":usr.access_token}
        session.close()
        return json.dumps(response)


    session.close()
    return "ERROR"

@usr_blueprint.route("/get_usr_profile", methods=['GET'])
def get_usr_profile_api():
    usr_mail    = request.args.get('usr_mail')

    session     = Session()
    usr         = get_usr_from_mail(session, usr_mail)
    if usr is not None:

        response = usr.get_dict_profile()
        r = requests.get(URL_REVIEW + "review", data={'reviewdObjectID': usr.mail})
        r = r.json()
        for e in r:
            mail = e['authorID']
            tmp_usr = get_usr_from_mail(session, mail)
            if tmp_usr is not None:
                e['img_url'] = tmp_usr.img_url

        response["reviews"] = r

        r = requests.get(URL_REVIEW + "avgRating/" + usr.mail)
        r = r.json()
        if "avgRating" in r.keys():
            response["avgRating"] = r["avgRating"]
        else:
            response["avgRating"] = 0

        session.close()
        return jsonify(response)

    session.close()
    return "ERROR"

@usr_blueprint.route("/get_my_trips", methods=['GET'])
def get_my_trips_api():
    session = Session()

    user_id = request.args.get('usr_id')

    if usr_exists(session, user_id):
        response = list()
        usr     = get_usr_by_idauth(session, user_id)
        trips   = get_usr_trips(session, usr.id)

        for t in trips:
            tmp = t.get_dict()

            event = get_event(session, t.id_event)
            tmp['eventName'] = event.name
            tmp['eventImg'] = event.image_url

            r   = requests.get(URL_TRIP_FOLLOWER + "get_trip", params={"TripId":t.id_iptf})
            r   = r.json()

            tmp["trip"] = r
            response.append(tmp)

        session.close()
        return jsonify(response)

    session.close()
    return "ERROR"

@usr_blueprint.route("/get_my_reservations", methods=['GET'])
def list_my_reservations_api():
    session = Session()
    user_id = request.args.get('usr_id')

    if usr_exists(session, user_id):
        user = get_usr_by_idauth(session, user_id)
        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/client/" + str(user.id_client_booking) + "/reservation"
        r   = requests.get(url)
        r_list  = r.json()

        response = list()
        for e in r_list:
            trip = get_trip_by_domainid(session, e["id_domain"])
            if trip is not None:
                elem    = dict()
                event   = get_event(session, trip.id_event)
                driver  = get_usr(session, trip.id_user)
                elem['event']   = event.get_dict()
                elem['driver']  = driver.get_dict_profile()
                elem['trip']    = e
                response.append(elem)

        session.close()
        return jsonify(response)

    session.close()
    return "ERROR"

@usr_blueprint.route("/list_pending_reviews", methods=['GET'])
def list_pending_reviews_api():
    session = Session()

    user_id = request.args.get('usr_id')
    if usr_exists(session, user_id):
        user        = get_usr_by_idauth(session, user_id)
        response    = [ get_usr(session,e.id_usr_to).get_dict_profile() for e in list_reviews(session, user)]
        session.close()
        return jsonify(response)

    session.close()
    return "ERROR"
