from flask import Flask, redirect, url_for, request, jsonify
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Date, ForeignKey, Float, update, insert
from sqlalchemy.sql import select, text, bindparam, and_
import datetime
import json


app = Flask(__name__)

#Database
engine = create_engine('sqlite:///booking.db', echo = True)
meta = MetaData()
tables = dict()


MAIN_URL = 'localhost:8080'



#Create Tables
def create_tables():
    Service = Table('service', meta,
                    Column('id', Integer, primary_key = True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String),
                    Column('date', String, nullable=False))


    Owner = Table('owner', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String),
                    Column('date', String, nullable=False))

    Domain = Table('domain', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer,ForeignKey("service.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String),
                    Column('date', String, nullable=False)
                   )

    Element = Table('element', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('id_domain', Integer, ForeignKey("domain.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String),
                    Column('date', String, nullable=False),
                    Column('init_time', String, nullable=False),
                    Column('end_time', String),
                    Column('price', Float)
                    )

    Client = Table('client', meta,
                   Column('id', Integer, primary_key=True),
                   Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                   Column('name', String, nullable=False),
                   Column('information', String),
                   Column('url', String),
                   Column('date', String, nullable=False))

    Reservation = Table('reservation', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('id_service', Integer, ForeignKey("service.id"), primary_key=True),
                    Column('id_domain', Integer, ForeignKey("domain.id"), primary_key=True),
                    Column('id_element', Integer, ForeignKey("element.id"), primary_key=True),
                    Column('id_client', Integer, ForeignKey("client.id"), primary_key=True),
                    Column('information', String),
                    Column('url', String),
                    Column('date', String, nullable=False))

    meta.create_all(engine)
    return {'reservation': Reservation, 'client': Client, 'element': Element, 'domain': Domain, 'Owner': owner,
            'service': Service}


@app.route('/service', methods=['GET', 'POST'])
def service():
    global tables

    #>  Create a new Service.
    if request.method == 'POST':
        jsonreq = request.json
        assert isinstance(jsonreq, dict)
        assert (set(jsonreq.keys()).issubset(['name', 'information'])), 'Keys are not according to the operation mapping.'

        conn = engine.connect()
        service = Table('service', meta, autoload=True, autoload_with=engine)
        time = str(datetime.datetime.now())

        query = service.insert().values(name=jsonreq['name'], information=json.dumps(jsonreq['information']), date=time)
        result = conn.execute(query)
        pkey = result.inserted_primary_key[0]

        query = update(service).values(url="/" + str(pkey))
        query = query.where(service.c.id == pkey)
        result = conn.execute(query)

        query = select([service]).where(service.c.id == pkey)
        result = conn.execute(query)

        tmp_lst = list()
        for row in result:
            tmp_lst.append(row)
        conn.close()

        id, name, info, url, date = tmp_lst[0]

        return jsonify(url=MAIN_URL+url,
                       id=id)

    #> Gets all services urls
    else:
        conn = engine.connect()
        service = Table('service', meta, autoload=True, autoload_with=engine)
        query = select([service])
        result = conn.execute(query)

        tmp_dict = dict()
        for row in result:
            tmp_dict[row[0]] = {"url":MAIN_URL + row[3], "name":row[1]}
        conn.close()
        return json.dumps(tmp_dict)


def crt_service_cnt(content):


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
    tables = create_tables()
    app.run()


