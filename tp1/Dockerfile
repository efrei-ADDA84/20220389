FROM python:3.9

WORKDIR /app

ARG API_KEY
ARG LAT
ARG LONG

ENV LAT = value1
ENV LONG = value2
ENV API_KEY = value3

COPY WeatherWrapper.py ./

RUN pip3 install --no-cache-dir requests==2.7.0
CMD [ "sh", "-c","python ./WeatherWrapper.py ${LAT} ${LONG} ${API_KEY}" ]