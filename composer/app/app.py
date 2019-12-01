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


BOOKING_SERVICE_NAME = 'carpooling-es-19'
BOOKING_SERVICE_ID = 1


URL_RESERVATION     = "http://localhost:5002/"
URL_TRIP_FOLLOWER   = "http://localhost:8081/"
URL_PAYMENT         = "http://localhost:8080/"
URL_REVIEW          = "http://168.63.30.192:3000/"

IKER_MAIL = "iker@mail.com"


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

session = Session()

@app.route('/')
def index() -> str:
    return "Booking"

@app.route("/test_trip", methods=['POST'])
def test_trip():
	print(requests.post("localhost:8081/probe_trip",data=request.json))

@app.route("/put_trip", methods=['POST'])
def put_trip():
	requests.post("localhost:8081/register_trip",data=request.json)


@app.route("/create_usr", methods=['POST'])
def createUser():
    global BOOKING_SERVICE_ID

    authentication_id = request.args.get('usr_id')

    body        = request.json
    if set(["name", "information"]).issubset(set(body.keys())) and\
        not usr_exists(session, authentication_id):

        b_json  = {"name":body["name"],"information":body["information"]}
        r       = requests.post(URL_RESERVATION + str(BOOKING_SERVICE_ID) +"/owner", json=b_json)
        owner_id = r.json()['id']

        b_json  = {"name":body["name"],"information":body["information"]}
        r       = requests.post(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/client", json=b_json)
        client_id = r.json()['id']

        access_token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(15))

        usr = create_user(session, authentication_id, owner_id, client_id,
                            body["id_aypal"], access_token, body["name"],
                            body["img_url"], body["mail"])

        return json.dumps({"id": usr.id, "access_token":usr.access_token})

    else:
        app.logger.error('Invalid JSON body. "name" or "information" fields may\
            not be explicit.')
        return "ERROR"

@app.route("/register_trip", methods=['POST'])
def book_trip()->str:
    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    body            = request.json

    if set(["EventID", "City", "StartCoords","Consumption","AvoidTolls","StartTime",
            "EndTime","MaxDetour","FuelType", "name", "information", "Price",
            "NumSeats"]).issubset(set(body.keys())) and\
            valid_usr(session, user_id, access_token) and\
            event_exist(session, body["EventID"]):

        event = get_event(session, body["EventID"])
        body["EndCoords"] = [event.lat, event.lon]

        r       = requests.post(URL_TRIP_FOLLOWER + "register_trip", json=body)
        id_iptf = r.json()

        user        = get_usr(session, user_id)
        owner_id    = user.id_owner_booking
        url         = URL_RESERVATION + str(BOOKING_SERVICE_ID) +"/owner/"+str(owner_id)+"/domain"
        d_json      = {"name": body["name"], "information": body["information"]}
        r           = requests.post(url, json=d_json)
        id_domain_booking   = r.json()['id']

        #Create Elements
        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/owner/" +\
                str(owner_id) +"/domain/" + str(id_domain_booking) + "/element"
        elem_bdy = {
            "name"          : body["name"] + "_elem",
            "information"   : body["information"],
            "init_time"     : body["StartTime"],
            "end_time"      : body["EndTime"],
            "price"         : body["Price"]
        }

        if 'NumSeats' in set(body.keys()):
            for i in range(0,body['NumSeats']):

                elem_bdy["name"] = body["name"] + "_elem" + str(i)

                r = requests.post(url, json=elem_bdy)

        else:
            r = requests.post(url, json=elem_bdy)

        #Save trip mapping
        trip = create_trip(session, id_domain_booking, id_iptf, body["City"], True, user, event)

        return json.dumps(trip.get_dict())

    else:
        return "ERROR"

