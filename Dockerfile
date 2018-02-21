FROM registry.roqua.nl/roqua/rq:ruby-2.3

ADD Gemfile /app
ADD Gemfile.lock /app

RUN bundle install -j 4

ADD . /app
RUN rm -Rf /app/.git

RUN bundle exec rake assets:precompile
