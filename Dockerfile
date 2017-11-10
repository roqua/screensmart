FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

ENV BUNDLE_PATH /app/gems
RUN mkdir -p /app/gems

RUN bundle install
