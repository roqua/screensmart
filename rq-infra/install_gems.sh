#!/bin/bash
set -e

export BUNDLE_PATH=/cache/bundle

echo $SSH_KEY | base64 -d > /root/.ssh/id_rsa
chown root:root /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

echo "Installing gems..."

bundle list | grep '* unicorn (' || bundle inject unicorn '> 0'
bundle check --path /cache/bundle || bundle install --retry 3 --jobs 4 --path /cache/bundle

rm /root/.ssh/id_rsa
