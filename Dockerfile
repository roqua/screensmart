FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

ENV BUNDLE_PATH /app/gems

RUN bundle install || rm -Rf /app/gems
RUN bundle install
