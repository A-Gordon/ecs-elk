# https://www.docker.elastic.co/
FROM docker.elastic.co/logstash/logstash:7.6.0
COPY ./config/logstash.yml /usr/share/logstash/config/logstash.yml
COPY ./pipeline /usr/share/logstash/pipeline