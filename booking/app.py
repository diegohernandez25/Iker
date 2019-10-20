from flask import Flask, redirect, url_for, request
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Date, ForeignKey, Float
from sqlalchemy.sql import select, text, bindparam, and_

app = Flask(__name__)

#Database
engine = create_engine('sqlite:///booking.db', echo = True)
meta = MetaData()

#Create Tables
def create_tables():
    Service = Table('service', meta,
                    Column('id', Integer, primary_key = True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False))

    Owner = Table('owner', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False))

    Domain = Table('domain', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer,ForeignKey("service.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False))

    Element = Table('element', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('id_domain', Integer, ForeignKey("domain.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False))

    Client = Table('client', meta,
                   Column('id', Integer, primary_key=True),
                   Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                   Column('name', String, nullable=False),
                   Column('information', String),
                   Column('url', String, nullable=False),
                   Column('date', Date, nullable=False))

    Lease = Table('lease', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('id_domain', Integer, ForeignKey("domain.id"), primary_key=True),
                    Column('id_element', Integer, ForeignKey("element.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False),
                    Column('init_time', Date, nullable=False),
                    Column('end_time', Date),
                    Column('price', Float)
                    )


    Reservation = Table('reservation', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('id_domain', Integer, ForeignKey("domain.id"), primary_key=True),
                    Column('id_element', Integer, ForeignKey("element.id"), primary_key=True),
                    Column('id_lease', Integer, ForeignKey("lease.id"), primary_key=True),
                    Column('id_client', Integer, ForeignKey("client.id"), primary_key=True),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False))

    meta.create_all(engine)


@app.route('/service', methods=['GET', 'POST'])
def service():
    if request.method == 'POST':
        crt_service_cnt()

    else:
        pass

def crt_service_cnt(content):
    assert isinstance(content,dict)
    assert (set(content.keys()).issubset(['name', 'information'])), 'Keys are not according to the operation mapping.'
    return

@app.route('/<id>/owner', methods=['POST'])
def create_owner(id):
    if request.method == 'POST':
        pass
    else:
        pass

def crt_owner_cnt(id, content):
    assert isinstance(id, int)
    assert (set(content.keys()).issubset(['name', 'information'])), 'Keys are not according to the operation mapping.'

@app.route('/<id>/owner/<owner_id>', methods=['GET', 'DELETE'])
def owner(id, owner_id):
    if request.method == 'GET':
        pass
    else:
        pass

@app.route('/<id>/owner/<owner_id>/domain', methods=['POST'])
def create_domain(id, owner_id):
    if request.method == 'POST':
        pass
    else:
        pass

def crt_domain_cnt(id,owner_id,content):
    assert isinstance(id, int)
    assert isinstance(owner_id, int)
    assert (set(content.keys()).issubset(['name', 'information'])), 'Keys are not according to the operation mapping.'


@app.route('/<id>/owner/<owner_id>/domain/<domain_id>', methods=['GET', 'DELETE', 'POST'])
def domain(id, owner_id, domain_id):
    if request.method == 'GET':
        pass
    if request.method == 'POST': #lease all elements of domain.
        pass
    else:
        pass

def crt_lease_domain_elements_cnt(id, owner_id, domain_id, content):
    assert isinstance(id, int)
    assert isinstance(owner_id, int)
    assert isinstance(domain_id, int)
    assert (set(content.keys()).issubset(
        ['name', 'information', 'init_time', 'end_time', 'price'])), 'Keys are not according to the operation mapping.'


@app.route('/<id>/owner/<owner_id>/domain/<domain_id>/element', methods=['POST'])
def create_element(id, owner_id, domain_id):
    if request.method == 'POST':
        pass
    else:
        pass

def crt_element_cnt(id, owner_id, domain_id, content):
    assert isinstance(id, int)
    assert isinstance(owner_id, int)
    assert isinstance(domain_id, int)
    assert (set(content.keys()).issubset(
        ['name', 'information'])), 'Keys are not according to the operation mapping.'


@app.route('/<id>/owner/<owner_id>/domain/<domain_id>/element/<element_id>', methods=['GET','DELETE', 'POST'])
def element(id, owner_id, domain_id, element_id):
    if request.method == 'GET':
        pass
    elif request.method == 'POST':
        pass
    else: #delete
        pass

def crt_elem_lease_cnt(id, owner_id, domain_id, element_id, content):
    assert isinstance(id, int)
    assert isinstance(owner_id, int)
    assert isinstance(domain_id, int)
    assert isinstance(element_id, int)
    assert (set(content.keys()).issubset(
        ['name', 'information', 'init_time', 'end_time', 'price'])), 'Keys are not according to the operation mapping.'


@app.route('/<id>/client', methods=['POST'])
def create_client(id):
    if request.method == 'POST':
        pass
    else:
        pass

def crt_client_cnt(id, content):
    assert isinstance(id, int)
    assert (set(content.keys()).issubset(
        ['name', 'information'])), 'Keys are not according to the operation mapping.'


@app.route('/<id>/owner/<owner_id>/domain/<domain_id>/element/<element_id>/leases', methods=['GET'])
def leases(id, owner_id, domain_id, element_id):
    if request.method == 'GET':
        pass
    else:
        pass



@app.route('/<id>/owner/<owner_id>/domain/<domain_id>/element/<element_id>/<lease_id>', methods=['GET', 'POST', 'DELETE'])
def lease(id, owner_id, domain_id, element_id, lease_id):
    if request.method == 'GET':
        pass
    elif request.method == 'POST': #make a reservation
        pass
    else: #DELETE
        pass

def crt_reserve_cnt(id, owner_id, domain_id, element_id,lease_id, content):
    assert isinstance(id, int)
    assert isinstance(owner_id, int)
    assert isinstance(domain_id, int)
    assert isinstance(element_id, int)
    assert isinstance(lease_id, int)
    assert (set(content.keys()).issubset(
        ['name', 'information'])), 'Keys are not according to the operation mapping.'

@app.route('/<id>/client/<client_id>', methods=['GET','DELETE'])
def client(id, client_id):
    if request.method == 'GET':
        pass
    else:
        pass

@app.route('/<id>/client/<client_id>/leases', methods=['GET'])
def client_leases(id, client_id):
    if request.method == 'GET':
        pass
    else:
        pass

@app.route('/<id>/client/<client_id>/<lease_id>', methods=['GET', 'DELETE'])
def client_lease(id, client_id, lease_id):
    if request.method == 'GET':
        pass
    else: #Cancels reservation
        pass


if __name__ == '__main__':
    create_tables()
    app.run()


