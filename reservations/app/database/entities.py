from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from datetime import date
import time

try:
    from database.base import Base, engine, Session
except:
    from base import Base, engine, Session
    
class Reservation(Base):
    __tablename__ = 'reservation'

    id             = Column(Integer, primary_key=True)
    id_element     = Column(Integer, ForeignKey('element.id'))
    id_client      = Column(Integer, ForeignKey('client.id'))
    name           = Column(String(100), index = True, nullable=False)
    information    = Column(String(1000))
    url            = Column(String(100))
    date           = Column(Date)

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "information: %s\n" % (self.information) +\
            "        url: %s\n" % (self.url) +\
            "       date: %s\n" % (str(self.date))

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name,
            "information"   : self.information,
            "url"           : self.url,
            "date:"         : str(self.date)
        }


class Client(Base):
    __tablename__ = 'client'

    id             = Column(Integer, primary_key=True)
    id_service     = Column(Integer, ForeignKey('service.id'))
    name           = Column(String(100), index = True, nullable=False)
    information    = Column(String(1000))
    url            = Column(String(100))
    date           = Column(Date)
    reservation     = relationship("Reservation", backref="client", cascade="all, delete-orphan")

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "information: %s\n" % (self.information) +\
            "        url: %s\n" % (self.url) +\
            "       date: %s\n" % (str(self.date))

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name,
            "information"   : self.information,
            "url"           : self.url,
            "date:"         : str(self.date)
        }

class Element(Base):
    __tablename__ = 'element'

    id          = Column(Integer, primary_key=True)
    id_domain   = Column(Integer, ForeignKey('domain.id'))
    name        = Column(String(100), index = True, nullable=False)
    information = Column(String(1000))
    url         = Column(String(100))
    date        = Column(Date)
    init_time   = Column(Integer)
    end_time    = Column(Integer)
    price       = Column(Float)
    reserved    = Column(Boolean)

    reservation = relationship("Reservation", backref="element", cascade="all, delete-orphan")

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "information: %s\n" % (self.information) +\
            "        url: %s\n" % (self.url) +\
            "       date: %s\n" % (str(self.date)) +\
            "  init_time: %s\n" % (str(self.init_time)) +\
            "   end_time: %s\n" % (str(self.end_time)) +\
            "      price: %s\n" % (str(self.price)) +\
            "      reserved: " + self.reserved +"\n"

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name,
            "information"   : self.information,
            "url"           : self.url,
            "date:"         : str(self.date),
            "init_time"     : str(self.init_time),
            "end_time"      : str(self.end_time),
            "price"         : self.price,
            "reserved"      : self.reserved
        }

class Domain(Base):
    __tablename__ = 'domain'

    id          = Column(Integer, primary_key=True)

    id_owner    = Column(Integer, ForeignKey('owner.id'))

    name        = Column(String(100), index = True, nullable=False)
    information = Column(String(1000))
    url         = Column(String(100))
    date        = Column(Date)
    element     = relationship("Element", backref="domain", cascade="all, delete-orphan")

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "information: %s\n" % (self.information) +\
            "        url: %s\n" % (self.url) +\
            "       date: %s\n" % (str(self.date))

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name,
            "information"   : self.information,
            "url"           : self.url,
            "date:"         : str(self.date)
        }

class Owner(Base):
    __tablename__ = 'owner'

    id          = Column(Integer, primary_key=True)
    id_service  = Column(Integer, ForeignKey('service.id'))
    name        = Column(String(100), index = True, nullable=False)
    information = Column(String(1000))
    url         = Column(String(100))
    date        = Column(Date)

    domain      = relationship("Domain", backref="owner", cascade="all, delete-orphan")

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "information: %s\n" % (self.information) +\
            "        url: %s\n" % (self.url) +\
            "       date: %s\n" % (str(self.date))

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name,
            "information"   : self.information,
            "url"           : self.url,
            "date:"         : str(self.date)
        }


class Service(Base):
    __tablename__ = 'service'

    id             = Column(Integer, primary_key=True)
    name           = Column(String(100), index = True, nullable=False)
    information    = Column(String(1000))
    url            = Column(String(100))
    date           = Column(Date)

    owner          = relationship("Owner", backref="service", cascade="all, delete-orphan")
    client         = relationship("Client", backref="service", cascade="all, delete-orphan")

    def __str__(self):
        return "         id: %s\n" % (str(self.id)) +\
            "       name: %s\n" % (self.name) +\
            "information: %s\n" % (self.information) +\
            "        url: %s\n" % (self.url) +\
            "       date: %s\n" % (str(self.date))

    def get_dict(self):
        return {
            "id"            : self.id,
            "name"          : self.name,
            "information"   : self.information,
            "url"           : self.url,
            "date:"         : str(self.date)
        }

if __name__ == "__main__":
    from sqlalchemy import create_engine
    from sqlalchemy.ext.declarative import declarative_base
    from sqlalchemy.orm import sessionmaker

    Base.metadata.create_all(engine)
    session = Session()

    tmpservice = Service(name="Hello eeeWorld4",information=None,url="www.tbi.com",
                          date=date(2002, 10, 11))

    #s=session.query(Service).get(1)

    session.add(tmpservice)
    print(tmpservice)
    session.commit()

    owner = Owner(name="userw2w2w21", information="User1", url="www.user1.com",
    date=date(2002,11,10))

    domain = Domain(name="carrow2w2w21", information="Opel", url="www.user1.com",
    date=date(2012,11,10))

    element = Element(name="elementw2w21")
    tmpservice.owner.append(owner)
    owner.domain.append(domain)
    domain.element.append(element)

    session.add(owner)
    session.add(domain)
    session.add(element)

    session.commit()

    session.close()
