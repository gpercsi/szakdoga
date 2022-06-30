FROM ubuntu:20.04

RUN echo "root:admin1234" | chpasswd
RUN apt-get update -y
RUN apt-get install python3 -y
RUN apt-get install net-tools -y
RUN apt-get install nano -y
RUN apt-get install wget -y
RUN mkdir p /etc/emqx && cd /etc/emqx
RUN wget 'https://github.com/emqx/emqx/releases/download/v4.4.4/emqx-4.4.4-otp24.1.5-3-ubuntu20.04-amd64.deb'
RUN apt update
RUN apt-get install -f ./emqx-4.4.4-otp24.1.5-3-ubuntu20.04-amd64.deb
RUN echo "#!/bin/bash" > /run/start.sh
RUN echo "emqx start" >> /run/start.sh
RUN echo "sleep infinity" >> /run/start.sh

EXPOSE 1883 8081 8083 8883 8084 18083

CMD ["bash", "/run/start.sh"]
