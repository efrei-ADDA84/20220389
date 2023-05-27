FROM python:3.9

WORKDIR /app

ARG API_KEY

ENV API_KEY = value1

COPY WeatherApiWrappertp3.py ./
COPY requirement.txt ./

RUN pip3 install --no-cache-dir -r requirement.txt
CMD [ "sh", "-c","python ./WeatherApiWrappertp3.py ${API_KEY}" ]