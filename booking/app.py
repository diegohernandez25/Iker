from flask import Flask, redirect, url_for, request, jsonify
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Date, ForeignKey, Float, update, insert, func, delete
from sqlalchemy.sql import select, text, bindparam, and_
from logging.config import dictConfig

import datetime
import json


app = Flask(__name__)

#Database
engine = create_engine('sqlite:///booking.db', echo = True)
meta = MetaData()
tables = dict()




dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': 'ext://flask.logging.wsgi_errors_stream',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})

MAIN_URL = 'localhost:8080'

class InvalidUsage(Exception):
    status_code = 400

    def __init__(self, message, status_code=None, payload=None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_dict(self):
        rv = dict(self.payload or ())
        rv['message'] = self.message
        return rv

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
                    Column('id_service', Integer, ForeignKey("owner.id_service"), primary_key=True),
                    Column('id_owner', Integer, ForeignKey("owner.id"), primary_key=True),
                    Column('name', String, nullable=False),
                    Column('information', String),
                    Column('url', String),
                    Column('date', String, nullable=False)
                   )

    Element = Table('element', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_service', Integer, ForeignKey("domain.id_service"), primary_key=True),
                    Column('id_owner', Integer, ForeignKey("domain.id_owner"), primary_key=True),
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
                   Column('id_service', Integer, ForeignKey("service.id"),primary_key=True),
                   Column('name', String, nullable=False),
                   Column('information', String),
                   Column('url', String),
                   Column('date', String, nullable=False))

    Reservation = Table('reservation', meta,
                    Column('id', Integer, primary_key=True),
                    Column('id_service', Integer, ForeignKey("element.id_service"), primary_key=True),
                    Column('id_owner', Integer, ForeignKey("element.id_owner"), primary_key=True),
                    Column('id_domain', Integer, ForeignKey("element.id_domain"), primary_key=True),
                    Column('id_element', Integer, ForeignKey("element.id"), primary_key=True),
                    Column('id_client', Integer, ForeignKey("client.id")),
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


@app.route('/<id>/owner', methods=['POST'])
def create_owner(id):
    #>Check if service id exists

    conn = engine.connect()
    service = Table('service', meta, autoload=True, autoload_with=engine)
    query = select([service.columns.id]).where(service.c.id == id)
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()

    if len(tmp_lst) == 0:
        raise InvalidUsage('This view is gone', status_code=410)

    id_service = tmp_lst[0][0]

    jsonreq = request.json

    #> Creates owner
    if request.method == 'POST':
        #assert isinstance(id, Integer)
        #assert (set(jsonreq.keys()).issubset(['name', 'information'])), 'Keys are not according to the operation mapping.'
        conn = engine.connect()

        owner = Table('owner', meta, autoload=True, autoload_with=engine)
        time = str(datetime.datetime.now())

        query = select([func.max(owner.columns.id)]).where(owner.c.id_service == id)
        result = conn.execute(query)
        tmp_l = list()
        for row in result:
            tmp_l.append(row)
        e = tmp_l[0][0]
        owner_id = 0 if e == None else e + 1

        app.logger.info('owner:\t'+str(owner_id))


        query = owner.insert().values(name=jsonreq['name'], information=json.dumps(jsonreq['information']), date=time, id_service=id_service, id=owner_id)
        result = conn.execute(query)
        pkey = result.inserted_primary_key[0]

        url = "/" + str(id_service)+"/owner/"+str(pkey)
        query = update(owner).values(url="/" + str(id_service)+"/owner/"+str(pkey))
        query = query.where(and_(owner.c.id == pkey, owner.c.id_service ==id_service))
        result = conn.execute(query)

        query = select([owner]).where(and_(owner.c.id == pkey, owner.c.id_service ==id_service))
        result = conn.execute(query)

        tmp_lst = list()
        for row in result:
            tmp_lst.append(row)
        conn.close()

        id, id_service, name, info, url, date = tmp_lst[0]
        return jsonify(url=MAIN_URL + url,
                       id=id)


@app.route('/<id>/owner/<owner_id>', methods=['GET', 'DELETE'])
def owner(id, owner_id):
    conn = engine.connect()
    owner = Table('owner', meta, autoload=True, autoload_with=engine)
    query = select([owner]).where(and_(owner.columns.id == owner_id,owner.columns.id_service == id))
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()

    if len(tmp_lst) == 0:
        raise InvalidUsage('This view is gone', status_code=410)


    if request.method == 'GET':
        id, id_service, name, information, url, date = tmp_lst[0]
        response = {"name": name, "id_service":id_service, "id":id, "information":information,"date":date, "domains":dict()}
        return json.dumps(response)

    else:
        conn = engine.connect()
        query = delete(owner).where(and_(owner.columns.id == owner_id,owner.columns.id_service == id))
        result = conn.execute(query)
        conn.close()
        return "OK"

@app.route('/<id>/owner/<owner_id>/domain', methods=['POST'])
def create_domain(id, owner_id):
    conn = engine.connect()
    owner = Table('owner', meta, autoload=True, autoload_with=engine)
    query = select([owner]).where(and_(owner.c.id_service == id, owner.c.id == owner_id))
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()

    if len(tmp_lst) == 0:
        raise InvalidUsage('This view is gone', status_code=410)

    owner_info = tmp_lst[0]

    jsonreq = request.json


    if request.method == 'POST':
        #assert isinstance(id, int)
        #assert isinstance(owner_id, int)
        #assert (
        #    set(jsonreq.keys()).issubset(['name', 'information'])), 'Keys are not according to the operation mapping.'

        conn = engine.connect()

        domain = Table('domain', meta, autoload=True, autoload_with=engine)
        time = str(datetime.datetime.now())

        query = select([func.max(domain.columns.id)]).where(and_(domain.c.id_owner == owner_id, domain.c.id_service ==id))
        result = conn.execute(query)
        tmp_l = list()
        for row in result:
            tmp_l.append(row)
        e = tmp_l[0][0]
        domain_id = 0 if e == None else e + 1

        app.logger.info('owner:\t' + str(owner_id))

        query = domain.insert().values(name=jsonreq['name'], information=json.dumps(jsonreq['information']), date=time,
                                      id_owner=owner_id, id_service=id, id=domain_id)
        result = conn.execute(query)

        url = "/" + str(id) + "/owner/" + str(owner_id)+"/domain/"+str(domain_id)
        query = update(domain).values(url=url)
        query = query.where(and_(domain.c.id == domain_id, domain.c.id_owner == owner_id, domain.c.id_service==id))
        result = conn.execute(query)

        query = select([domain]).where(and_(domain.c.id == domain_id, domain.c.id_owner == owner_id, domain.c.id_service==id))
        result = conn.execute(query)

        tmp_lst = list()
        for row in result:
            tmp_lst.append(row)
        conn.close()

        return jsonify(url=MAIN_URL + url,id=domain_id)


@app.route('/<id>/owner/<owner_id>/domain/<domain_id>', methods=['GET', 'DELETE'])
def domain(id, owner_id, domain_id):
    conn = engine.connect()
    domain = Table('domain', meta, autoload=True, autoload_with=engine)

    query = select([domain]).where(
        and_(domain.columns.id == domain_id, domain.columns.id_owner == owner_id, domain.columns.id == id))
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()

    if len(tmp_lst) == 0:
        raise InvalidUsage('This view is gone', status_code=410)

    if request.method == 'GET':
        id, id_service, id_owner, name, information, url, date = tmp_lst[0]
        response = {"name": name, "id_service": id_service, "id": id, "information": information, "date": date,
                    "elements": dict(), "id_owner":id_owner}
        return json.dumps(response)

    else:
        conn = engine.connect()
        query = delete(owner).where(and_(domain.columns.id == domain_id, domain.columns.id_owner == owner_id, domain.columns.id == id))
        result = conn.execute(query)
        conn.close()
        return "OK"


@app.route('/<id>/owner/<owner_id>/domain/<domain_id>/element', methods=['POST'])
def create_element(id, owner_id, domain_id):
    conn = engine.connect()
    owner = Table('owner', meta, autoload=True, autoload_with=engine)
    query = select([domain]).where(and_(domain.c.id_service == id, domain.c.id_owner == owner_id, domain.c.id == domain_id))
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()

    if len(tmp_lst) == 0:
        raise InvalidUsage('This view is gone', status_code=410)

    domain_info = tmp_lst[0]

    jsonreq = request.json

    if request.method == 'POST':
        #assert isinstance(id, int)
        #assert isinstance(owner_id, int)
        #assert isinstance(domain_id, int)
        #assert (set(content.keys()).issubset(
        #    ['name', 'information'])), 'Keys are not according to the operation mapping.'
        conn = engine.connect()

        element = Table('element', meta, autoload=True, autoload_with=engine)
        time = str(datetime.datetime.now())

        query = select([func.max(element.columns.id)]).where(and_(element.c.id_service == id, element.c.id_owner == owner_id, element.c.id_domain == domain_id))
        result = conn.execute(query)
        tmp_l = list()
        for row in result:
            tmp_l.append(row)
        e = tmp_l[0][0]
        element_id = 0 if e == None else e + 1

        app.logger.info('owner:\t' + str(owner_id))

        query = element.insert().values(name=jsonreq['name'], information=json.dumps(jsonreq['information']), date=time,
                                      id_service=id, id_owner=owner_id, id_domain= domain_id, id=element_id, init_time=jsonreq['init_time'],
                                        end_time=jsonreq['end_time'], price=jsonreq['price'])
        result = conn.execute(query)

        url = "/" + str(id) + "/owner/" + str(owner_id) + "/domain/"+ str(domain_id)+"/element/"+str(element_id)
        query = update(element).values(url=url)
        query = query.where(and_(element.c.id_service == id, element.c.id_owner == owner_id, element.c.id_domain == domain_id, element.c.id_element==element_id))
        result = conn.execute(query)

        query = select([element]).where(and_(element.c.id_service == id, element.c.id_owner == owner_id, element.c.id_domain == domain_id, element.c.id_element==element_id))
        result = conn.execute(query)

        tmp_lst = list()
        for row in result:
            tmp_lst.append(row)
        conn.close()

        id, id_service, id_owner, id_domain, name, info, url, date, init_time, end_time, price = tmp_lst[0]
        return jsonify(url=MAIN_URL + url,
                       id=id)



def crt_element_cnt(id, owner_id, domain_id, content):

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


