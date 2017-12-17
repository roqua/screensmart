FROM registry.roqua.nl/roqua/rq:ruby-2.3

ADD . /app

RUN [ ! -d /app/gems ] || sh -c "rm -Rf $BUNDLE_PATH && mv /app/gems/ $BUNDLE_PATH/ && echo 'Added cached gems'"

RUN (bundle install || rm -Rf /usr/local/bundle; bundle install)

RUN bundle exec rake assets:precompile
