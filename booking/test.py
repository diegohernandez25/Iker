from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Date, ForeignKey, Float, update, select, insert, func, delete
from sqlalchemy.sql import select, text, bindparam, and_
import datetime
import json
import sys

engine = create_engine('sqlite:///booking.db', echo = True)
meta = MetaData()

def test_composed():
    client_id=1
    id=1
    conn = engine.connect()
    client = Table('client', meta, autoload=True, autoload_with=engine)
    element = Table('element', meta, autoload=True, autoload_with=engine)
    reservation = Table('reservation', meta, autoload=True, autoload_with=engine)
    query = select([client]).where(and_(client.columns.id == client_id, client.columns.id_service == id))
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()

    if len(tmp_lst) == 0:
        print('ERROR')
        sys.exit()

    conn = engine.connect()
    query = select([reservation])
    query = query.select_from(client.join(reservation, client.columns.id == reservation.columns.id_client))#.where(and_(client.columns.id == client_id, client.columns.id_service == id))
    result = conn.execute(query)
    d_res = dict()
    for e in result:
        id, id_service, id_owner, id_domain, id_element, id_client, information, url, date= e
        d_res[id] = {'id':id, 'id_service':id_service, 'id_owner':id_owner, 'id_domain':id_domain, 'id_element':id_element, 'id_client':id_client, 'information':information, 'url':url, 'date':date}

    print('d_res:\t',repr(d_res))
    conn.close()

if __name__ == "__main__":
    test_composed()
    """
    id = 1
    owner_id = 8
    conn = engine.connect()
    owner = Table('owner', meta, autoload=True, autoload_with=engine)
    query = select([owner]).where(and_(owner.columns.id == owner_id, owner.columns.id_service == id))
    result = conn.execute(query)
    tmp_lst = list()
    for row in result:
        tmp_lst.append(row)
    conn.close()


    owner_info = tmp_lst[0]


    print('owner_info:\t',owner_info)"""






