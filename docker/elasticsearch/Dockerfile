# https://www.docker.elastic.co/
FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.0
ENV REGION eu-west-1
# ADD ./config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
ADD ./config/elasticsearch-master.yml /usr/share/elasticsearch/config/elasticsearch.yml
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch discovery-ec2

