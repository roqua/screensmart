#!/bin/bash
set -e

/install_gems.sh


/app/rq-infra/initialize_database.rb
bundle exec rake db:migrate

service nginx restart

mkdir -p /app/tmp/sockets

echo 'Running custom entrypoint...'
[ ! -f /app/entrypoint.sh ] || /app/entrypoint.sh

exec "$@"
