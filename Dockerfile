FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN gem install bundler

ADD . /app

WORKDIR /app

RUN bundle install

ENV RAILS_ENV production
