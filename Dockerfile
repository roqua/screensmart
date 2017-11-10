FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

ENV BUNDLE_PATH /gems

RUN [ ! -d /apps/gems ] || rsync -a /apps/gems/ /gems/

RUN bundle install || rm -Rf /gems
RUN bundle install

RUN rm -Rf /gems/apps/
