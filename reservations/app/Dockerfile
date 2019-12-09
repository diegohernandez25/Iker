FROM python:3.6

EXPOSE 5000

WORKDIR /app

COPY requirements.txt /app
COPY database /app/database
COPY views /app/views
COPY json_op.py /app


RUN pip install -r requirements.txt

COPY app.py /app
CMD python app.py
