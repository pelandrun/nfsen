FROM ubuntu:20.04
LABEL maintainer "javier.zavalia@gmail.com"
LABEL version="1.3.7"
LABEL description="Docker container for nfsen"

ENV TZ=Etc/GMT+3
ENV APACHE_RUN_DIR=/var/www/nfsen/
ENV APACHE_PID_FILE=/apache.pid
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
    && apt-get install -y libapache2-mod-php php-cli rrdtool mtr-tiny nfdump nfdump-sflow procps locales supervisor apache2 \
    && apt-get install -y librrds-perl libmailtools-perl libsocket6-perl 
RUN apt-get install -y nano
RUN locale-gen en_US.UTF-8
RUN useradd -s /sbin/nologin netflow
RUN usermod -a -G www-data netflow

RUN rm -rf /etc/apache2/sites-enabled/* \
	&& rm -rf /etc/apache2/mods-enabled/alias.* 

COPY 00-apache.conf /etc/apache2/sites-enabled/
COPY nfsen-1.3.7.tar.gz /nfsen-1.3.7.tar.gz
RUN tar zxvf nfsen-1.3.7.tar.gz
#COPY nfsen.conf /nfsen-1.3.7/etc/
RUN sed -i 's/rrd_version < 1.5/rrd_version < 1.8/' /nfsen-1.3.7/libexec/NfSenRRD.pm
ADD run.sh /run.sh
RUN chmod +x /run.sh
RUN ls -lart /

EXPOSE 80/tcp
EXPOSE 9995/udp
EXPOSE 9996/udp

WORKDIR /

ENTRYPOINT ["/run.sh"]
