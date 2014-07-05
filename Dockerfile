FROM ubuntu:trusty
MAINTAINER Kamil Trzcinski <ayufan@ayufan.eu>

RUN apt-get update && apt-get install -y python-pip python-dev git nano
RUN apt-get install -y python-ldap
RUN git clone https://github.com/Unity-Technologies/buildbot -b katana /buildbot
WORKDIR /buildbot/master
RUN git checkout vKatana1.1.8
RUN ln -s prod/css/default.css buildbot/status/web/files/default.css
RUN python setup.py build
RUN python setup.py install

RUN sed -i 's/^from sqlalchemy import exceptions as sa_exceptions$/from sqlalchemy import exc as sa_exceptions/g' /usr/local/lib/python2.7/dist-packages/sqlalchemy_migrate-0.7.2-py2.7.egg/migrate/versioning/schema.py
RUN sed -i "s/user_settings = yield userdb.get_all_user_props(s['uid'])/user_settings = []/g" /usr/local/lib/python2.7/dist-packages/buildbot-1.1.8-py2.7.egg/buildbot/status/web/authz.py

WORKDIR /
RUN buildbot create-master /master
ADD master.cfg /master/master.cfg
RUN cp -av /buildbot/master/buildbot/status/web/files/* /master/public_html

EXPOSE 8010 9989

CMD ["buildbot", "start", "--nodaemon", "/master"]
