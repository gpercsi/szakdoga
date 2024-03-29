FROM ubuntu:20.04
 
ENV IPADDRESS = 127.0.0.1
ENV ID = 0
ENV EMQX_NAME = emqx
ENV EMQX_HOST = 127.0.0.1
ENV masterIP = 127.0.0.1
ENV WORKER = false 
ENV USERNAME = admin
ENV PASSWORD = admin

RUN echo "root:admin1234" | chpasswd
RUN apt-get update -y;\
        apt-get install -y\
        python3\
        net-tools\
        nano\
        wget
RUN mkdir p /etc/emqx;\
        cd /etc/emqx;\
        wget 'https://github.com/emqx/emqx/releases/download/v4.4.4/emqx-4.4.4-otp24.1.5-3-ubuntu20.04-amd64.deb';\
        apt update -y;\
        apt-get install -f /etc/emqx/emqx-4.4.4-otp24.1.5-3-ubuntu20.04-amd64.deb
        
EXPOSE 8080 1883 4369 4370 6379 8081 8083 8883 8084 18083

COPY start.sh /

ENTRYPOINT ["/start.sh"]
#CMD ["sleep", "infinity"]
