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

def create_user(session, id_authentication, id_owner_booking, id_client_booking,
                id_aypal, access_token, name, img_url, mail)->User:

    user = User(id_authentication=id_authentication,
                    id_owner_booking=id_owner_booking,
                    id_client_booking=id_client_booking, id_aypal=id_aypal,
                    access_token=access_token, name=name, img_url=img_url,
                    mail=mail)

    session.add(user)
    session.commit()

    return user

def usr_exists(session, id_authentication)->Boolean:

    return session.query(exists().where(User.id_authentication==id_authentication)).scalar()

def valid_usr(session, id_user, access_token)->Boolean:

    return session.query(exists().where(and_(User.id==id_user,User.access_token==access_token))).scalar()


def get_usr(session, id)->User:

    return session.query(User).get(id)

def get_trip(session, id)->Trip:

    return session.query(Trip).get(id)


def create_trip(session, id_domain_booking, id_iptf, city, available, user,
                event)->Trip:

    trip = Trip(id_domain_booking=id_domain_booking, id_iptf=id_iptf, city=city,
                available=available)

    user.trip.append(trip)
    event.trip.append(trip)

    session.add(trip)
    session.commit()

    return trip

def create_event(session, name, description, category, image_url, city, lat,
                    lon, date, sub_city=None)->Event:

    event = Event(name=name, description=description, category=category,
                    image_url=image_url, city=city, sub_city=sub_city,
                    lat=lat, lon=lon, date=date)

    session.add(event)
    session.commit()

    return event

def event_exist(session, id_event)->Boolean:

    return session.query(exists().where(Event.id==id_event)).scalar()

def get_event(session, id)->Event:

    return session.query(Event).get(id)

def get_all_events(session)->list:
    res = list()
    events = session.query(Event)
    for e in events:
        res.append(e.get_dict())

    return res

def get_event_by_name(session, event_name)->list:
    res = list()

    events = session.query(Event).filter(Event.name.like('%' + event_name + '%')).all()
    for e in events:
        res.append(e.get_dict())

    return res

def get_event_by_category(session, category)->list:
    res = list()

    events = session.query(Event).filter(Event.category.like('%' + category + '%')).all()
    for e in events:
        res.append(e.get_dict())

    return res

def get_event_by_city(session, city)->list:
    res = list()

    events = session.query(Event).filter(Event.city.like('%' + city + '%')).all()
    for e in events:
        res.append(e.get_dict())

    return res

def delete_event(session, id=None, event=None):
    if id is not None:
        event = get_event(session, id)

    if event is not None:
        session.delete(event)
        session.commit()


def trip_exists(session,id_iptf)->Boolean:

    return session.query(exists().where(Trip.id_iptf==id_iptf)).scalar()

def trip_exists_id(session, id)->Boolean:

    return session.query(exists().where(Trip.id==id)).scalar()

def owner_exists(session, id_owner)->Boolean:

    return session.query(exists().where(User.id_owner_booking==id_owner)).scalar()

def client_exists(session, id_client)->Boolean:

    return session.query(exists().where(User.id_client_booking==id_client)).scalar()


def get_trip_from_iptf(session, id_iptf)->Trip:

    return session.query(Trip).\
                filter(Trip.id_iptf==id_iptf).\
                options(load_only("id")).\
                one()


def get_usr_by_idclient(session, id_client_booking):
    return session.query(User).\
                filter(User.id_client_booking==id_client_booking).\
                options(load_only("id")).\
                one()

def get_usr_from_ownerid(session, id_iptf)->Trip:
    if trip_exists:
        return session.query(Trip).\
                filter(Trip.id_iptf==id_iptf).\
                options(load_only("id")).\
                one()

    return None


def trip_belongs_usr(session, usr_id, trip_id)->Boolean:

    return session.query(exists().where(and_(Trip.id==trip_id,
                    Trip.id_user==usr_id))).scalar()

def find_event_trips(session, event_id, src_addr)->list:

    res = list()
    if event_exist(session, event_id):
        trips = session.query(Trip).filter(and_(Trip.id_event==event_id,
                    Trip.city.like('%' + src_addr + '%') )).all()
        for t in trips:
            res.append(t.id)

    return res


if __name__ == '__main__':

    from base import Base, engine, Session
    import time

    Base.metadata.create_all(engine)
    session = Session()

    usr = get_usr_by_idclient(session, 6)
    print(usr)
