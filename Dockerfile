FROM hashbangnz/ruby:2.2.2

RUN apt-get update

RUN apt-get install -y wget curl \
    build-essential git git-core \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

RUN apt-get update

RUN apt-get install -y software-properties-common

RUN apt-get install -y vim

# Add options to gemrc
RUN echo "gem: --no-document" > ~/.gemrc

RUN gem install bundler

ENV BUNDLE_GEMFILE=/app/Gemfile
ENV BUNDLE_JOBS=2
ENV BUNDLE_PATH=/bundle
ENV BUNDLE_WITHOUT=development:test

WORKDIR /tmp

RUN mkdir /app
RUN mkdir -p /app/tmp/pids

RUN mkdir /app/.bundle
RUN echo 'BUNDLE_WITHOUT: development:test' > /app/.bundle/config

WORKDIR /app

RUN gem install backup # version 4 backups
RUN mkdir /backups

RUN rm /etc/default/rcS && touch /etc/default/rcS
RUN echo "UTC=no" >> /etc/default/rcS
RUN cp /etc/localtime /etc/localtime.bkp
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Pacific/Auckland /etc/localtime

# for running backup v4
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' >> /etc/apt/sources.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-9.4
RUN apt-get remove -y postgresql-client-9.3

COPY . /app