FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

ENV BUNDLE_PATH /gems

RUN [ ! -d /app/gems ] || rsync -a /app/gems/ /gems/

RUN bundle install || rm -Rf /gems
RUN bundle install

RUN rm -Rf /app/gems
