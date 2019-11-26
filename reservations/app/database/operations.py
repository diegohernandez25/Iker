from sqlalchemy import Column, String, Integer, Date, Float, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

from datetime import date
import datetime
import time

from database.entities import *


def create_service(session, name, information, url, date)->Service:

    service = Service(name=name, information=information, url=url, date=date)
    session.add(service)
    session.commit()

    return service

def get_service(session, id)->Service:

    return session.query(Service).get(id)

def delete_service(session, id=None, service=None):

    if id is not None:
        service = get_service(session, id)

    if service is not None:
        for o in service.owner:
            for d in o.domain:
                for e in d.element:
                    for r in e.reservation:
                        delete_reservation(session, reservation=r)
                    delete_element(session,element=e)
                delete_domain(session,domain=d)
            delete_owner(session,owner=o)

        session.delete(service)
        session.commit()

def create_owner(session, service, name, information, url, date)->Owner:

    owner = Owner(name=name, information=information, url=url, date=date)
    service.owner.append(owner)
    session.add(owner)
    session.commit()

    return owner

def get_owner(session, id)->Owner:

    return session.query(Owner).get(id)

def delete_owner(session, id=None, owner=None):

    if id is not None:
        owner = get_owner(session, id)

    if owner is not None:
        for d in owner.domain:
            for e in d.element:
                for r in e.reservation:
                    delete_reservation(session, reservation=r)
                delete_element(session, element=e)
            delete_domain(session, domain=d)

        session.delete(owner)
        session.commit()

def create_domain(session, owner, name, information, url, date)->Domain:

    domain = Domain(name=name, information=information, url=url, date=date)
    owner.domain.append(domain)
    session.add(domain)
    session.commit()

    return domain

def get_domain(session, id)->Domain:

    return session.query(Domain).get(id)

def delete_domain(session, id=None, domain=None):

    if id is not None:
        domain = get_domain(session, id)

    if domain is not None:
        for e in domain.element:
            for r in e.reservation:
                delete_reservation(session, reservation=r)
            delete_element(e)

        session.delete(domain)
        session.commit()

def create_element(session, domain, name, information, url, date, init_time,
                    end_time, price)->Element:

    element = Element(name=name, information=information, url=url, date=date,
                      init_time=init_time, end_time=end_time, price=price,
                      reserved=False)

    domain.element.append(element)
    session.add(element)
    session.commit()

    return element

def get_element(session, id)->Element:

    return session.query(Element).get(id)

def delete_element(session, id=None, element=None):

    if id is not None:
        element = get_element(session, id)

    if element is not None:
        for r in element.reservation:
            delete_reservation(session, reservation=r)

        session.delete(element)
        session.commit()


def create_client(session, service, name, information, url, date)->Client:

    client = Client(name=name, information=information, url=url, date=date)
    service.client.append(client)
    session.add(client)
    session.commit()

    return client

def get_client(session, id)->Client:

    return session.query(Client).get(id)

def delete_client(session, id=None, client=None):

    if id is not None:
        client = get_client(session, id)

    if client is not None:
        for r in client.reservation:
            delete_reservation(session, reservation=r)

        session.delete(client)
        session.commit()

def create_reservation(session, service, client, element, name, information, url,
                       date)->Reservation:

    reservation = Reservation(name=name, information=information, url=url, date=date)
    client.reservation.append(reservation)
    element.reservation.append(reservation)
    element.reserved = True

    session.add(reservation)
    session.commit()

    return reservation

def get_reservation(session, id)->Reservation:

    return session,query(Reservation).get(id)

def delete_reservation(session, id=None, reservation=None):

    if id is not None:
        reservation = get_reservation(session, id)

    if reservation is not None:
        session.delete(reservation)
        session.commit()

def get_domain_elements(session, id=None, domain=None)->list:

    res = list()

    if id is not None:
        domain = get_domain(session, id)

    if domain is not None:
        for e in domain.element:
            res.append(e.id)

    return res

def get_domain_aval_elements(session, id=None, domain=None)->list:

    res = list()
    if id is not None:
        domain = get_domain(session, id)

    if domain is not None:
        for e in domain.element:
            if not e.reserved: res.append(e.id)

    return res

def get_domain_total_aval_elements(session, id=None, domain=None)->int:
    res = list()
    if id is not None:
        domain = get_domain(session, id)

    if domain is not None:
        count = 0
        for e in domain.element:
            if not e.reserved: count += 1
        return count

    return -1


if __name__ == "__main__":
    from base import Base, engine, Session
    import time

    Base.metadata.create_all(engine)
    session = Session()

    ex_serv = create_service(session, "service1","service1","service1", date(1996,3,25))
    id = ex_serv.id

    ex_own  = create_owner(session, ex_serv,"owner1","owner1","owner1", date(1996,3,25))
    owner = ex_serv.owner

    ex_domain  = create_domain(session, ex_own,"d1","d1","d1", date(1996,3,25))
    ex_element = create_element(session, ex_domain,"e1","e1","e1", date(1996,3,25), init_time=int(time.time()), end_time=int(time.time()+5), price=10.35)
    ex_client  = create_client(session, ex_serv,"c1","c1","c1", date(1996,3,25))

    ex_reserv = create_reservation(session, ex_client, ex_element,"r1", "r1", "r1",datetime.datetime.now())


    for r in ex_client.reservation:
        print(r)


    session.close()
