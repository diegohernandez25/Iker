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

trip_blueprint = Blueprint('trip_view', __name__)

@trip_blueprint.route("/register_trip", methods=['POST'])
def book_trip()->str:
    user_id         = request.args.get('usr_id')
    body            = request.json

    session = Session()

    if set(["EventID","StartTime", "City", "StartCoords","Consumption","AvoidTolls",
            "MaxDetour","FuelType", "name", "information", "Price",
            "NumSeats"]).issubset(set(body.keys())) and\
            usr_exists(session, user_id) and\
            event_exist(session, body["EventID"]):

        event = get_event(session, body["EventID"])
        body["EndCoords"] = [event.lat, event.lon]
        body["StartTime"] += event.date

        r       = requests.post(URL_TRIP_FOLLOWER + "register_trip", json=body)
        id_iptf = r.json()

        user        = get_usr_by_idauth(session, user_id)
        owner_id    = user.id_owner_booking
        url         = URL_RESERVATION + str(BOOKING_SERVICE_ID) +"/owner/"+str(owner_id)+"/domain"
        d_json      = {"name": body["name"], "information": body["information"]}
        r           = requests.post(url, json=d_json)
        id_domain_booking   = r.json()['id']

        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/owner/" +\
                str(owner_id) +"/domain/" + str(id_domain_booking) + "/element"
        elem_bdy = {
            "name"          : body["name"] + "_elem",
            "information"   : body["information"],
            "init_time"     : event.date - body["StartTime"],
            "end_time"      : event.date,
            "price"         : body["Price"]+2.9
        }

        if 'NumSeats' in set(body.keys()):
            for i in range(0,body['NumSeats']):

                elem_bdy["name"] = body["name"] + "_elem" + str(i)

                r = requests.post(url, json=elem_bdy)

        else:
            r = requests.post(url, json=elem_bdy)

        trip = create_trip(session, id_domain_booking, id_iptf, body["City"], True, user, event)
        response = trip.get_dict()
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"


@trip_blueprint.route("/search_trip", methods=['GET'])
def search_trip()->str:
    body    = request.json
    session = Session()

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
            for t in trips:

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
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"



#TODO Delete Trip iptf
#TODO Delete trip composer db
#TODO End Trip Trip Follower
@trip_blueprint.route("/end_trip", methods=['POST'])
def end_trip():
    user_id         = request.args.get('usr_id')
    trip_id         = request.args.get('trip_id')
    session = Session()

    if usr_exists(session, user_id):
        user = get_usr_by_idauth(session, user_id)
        trip = get_trip(session, trip_id)

        if (trip is not None) and trip_belongs_usr(session, user.id, trip_id):
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

@trip_blueprint.route("/probe_trip", methods=['POST'])
def probe_trip()->str:
    body        = request.json
    event_id    = request.args.get('event_id')

    session = Session()
    if set(["StartCoords", "Consumption", "AvoidTolls",
                "MaxDetour", "FuelType"]).issubset(set(body.keys())) and\
                    any(e in body.keys() for e in ["StartTime", "EndTime"]) and\
                        event_id is not None:
        event = get_event(session, event_id)
        if event is not None:
            body["EndCoords"] = [event.lat, event.lon]
            r = requests.post(URL_TRIP_FOLLOWER + "probe_trip", json=body)
            session.close()
            return jsonify(r.json())

    session.close()
    return "ERROR"


@trip_blueprint.route("/get_aval_seats", methods=['GET'])
def get_aval_seats():
    trip_id         = request.args.get('trip_id')

    session = Session()
    if trip_exists_id(session, trip_id):

        trip = get_trip(session, trip_id)
        if trip.available:
            r = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" +\
                    str(trip.id_domain_booking) + "/get_aval_elems")

            r = r.json()
            session.close()
            return jsonify(r)

        session.close()
        return jsonify(list())

    session.close()
    return "ERROR"

@trip_blueprint.route("/reserve_seat", methods=['POST'])
def reserve_seat():
    user_id = request.args.get('usr_id') #Auth id
    trip_id = request.args.get('trip_id')
    body    = request.json

    session = Session()
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
                return "ERROR" #TODO

            session.close()
            return jsonify(res)

        session.close()
        return "TRIP UNAVAILABLE"

    session.close()
    return "ERROR"
