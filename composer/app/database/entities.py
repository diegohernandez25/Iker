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


class Trip(Base):

    __tablename__ = 'trip'

    id                  = Column(Integer, primary_key=True)
    id_domain_booking   = Column(Integer, unique=True)
    id_iptf             = Column(Integer, unique=True)
    id_user             = Column(Integer, ForeignKey('user.id'))

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "id_domain_booking: %s\n" % (self.id_domain_booking) +\
            "          id_iptf: %s\n" % (self.id_iptf) +\
            "          id_user: %s\n" % (self.id_user)

    def get_dict(self):
        return {
            "id"                : self.id,
            "id_domain_booking" : self.id_domain_booking ,
            "id_iptf"  : self.id_iptf,
            "id_user" : self.id_user
        }



class User(Base):
    __tablename__ = 'user'

    id                      = Column(Integer, primary_key=True)
    id_authentication       = Column(Integer, unique=True, nullable=False)
    id_owner_booking        = Column(Integer, unique=True, nullable=False)
    id_client_booking       = Column(Integer, unique=True, nullable=False)
    access_token            = Column(String(15), nullable=False)

    trip        = relationship("Trip", backref="user", cascade="all, delete-orphan")
    reservation = relationship("Reservation", backref="user", cascade="all, delete-orphan")


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
