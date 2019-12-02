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

#TODO: Add configuration file.
BOOKING_SERVICE_NAME = 'carpooling-es-19'
BOOKING_SERVICE_ID = 1


URL_RESERVATION     = "http://localhost:5002/"
URL_TRIP_FOLLOWER   = "http://localhost:8081/"
URL_PAYMENT         = "http://localhost:8080/"
URL_REVIEW          = "http://168.63.30.192:3000/"

IKER_MAIL = "accounting@iker.pt"


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

@app.route("/create_usr", methods=['POST'])
def createUser():
    global BOOKING_SERVICE_ID

    authentication_id = request.args.get('usr_id')

    body = request.json

    if usr_exists(session, authentication_id):
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

        return json.dumps({"id": usr.id, "access_token":usr.access_token})

    else:
        app.logger.error('Invalid JSON body. "name" or "information" fields may\
            not be explicit.')
        return "ERROR"

@app.route("/register_trip", methods=['POST'])
def book_trip()->str:
    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    body            = request.json

    if set(["EventID", "City", "StartCoords","Consumption","AvoidTolls","StartTime",
            "EndTime","MaxDetour","FuelType", "name", "information", "Price",
            "NumSeats"]).issubset(set(body.keys())) and\
            usr_exists(session, user_id) and\
            event_exist(session, body["EventID"]):

        event = get_event(session, body["EventID"])
        body["EndCoords"] = [event.lat, event.lon]

        r       = requests.post(URL_TRIP_FOLLOWER + "register_trip", json=body)
        id_iptf = r.json()

        #user        = get_usr(session, user_id)
        user        = get_usr_by_idauth(session, user_id)
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

    body            = request.json

    if set(["StartCoords", "EndCoords", "StartTime"]).issubset(set(body.keys())):

        iptf_bdy = {
            "StartCoords"   : body["StartCoords"],
            "EndCoords"     : body["EndCoords"],
            "StartTime"     : body["StartTime"]
        }
        r = requests.post(URL_TRIP_FOLLOWER + "get_trips", json=iptf_bdy)
        response = list()
        if r.text != '':
            trips = r.json()

            url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/"


            for t in trips: #t_iptf

                if trip_exists(session,t):
                    trip = get_trip_from_iptf(session, t)
                    r = requests.get(url + str(trip.id_domain_booking))
                    r = r.json()
                    count_aval = 0

                    for e in r["elements"]:
                        count_aval += 1 if not e['reserved'] else 0

                    response.append({
                        "id"        : trip.id,
                        "init_time" : epoch_to_date(int(r["elements"][0]["init_time"])),
                        "end_time"  : epoch_to_date(int(r["elements"][0]["end_time"])),
                        "price"     : r["elements"][0]["price"],
                        "aval"      : count_aval
                    })

        return json.dumps(response)
    return "ERROR"

@app.route("/end_trip", methods=['POST'])
def end_trip():
    global BOOKING_SERVICE_ID

    user_id         = request.args.get('usr_id')
    trip_id         = request.args.get('trip_id')

    if usr_exists(session, user_id):
        user = get_usr_by_idauth(session, user_id)
        trip = get_trip(session, trip_id)

        if (trip is not None) and trip_belongs_usr(session, user.id, trip_id):
            url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                    str(trip.id_domain_booking) + "/get_dom_reservations"

            r = requests.get(url)
            reservations = r.json()
            token_list = list()

            for res in reservations:
                usr = get_usr_by_idclient(session, res["client_id"])
                payment_info = json.loads(res["information"])
                payment_bdy = {
                    "targetID"  : user.mail,
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
                #Return list of tokens
                return jsonify(token_list)

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
        if r.text != '':
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
                        "usr_id"    : user.id,
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

    trip_id         = request.args.get('trip_id')

    if trip_exists_id(session, trip_id):

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

    user_id = request.args.get('usr_id') #Auth id
    trip_id = request.args.get('trip_id')
    body    = request.json

    if usr_exists(session, user_id) and\
        trip_exists_id(session, trip_id) and\
        set(["name", "information", "lat", "lon"]).issubset(set(body.keys())):

        user = get_usr_by_idauth(session, user_id)
        trip = get_trip(session, trip_id)

        if trip.available:

            #Make reservation.
            url     = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" + str(trip.id_domain_booking)
            res_body = {
                "client":user.id_client_booking,
                "name":"reservation_from_"+user.name,
                "information": "none"
            }
            r = requests.post(url,json=res_body)
            r = r.json()
            #Saves reservation Id
            res_id = r["id"]

            #Create Delayed Payment
            pay_url = URL_PAYMENT + "/delayedPayment"
            pay_bdy     = {
                "targetID"          : IKER_MAIL,
                "amount"            : r['price'],
                "briefDescription"  : "None"
            }
            r   = requests.post(pay_url, json=pay_bdy)
            pay_response = r.json()

            url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/client/" +\
                    str(user.id_client_booking) + "/reservation/" + str(res_id)

            #Updates reservation and gets final reservation info.
            r = requests.put(url,json={"information":pay_response})
            res     = r.json()
            res["token"] = pay_response["ttoken"]

            #Analyses available elements and updates number of elements avaiable
            r       = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                        str(trip.id_domain_booking) + "/get_aval_elems")

            if len(r.json()) == 0:
                trip.available = False
                session.commit()

            #Add sub-trip.
            event = get_event(session, trip.id_event)

            subtrip_bdy = {
                "StartCoords"   : [body["lat"], body["lon"]],
                "EndCoords"     : [event.lat, event.lon],
                "TripId"        : trip.id_iptf
            }

            r = requests.post(URL_TRIP_FOLLOWER + "add_subtrip",
                                json=subtrip_bdy)

            if r.status_code != 200:
                app.logger.error("Could't add subtrip.")

            return jsonify(res)

        return "TRIP UNAVAILABLE"
    return "ERROR"

@app.route("/get_usr_profile", methods=['GET'])
def get_usr_profile_api():

    usr_mail    = request.args.get('usr_mail')
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

        #get Avg Review of user.
        url = URL_REVIEW + "/avgRating/" + usr.mail
        r = requests.get(URL_REVIEW + "/avgRating/" + usr.mail)
        r = r.json()
        response["avgRating"] = r["avgRating"]
        
        return jsonify(response)

    return "ERROR"

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
