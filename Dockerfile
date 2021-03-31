FROM docker.io/debian:buster-slim

RUN mkdir -p /data

COPY http-nevada /data/http-nevada
COPY terremotos /data/terremotos
COPY puntos-http.lonlath /data/

CMD "/bin/bash"
