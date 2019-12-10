from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from datetime import date

try:
    from database.base import Base, engine, Session
except:
    from base import Base, engine, Session

import time


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
    date        = Column(Integer, nullable=False)

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
            "       date: %s\n" % (epoch_to_date(self.date))

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
            "date"          : epoch_to_date(self.date),
            "date_epoch"    : self.date
        }

class Trip(Base):

    __tablename__ = 'trip'

    id                  = Column(Integer, primary_key=True)
    id_domain_booking   = Column(Integer, unique=True)
    id_iptf             = Column(Integer, unique=True)

    city                = Column(String(200), nullable=True)

    available           = Column(Boolean)

    id_user             = Column(Integer, ForeignKey('user.id'), nullable=False)
    id_event            = Column(Integer, ForeignKey('event.id'), nullable=False)

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "id_domain_booking: %s\n" % (self.id_domain_booking) +\
            "          id_iptf: %s\n" % (self.id_iptf) +\
            "          id_user: %s\n" % (self.id_user) +\
            "         id_event: %s\n" % (self.id_event) +\
            "             city: %s\n" % (self.city) +\
            "        available: %s\n" % (self.available)

    def get_dict(self):
        return {
            "id"                : self.id,
            "id_domain_booking" : self.id_domain_booking ,
            "id_iptf"           : self.id_iptf,
            "id_user"           : self.id_user,
            "id_event"          : self.id_event,
            "city"              : self.city,
            "available"         : self.available
        }

class User(Base):
    __tablename__ = 'user'

    id                      = Column(Integer, primary_key=True)
    id_authentication       = Column(String(50), unique=True, nullable=False)
    id_owner_booking        = Column(Integer, unique=True, nullable=False)
    id_client_booking       = Column(Integer, unique=True, nullable=False)
    access_token            = Column(String(15), nullable=False)

    name    = Column(String(50), nullable=False)
    img_url = Column(String(200), nullable=False)
    mail    = Column(String(50), unique=True, nullable=False)

    trip            = relationship("Trip", backref="user", cascade="all, delete-orphan", lazy='dynamic')
    review_from     = relationship("Review", backref="user", cascade="all, delete-orphan", lazy='dynamic')

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "id_authentication: %s\n" % (self.id_authentication) +\
            " id_owner_booking: %s\n" % (self.id_owner_booking) +\
            "id_client_booking: %s\n" % (self.id_client_booking) +\
            "     access_token: %s\n" % (self.access_token)+\
            "         usr_name: %s\n" % (self.name) +\
            "          img_url: %s\n" % (self.img_url) +\
            "         usr_mail: %s\n" % (self.mail)

    def get_dict(self):
        return {
            "id"                : self.id,
            "id_authentication" : self.id_authentication,
            "id_owner_booking"  : self.id_owner_booking,
            "id_client_booking" : self.id_client_booking,
            "access_token"      : self.access_token,
            "usr_name"          : self.name,
            "img_url"           : self.img_url,
            "usr_mail"          : self.mail
        }

    def get_dict_profile(self):
        return {
            "id"                : self.id,
            "usr_name"          : self.name,
            "img_url"           : self.img_url,
            "usr_mail"          : self.mail
        }

class Review(Base):
    __tablename__ = 'review'

    id          = Column(Integer, primary_key=True)
    id_usr_from = Column(Integer, ForeignKey('user.id'), nullable=False)
    id_usr_to   = Column(Integer, nullable=False)

    def __str__(self):
        return "          id:%s\n" % (str(self.id)) +\
                "id_usr_from:%s\n" % (str(self.id_usr_from)) +\
                "  id_usr_to:%s\n" % (str(self.id_usr_to))

    def get_dict(self):
        return {
            "id"            : self.id,
            "id_usr_from"   : self.id_usr_from,
            "id_usr_to"     : self.id_usr_to
        }

def epoch_to_date(epoch)->str:
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(epoch))
