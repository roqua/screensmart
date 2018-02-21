FROM registry.roqua.nl/roqua/docker-base-images:ruby-2.3

ADD Gemfile /app
ADD Gemfile.lock /app

RUN bundle install -j 4

ADD . /app

RUN bundle exec rake assets:precompile
