from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, create_engine, and_
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker, load_only
from sqlalchemy.sql import exists

from datetime import date
import datetime
import time

try:
    from database.entities import *
except:
    from entities import *

#TODO. Think about the erros and try exceptions placements

def create_user(session, id_authentication, id_owner_booking, id_client_booking, access_token)->User:

    user = User(id_authentication=id_authentication,
                    id_owner_booking=id_owner_booking,
                    id_client_booking=id_client_booking,
                    access_token=access_token)

    session.add(user)
    session.commit()

    return user

def usr_exists(session, id_authentication)->Boolean:

    return session.query(exists().where(User.id_authentication==id_authentication)).scalar()

def valid_usr(session, id_user, access_token)->Boolean:

    return session.query(exists().where(and_(User.id==id_user,User.access_token==access_token))).scalar()


def get_usr(session, id)->User:

    return session.query(User).get(id)


def create_trip(session, id_domain_booking, id_iptf, id_user)->Trip:

    trip = Trip(id_domain_booking=id_domain_booking, id_iptf=id_iptf,
                    id_user=id_user)

    session.add(trip)
    session.commit()

    return trip

def trip_exists(session,id_iptf)->Boolean:

    return session.query(exists().where(Trip.id_iptf==id_iptf)).scalar()

def owner_exists(session, id_owner)->Boolean:

    return session.query(exists().where(User.id_owner_booking==id_owner)).scalar()

def client_exists(session, id_client)->Boolean:

    return session.query(exists().where(User.id_client_booking==id_client)).scalar()


def get_trip_from_iptf(session, id_iptf)->Trip:
    if trip_exists:
        return session.query(Trip).\
                filter(Trip.id_iptf==id_iptf).\
                options(load_only("id")).\
                one()

    return None

def get_usr_from_ownerid(session, id_iptf)->Trip:
    if trip_exists:
        return session.query(Trip).\
                filter(Trip.id_iptf==id_iptf).\
                options(load_only("id")).\
                one()

    return None

if __name__ == '__main__':

    from base import Base, engine, Session
    import time

    Base.metadata.create_all(engine)
    session = Session()

    #Check if user exist
    #usr_exists(session, 12347)

    #Valid usr:
    #print(valid_usr(session, 5, "J94M132H9VN91IW"))

    #Create Trip
    #create_trip(session,-2,-4,1)

    #Get trip by iptf_id
    #trip = get_trip_from_iptf(session,178)
    #print(trip)
