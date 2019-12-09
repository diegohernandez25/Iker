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
                access_token, name, img_url, mail)->User:

    user = User(id_authentication=id_authentication,
                    id_owner_booking=id_owner_booking,
                    id_client_booking=id_client_booking,
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

def get_trip_by_domainid(session, id_domain_booking)->Trip:

    return session.query(Trip).\
                filter(Trip.id_domain_booking == id_domain_booking).\
                options(load_only("id")).\
                one()


def create_trip(session, id_domain_booking, id_iptf, city, available, user,
                event)->Trip:

    trip = Trip(id_domain_booking=id_domain_booking, id_iptf=id_iptf, city=city,
                available=available)

    user.trip.append(trip)
    event.trip.append(trip)

    session.add(trip)
    session.commit()

    return trip

def delete_trip(session, id=None, trip=None):
    if id is not None:
        trip = get_trip(session, id)

    if trip is not None:
        session.delete(trip)
        session.commit()


def create_review(session, user_from, user_to)->Review:
    review = None

    review = Review(id_usr_to = user_to.id)
    user_from.review_from.append(review)

    session.add(review)
    session.commit()

    return review

def get_review(session, id)->Review:

    return session.query(Review).get(id)

def delete_review(session, id=None, review=None):
    if id is not None:
        review = get_review(session, id)

    if review is not None:
        session.delete(review)
        session.commit()

def list_reviews(session, user) -> list:
    res = list()
    if user is not None:
        res = [e for e in user.review_from]
    return res

def review_to_usr_exist(session, user, user_to_id) -> Boolean:

    return session.query(exists().where(
                and_(Review.id_usr_from==user.id,
                    Review.id_usr_to==user_to_id))).scalar()

def review_detail_exist(session, user, user_to, review_id)->Boolean:

    return session.query(exists().where(
                and_(Review.id_usr_from==user.id,
                    Review.id_usr_to==user_to.id,
                    Review.id == review_id))).scalar()

def get_review_by_usrs(session, user, user_to_id)->Review:
    res = list()

    review = session.query(Review).filter(and_(Review.id_usr_from==user.id,
                Review.id_usr_to==user_to_id)).options(load_only("id")).\
                all()

    return review[0]



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

def get_usr_by_idauth(session, id_authentication):
    return session.query(User).\
                filter(User.id_authentication==id_authentication).\
                options(load_only("id")).\
                one()


def get_usr_by_idclient(session, id_client_booking):
    return session.query(User).\
                filter(User.id_client_booking==id_client_booking).\
                options(load_only("id")).\
                one()

def get_usr_from_ownerid(session, id_iptf)->Trip:
    return session.query(Trip).\
                filter(Trip.id_iptf==id_iptf).\
                options(load_only("id")).\
                one()


def get_usr_from_mail(session, mail)->User:
    return session.query(User).\
            filter(User.mail==mail).\
            options(load_only("id")).\
            one()

def trip_belongs_usr(session, usr_id, trip_id)->Boolean:

    return session.query(exists().where(and_(Trip.id==trip_id,
                    Trip.id_user==usr_id))).scalar()

def find_event_trips(session, event_id, src_addr)->list:

    res = list()
    if event_exist(session, event_id):
        trips = session.query(Trip).filter(and_(Trip.id_event==event_id,
                    Trip.city.like('%' + src_addr + '%'))).all()
        for t in trips:
            res.append(t.id)
    return res

def get_usr_trips(session, usr_id)->list:

    res = list()
    usr = get_usr(session, usr_id)
    if usr is not None:
        res = [e for e in usr.trip]

    return res

def find_available_event_trips(session, event_id, src_addr)->list:

    res = list()
    if event_exist(session, event_id):
        trips = session.query(Trip).filter(and_(Trip.id_event==event_id,
                    Trip.city.like('%' + src_addr + '%'),
                    Trip.available==True)).all()
        for t in trips:
            user = get_usr(session, t.id_user)
            res.append({
                "id"        : t.id,
                "city"      : t.city,
                "usr_name"  : user.name,
                "user_img"  : user.img_url,
                "mail"      : user.mail
            })

    return res

if __name__ == '__main__':

    from base import Base, engine, Session
    import time

    Base.metadata.create_all(engine)
    session = Session()
    usr = get_usr_by_idauth(session, 15)
    usr_to = get_usr_from_mail(session, "diego2")


    review = get_review_by_usrs(session, usr, usr_to.id)
    print(review)

    session.close()
