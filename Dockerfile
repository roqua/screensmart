FROM registry.roqua.nl/roqua/screensmart:production as production
FROM registry.roqua.nl/roqua/screensmart:latest as latest

FROM registry.roqua.nl/roqua/docker-base-images:ruby-2.3

COPY --from=production /app/Gemfile /app/Gemfile
COPY --from=production /app/Gemfile.lock /app/Gemfile.lock

RUN bundle install -j 4 --clean

COPY --from=latest /app/Gemfile /app/Gemfile
COPY --from=latest /app/Gemfile.lock /app/Gemfile.lock
RUN bundle install -j 4 --clean

ADD Gemfile /app
ADD Gemfile.lock /app

RUN bundle install -j 4 --clean

ADD . /app

COPY --from=production /app/public/assets /app/public/assets
RUN find /app/public/assets -mtime +90 -delete

# Remove old manifest file
RUN rm -f /app/public/assets/manifest-*.json
# Remove new manifest file
RUN rm -f /app/public/assets/.sprockets-manifest-*.json

RUN bundle exec rake assets:precompile
