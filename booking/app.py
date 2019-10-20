from flask import Flask
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

    AvailableElement = Table('available_element', meta,
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
                    Column('id_available_element', Integer, ForeignKey("available_element.id"), primary_key=True),
                    Column('id_client', Integer, ForeignKey("client.id"), primary_key=True),
                    Column('information', String),
                    Column('url', String, nullable=False),
                    Column('date', Date, nullable=False))

    meta.create_all(engine)
    print('tables created.')


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    create_tables()
    app.run()
