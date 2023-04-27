FROM python:3.9

ARG API_KEY
ARG LAT
ARG LONG

ENV LAT = value1
ENV LONG = value2
ENV API_KEY = value3

COPY WeatherWrapper.py ./

RUN pip3 install requests
CMD [ "sh", "-c","python ./WeatherWrapper.py ${LAT} ${LONG} ${API_KEY}" ]