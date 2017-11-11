FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

ENV BUNDLE_PATH /gems

RUN [ ! -d /app/gems ] || mv /app/gems/ /gems/

RUN bundle install || rm -Rf /gems
RUN bundle install
RUN bundle exec rake assets:precompile
