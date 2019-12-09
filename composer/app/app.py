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
from views.usr_view import usr_blueprint
from views.event_view import event_blueprint
from views.trip_view import trip_blueprint
from views.review_view import review_blueprint

logging.basicConfig(level=logging.DEBUG)

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
app.register_blueprint(usr_blueprint)
app.register_blueprint(event_blueprint)
app.register_blueprint(trip_blueprint)
app.register_blueprint(review_blueprint)

#TODO Delete Trip iptf
#TODO Delete trip composer db
@app.route("/end_trip", methods=['POST'])
def end_trip():
    user_id         = request.args.get('usr_id')
    trip_id         = request.args.get('trip_id')
    app.logger.info('END_TRIP')
    app.logger.info('user_id:\t'+ str(user_id))
    app.logger.info('trip_id:\t'+ str(trip_id))

    session = Session()

    if usr_exists(session, user_id):
        user = get_usr_by_idauth(session, user_id)
        trip = get_trip(session, trip_id)
        app.logger.info('trip:\t'+ repr(trip))
        app.logger.info('user:\t'+ repr(user))
        app.logger.info('trip_belongs_usr:\t'+ repr(trip_belongs_usr(session, user.id, int(trip_id))))

        if (trip is not None) and trip_belongs_usr(session, user.id, int(trip_id)):
            url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                    str(trip.id_domain_booking) + "/get_dom_reservations"

            r = requests.get(url)
            reservations = r.json()
            token_list = list()

            #End Trip Trip Follower
            requests.post(URL_TRIP_FOLLOWER + "/end_trip", params={'TripId':trip.id_iptf})

            for res in reservations:
                usr_client = get_usr_by_idclient(session, res["client_id"])
                payment_info = json.loads(res["information"])
                payment_bdy = {
                    "targetID"  : user.mail,
                    "sourceID"  : IKER_MAIL,
                    "amount"    : res["price"],
                    "briefDescription": "None"
                }

                token_list.append({
                    "usr_id"        : usr_client.id,
                    "payment_token" : payment_info["ttoken"],
                    "amount"        : res["price"]
                    })

                requests.post(URL_PAYMENT + "completePayment", json=payment_bdy)

                create_review(session, usr_client, user)

            session.close()
            return jsonify(token_list)

    session.close()
    return "ERROR"

def check_service()->Boolean:
    global BOOKING_SERVICE_ID

    r   = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID))

    if (r.text=="ERROR"):
        return False

    return True if (r.json()['name'] == BOOKING_SERVICE_NAME) else False


def create_service():
    global BOOKING_SERVICE_ID

    body = {    'name': 'carpooling-es-19',
                'information':{
                    'authors':['Diego','Andre','Rodrigo','Dinis']
                }
            }
    r = requests.post(URL_RESERVATION + "service", json=body)
    BOOKING_SERVICE_ID = r.json()['id']


if __name__ == '__main__':
    if not check_service():
        create_service()
    else:
        app.logger.info("Service was already created")

    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0')
