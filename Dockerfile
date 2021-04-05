FROM ubuntu:18.04 as dev

RUN apt update -y && apt install -y gcc unzip cmake make curl git 

RUN curl -L https://tarantool.io/installer.sh | bash -s -- --repo-only
RUN apt install -y tarantool luarocks

RUN tarantoolctl rocks install http
RUN luarocks install jsonschema

WORKDIR /var/lib/tarantool


FROM python:3.8-alpine as test

ENV TZ Europe/Moscow
ENV PYTHONDONTWRITEBYTECODE yes

COPY ./requirements.txt .
RUN pip install -r requirements.txt && rm requirements.txt

RUN mkdir /tests
WORKDIR /tests
