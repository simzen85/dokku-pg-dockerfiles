# forked from https://gist.github.com/jpetazzo/5494158

FROM	ubuntu:12.04
MAINTAINER	kload "kload@kload.fr"

# prevent apt from starting postgres right after the installation
RUN	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get -y -q install python-software-properties software-properties-common
RUN apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# allow autostart again
RUN	rm /usr/sbin/policy-rc.d

ADD	. /usr/bin
RUN	chmod +x /usr/bin/start_pgsql.sh
RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf
RUN sed -i -e"s/var\/lib/opt/g" /etc/postgresql/9.3/main/postgresql.conf
