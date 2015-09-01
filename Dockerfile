FROM hashbangnz/ruby:2.2.3

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

RUN rm /etc/default/rcS && touch /etc/default/rcS
RUN echo "UTC=no" >> /etc/default/rcS
RUN cp /etc/localtime /etc/localtime.bkp
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Pacific/Auckland /etc/localtime

COPY . /app