@app.route("/search_trip", methods=['GET'])
def search_trip()->str:
    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    body            = request.json

    if set(["StartCoords", "EndCoords", "StartTime"]).issubset(set(body.keys())) and\
        valid_usr(session, user_id, access_token):
        iptf_bdy = {
            "StartCoords"   : body["StartCoords"],
            "EndCoords"     : body["EndCoords"],
            "StartTime"     : body["StartTime"]
        }
        r = requests.post(URL_TRIP_FOLLOWER + "get_trips", json=iptf_bdy)
        trips = r.json()

        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/"
        res = list()

        for t in trips: #t_iptf
            #GET BOOKING
            if trip_exists(session,t):
                trip = get_trip_from_iptf(session, t)
                r = requests.get(url + str(trip.id_domain_booking))
                r = r.json()
                count_aval = 0

                for e in r["elements"]:
                    count_aval += 1 if not e['reserved'] else 0

                res.append({
                    "id"        : trip.id,
                    "init_time" : epoch_to_date(int(r["elements"][0]["init_time"])),
                    "end_time"  : epoch_to_date(int(r["elements"][0]["end_time"])),
                    "price"     : r["elements"][0]["price"],
                    "aval"      : count_aval
                })

        return json.dumps(res)

    else:
        return "ERROR"

#TODO: Mapeamento de operação para verificar se pagou
#Get specific transaction

@app.route("/remove_trip", methods=['DELETE'])
def remove_trip()->str:


    #TODO: No pagamento:
    #Utilizar CreatePayment
    #TargetID => email COndutor
    #SourceID 0> nosso email

    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    trip_id         = request.args.get('trip_id')
    body            = request.json

    if valid_usr(session, user_id, access_token) and\
        trip_belongs_usr(session, user_id, trip_id):

        trip = get_trip(session, trip_id)

        #DELETE trip @booking
        r = requests.delete(URL_TRIP_FOLLOWER + "del_trip",
                data={"TripId":trip.id_iptf})

        #Delete trip @reservation
        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" + str(trip.id_domain_booking)
        r = requests.delete(url)

        #Delete Trip @composer
        session.delete(trip)
        session.commit()

        return "DELETED"

    return "ERROR"

#TODO:
@app.route("/end_trip", methods=['POST'])
def end_trip():
    global BOOKING_SERVICE_ID
    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    trip_id         = request.args.get('trip_id')

    #Get domain elements
    if valid_usr(session, user_id, access_token) and\
        trip_belongs_usr(session, user_id, trip_id):

        trip = get_trip(session, trip_id)

        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                str(trip.id_domain_booking) + "/get_dom_reservations"

        r = requests.get(url)
        reservations = r.json()

        driver = get_usr(session, user_id)

        token_list = list()

        for res in reservations:
            usr = get_usr_by_idclient(session, res["client_id"])
            payment_info = json.loads(res["information"])
            payment_bdy = {
                "targetID"  : driver.mail,
                "sourceID"  : IKER_MAIL,
                "amount"    : res["price"],
                "briefDescription": "None"
            }

            token_list.append({
                "usr_id"        : usr.id,
                "payment_token" : payment_info["ttoken"],
                "amount"        : res["price"]
                })

            requests.post(URL_PAYMENT + "completePayment", json=payment_bdy)

    return "ERROR"


@app.route("/create_event", methods=['POST'])
def make_event()->str:
    body = request.json

    if set(["Name", "Description", "Category", "ImageUrl", "City", "SubCity",
                "Lat", "Lon", "Date"]).issubset(set(body.keys())):

        event = create_event(session, body["Name"], body["Description"], body["Category"],
                body["ImageUrl"], body["City"], body["Lat"],body["Lon"],
                body["Date"], sub_city=body["SubCity"])

        return json.dumps(event.get_dict())

    return "ERROR"

@app.route("/remove_event", methods=['DELETE'])
def remove_event()->str:

    event_id = request.args.get('event_id')

    if event_exist(session, event_id):
        delete_event(session, id=event_id)
        return "DELETED"

    return "ERROR"

@app.route("/get_event", methods=['GET'])
def find_event()->str:

    event_id = request.args.get('event_id')
    if event_exist(session, event_id):
        event = get_event(session, event_id)
        return json.dumps(event.get_dict())

    return "ERROR"

