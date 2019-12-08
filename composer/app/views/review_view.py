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

review_blueprint = Blueprint('review_view', __name__)

@review_blueprint.route("/create_review", methods=['POST'])
def create_review_api():
    session = Session()
    user_id = request.args.get('usr_id')
    body = request.json

    if usr_exists(session, user_id) and\
        set(["rating", "reviewText", "reviewdObjectID"]).issubset(set(body.keys())):

        usr = get_usr_by_idauth(session, user_id)
        usr_to = get_usr_from_mail(session, body["reviewdObjectID"])
        review = None

        if usr_to is None or not review_to_usr_exist(session, usr, usr_to.id):
            session.close()
            return "ERROR"

        if not "reviewID" in body.keys():
            review = get_review_by_usrs(session, usr, usr_to.id)
        else:
            review = get_review(session,body["reviewID"])

        if review is not None and\
            review_detail_exist(session, usr, usr_to, review.id):
            body["authorID"] = usr.mail
            r = requests.post(URL_REVIEW + "review", json=body)
            delete_review(session, id=review.id)
            session.close()
            return "OK"

    session.close()
    return "ERROR"
