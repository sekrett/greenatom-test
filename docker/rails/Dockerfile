FROM ruby:3.3.0

ARG uid=1001
ARG gid=1001

ENV DOCKERIZE_VERSION v0.7.0
ENV BUNDLER_VERSION 2.5.3

RUN apt-get update -qq \
    && apt-get install -qy --no-install-recommends lsb-release \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update -qq \
    && apt-get install -qy --no-install-recommends \
      build-essential \
      postgresql-client-16 \
      wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && addgroup --gid $gid app \
    && adduser --uid $uid --gid $gid --disabled-password --home /app --gecos "" app

COPY Gemfile Gemfile.lock .ruby-version /install/

RUN gem install bundler:$BUNDLER_VERSION \
    && cd /install \
    && bundle install \
    && rm -rf /install

USER app
WORKDIR /app
VOLUME /app

EXPOSE 3000
