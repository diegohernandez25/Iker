from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from datetime import date

try:
    from database.base import Base, engine, Session
except:
    from base import Base, engine, Session

import time

#FIXME : Might not need this.
class Reservation(Base):

    __tablename__ = 'reservation'

    id                  = Column(Integer, primary_key=True)
    id_element_booking  = Column(Integer, unique=True)
    id_iptf             = Column(Integer, unique=True)
    id_user             = Column(Integer, ForeignKey('user.id'))

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "id_element_booking:%s\n" % (self.id_domain_booking) +\
            "          id_iptf: %s\n" % (self.id_iptf) +\
            "          id_user: %s\n" % (self.id_user)

    def get_dict(self):
        return {
            "id"                : self.id,
            "id_domain_booking" : self.id_domain_booking ,
            "id_iptf"  : self.id_iptf,
            "id_user" : self.id_user
        }

class Event(Base):
    __tablename__ = 'event'

    id          = Column(Integer, primary_key=True)
    name        = Column(String(100), nullable=False)
    description = Column(String(1000), nullable=True)
    category    = Column(String(100), nullable=True)
    image_url   = Column(String(200), nullable=True)
    city        = Column(String(200), nullable= False)
    sub_city    = Column(String(200), nullable=True)
    lat         = Column(Float, nullable=False)
    lon         = Column(Float, nullable=False)
    date        = Column(Date, nullable=False)

    trip = relationship("Trip", backref="event", cascade="all, delete-orphan", lazy='dynamic')

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "description: %s\n" % (self.description) +\
            "   category: %s\n" % (self.category) +\
            "  image_url: %s\n" % (self.image_url) +\
            "       city: %s\n" % (self.city) +\
            "   sub_city: %s\n" % (self.sub_city) +\
            "        lat: %s\n" % (str(self.lat)) +\
            "        lon: %s\n" % (str(self.lon)) +\
            "       date: %s\n" % (str(self.date))

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name ,
            "description"   : self.description,
            "category"      : self.category,
            "image_url"     : self.image_url,
            "city"          : self.city,
            "sub_city"      : self.sub_city,
            "lat"           : self.lat,
            "lon"           : self.lon,
            "date"          : str(self.date)
        }

class Trip(Base):

    __tablename__ = 'trip'

    id                  = Column(Integer, primary_key=True)
    id_domain_booking   = Column(Integer, unique=True)
    id_iptf             = Column(Integer, unique=True)

    city                = Column(String(200), nullable=True)

    id_user             = Column(Integer, ForeignKey('user.id'), nullable=False)
    id_event            = Column(Integer, ForeignKey('event.id'), nullable=False)

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "id_domain_booking: %s\n" % (self.id_domain_booking) +\
            "          id_iptf: %s\n" % (self.id_iptf) +\
            "          id_user: %s\n" % (self.id_user) +\
            "         id_event: %s\n" % (self.id_event) +\
            "             city: %s\n" % (self.city)

    def get_dict(self):
        return {
            "id"                : self.id,
            "id_domain_booking" : self.id_domain_booking ,
            "id_iptf"           : self.id_iptf,
            "id_user"           : self.id_user,
            "id_event"          : self.id_event,
            "city"              : self.city
        }



class User(Base):
    __tablename__ = 'user'

    id                      = Column(Integer, primary_key=True)
    id_authentication       = Column(Integer, unique=True, nullable=False)
    id_owner_booking        = Column(Integer, unique=True, nullable=False)
    id_client_booking       = Column(Integer, unique=True, nullable=False)
    id_payment              = Column(Integer, unique=True)
    access_token            = Column(String(15), nullable=False)

    trip        = relationship("Trip", backref="user", cascade="all, delete-orphan", lazy='dynamic')
    reservation = relationship("Reservation", backref="user", cascade="all, delete-orphan", lazy='dynamic')


    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "id_authentication: %s\n" % (self.id_authentication) +\
            " id_owner_booking: %s\n" % (self.id_owner_booking) +\
            "id_client_booking: %s\n" % (self.id_client_booking) +\
            "     access_token: %s\n" % (self.access_token)

    def get_dict(self):
        return {
            "id"                : self.id,
            "id_authentication" : self.id_authentication,
            "id_owner_booking"  : self.id_owner_booking,
            "id_client_booking" : self.id_client_booking,
            "access_token"      : self.access_token
        }
