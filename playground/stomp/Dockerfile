FROM rmohr/activemq:5.15.4-alpine

# docker run -p 61614:61614 -p 61616:61616 -p 61613:61613 -p 8161:8161 kwakwa/test-activemq

USER root

RUN mkdir /mnt/conf /mnt/data
RUN chown activemq: /mnt/conf /mnt/data
RUN cp -a /opt/activemq/conf/* /mnt/conf/
RUN cp -a /opt/activemq/data/* /mnt/data/

USER activemq
