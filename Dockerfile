FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

RUN [ ! -d /app/gems ] || mv /app/gems/ /gems/

RUN bundle install || rm -Rf /gems
RUN bundle install
RUN bundle exec rake assets:precompile