@app.route("/get_av_trips_event", methods=['GET'])
def find_available_event_trips_api():

    event_id    = request.args.get('event_id')
    event       = get_event(session,event_id)

    if event is not None:
        response = list()

        lat = request.args.get('lat')
        lon = request.args.get('lon')
        body = {
            "StartCoords": [float(lat), float(lon)],
            "EndCoords": [event.lat, event.lon],
            "StartTime": event.date
        }

        r       = requests.post(URL_TRIP_FOLLOWER + "/get_trips", json=body)
        trips   = r.json()
        url_review = URL_REVIEW + "avgRating/"

        for t in trips:

            trip    = get_trip_from_iptf(session, t)
            if trip.available:
                url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" + \
                        str(trip.id_domain_booking) + "/get_aval_elems"

                r = requests.get(url)
                r = r.json()
                price = r[0]["price"]
                
                user    = get_usr(session, trip.id_user)
                r       = requests.get(url_review + user.mail)
                r       = r.json()

                response.append({
                    "id"        : trip.id,
                    "city"      : trip.city,
                    "usr_name"  : user.name,
                    "user_img"  : user.img_url,
                    "mail"      : user.mail,
                    "review"    : (r["avgRating"] if len(r)!=0 else 0),
                    "price"     : price
                    })

        return jsonify(response)

    return "ERROR"

@app.route("/get_events", methods=['GET'])
def get_events()->str:

    event_name      = request.args.get('name')
    event_city      = request.args.get('city')
    event_category  = request.args.get('category')

    events = None

    if event_name is not None:
        events = get_event_by_name(session, event_name)

    if event_city is not None:
        e = get_event_by_city(session, event_city)
        events = e if events is None else list(set(e) & set(events))

    if event_category is not None:
        e = get_event_by_category(session, event_category)
        events = e if events is None else list(set(e) & set(events))

    return repr(events) if events is not None else repr(lst())


@app.route("/get_aval_seats", methods=['GET'])
def get_aval_seats():
    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    trip_id         = request.args.get('trip_id')

    if valid_usr(session, user_id, access_token) and\
        trip_exists_id(session, trip_id):

        trip = get_trip(session, trip_id)
        if trip.available:
            r = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                    str(trip.id_domain_booking) + "/get_aval_elems")

            r = r.json()
            return jsonify(r)

        return jsonify(list())

    return "ERROR"

def epoch_to_date(epoch)->str:
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(epoch))


def create_service():
    global BOOKING_SERVICE_ID

    body = {    'name': 'carpooling-es-19',
                'information':{
                    'authors':['Diego','Andre','Rodrigo','Dinis']
                }
            }
    r = requests.post(URL_RESERVATION + "service", json=body)
    BOOKING_SERVICE_ID = r.json()['id']

def check_service()->Boolean:
    global BOOKING_SERVICE_ID

    r   = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID))

    if (r.text=="ERROR"):
        return False

    return True if (r.json()['name'] == BOOKING_SERVICE_NAME) else False

@app.route("/reserve_seat", methods=['POST'])
def reserve_seat():
    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    access_token    = request.args.get('access_token')
    trip_id         = request.args.get('trip_id')
    element_id      = request.args.get('elem_id')

    body = request.json

    if valid_usr(session, user_id, access_token) and\
        trip_exists_id(session, trip_id) and\
        set(["name", "information"]).issubset(set(body.keys())):

        user = get_usr(session, user_id)
        trip = get_trip(session, trip_id)

        if trip.available:

            #Get element information
            url     = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/element/" + str(element_id)
            r       = requests.get(url)
            r       = r.json()

            if r['reserved']:
                return "RESERVED"

            #Create Delayed Payment
            pay_url = URL_PAYMENT + "/delayedPayment"
            pay_bdy     = {
                "targetID"          : IKER_MAIL,
                "amount"            : r['price'],
                "briefDescription"  : "None"
            }
            r   = requests.post(pay_url, json=body)

            body['information'] = r.json()
            data    = { 'client_id':user.id_client_booking }
            r       = requests.post(url, json=body, params=data)

            if r.text == "RESERVED" or r.text == "ERROR":
                return r.text

            res     = r.json()
            r       = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                        str(trip.id_domain_booking) + "/get_aval_elems")

            if len(r.json()) == 0:
                trip.available = False
                session.commit()

            return jsonify(res)

@app.route("/get_all_events", methods=['GET'])
def get_all_events_api():
    return jsonify(get_all_events(session))


if __name__ == '__main__':
    if not check_service():
        create_service()
    else:
        print("Service was already created")

    Base.metadata.create_all(engine)
    app.run(host='0.0.0.0')
