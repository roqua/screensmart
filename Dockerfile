FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN gem install bundler

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle config --global frozen 1
RUN bundle install --without development test

ADD . /app

ENV RAILS_ENV production
