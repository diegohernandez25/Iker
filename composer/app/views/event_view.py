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

event_blueprint = Blueprint('event_view', __name__)


@event_blueprint.route("/create_event", methods=['POST'])
def make_event()->str:
    body = request.json

    session = Session()
    if set(["Name", "Description", "Category", "ImageUrl", "City", "SubCity",
                "Lat", "Lon", "Date"]).issubset(set(body.keys())):

        event = create_event(session, body["Name"], body["Description"], body["Category"],
                body["ImageUrl"], body["City"], body["Lat"],body["Lon"],
                body["Date"], sub_city=body["SubCity"])

        response = event.get_dict()
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"

@event_blueprint.route("/remove_event", methods=['DELETE'])
def remove_event()->str:

    event_id = request.args.get('event_id')

    session = Session()
    if event_exist(session, event_id):
        delete_event(session, id=event_id)
        session.close()
        return "DELETED"

    session.close()
    return "ERROR"

@event_blueprint.route("/get_event", methods=['GET'])
def find_event()->str:
    session = Session()
    event_id = request.args.get('event_id')
    if event_exist(session, event_id):
        event = get_event(session, event_id)
        response = event.get_dict()
        session.close()
        return json.dumps(response)

    session.close()
    return "ERROR"

@event_blueprint.route("/get_events", methods=['GET'])
def get_events()->str:

    event_name      = request.args.get('name')
    event_city      = request.args.get('city')
    event_category  = request.args.get('category')

    events = None

    session = Session()
    if event_name is not None:
        events = get_event_by_name(session, event_name)

    if event_city is not None:
        e = get_event_by_city(session, event_city)
        events = e if events is None else list(set(e) & set(events))

    if event_category is not None:
        e = get_event_by_category(session, event_category)
        events = e if events is None else list(set(e) & set(events))

    session.close()
    return repr(events) if events is not None else repr(lst())

@event_blueprint.route("/get_all_events", methods=['GET'])
def get_all_events_api():
    session = Session()
    response = get_all_events(session)
    session.close()

    return jsonify(response)

@event_blueprint.route("/get_av_trips_event", methods=['GET'])
def find_available_event_trips_api():

    event_id    = request.args.get('event_id')
    session     = Session()
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

        r = requests.post(URL_TRIP_FOLLOWER + "/get_trips", json=body)
        if r.text != '':
            trips = r.json()
            url_review = URL_REVIEW + "avgRating/"

            for t in trips:
                if trip_exists(session,t):
                    trip    = get_trip_from_iptf(session, t)

                    if trip.available and trip.id_event == int(event_id):
                        url = URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" + \
                                str(trip.id_domain_booking) + "/get_aval_elems"

                        r = requests.get(url)
                        r = r.json()
                        price = r[0]["price"]

                        user    = get_usr(session, trip.id_user)
                        r       = requests.get(url_review + user.mail)
                        r       = r.json()


                        r_booking = requests.get(URL_RESERVATION + str(BOOKING_SERVICE_ID) + "/domain/" + str(trip.id_domain_booking))
                        r_booking = r_booking.json()

                        if "elements" in r_booking.keys() and len(r_booking["elements"])>0:

                            response.append({
                                "id"        : trip.id,
                                "city"      : trip.city,
                                "usr_id"    : user.id,
                                "usr_name"  : user.name,
                                "user_img"  : user.img_url,
                                "mail"      : user.mail,
                                "review"    : (r["avgRating"] if len(r)!=0 else 0),
                                "price"     : price,
                                "hour"      : int(r_booking["elements"][0]["init_time"]) - event.date
                                })

        session.close()
        return jsonify(response)

    session.close()
    return "ERROR"
