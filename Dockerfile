FROM registry.roqua.nl/roqua/dev_infra:rails

ADD . /app

RUN [ ! -d /app/gems ] || sh -c "rm -Rf $BUNDLE_PATH && mv /app/gems/ $BUNDLE_PATH/ && echo 'Added cached gems'"

RUN bundle install || rm -Rf /usr/local/bundle
RUN bundle install
RUN bundle exec rake assets:precompile
