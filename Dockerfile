FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

RUN [ ! -d /app/gems ] || mv /app/gems/ /usr/local/bundle/

RUN bundle install || rm -Rf /usr/local/bundle
RUN bundle install
RUN bundle exec rake assets:precompile
