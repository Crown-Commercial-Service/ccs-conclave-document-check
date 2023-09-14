#!/bin/bash

COMMIT_HASH=$(git rev-parse --short HEAD)
export COMMIT_HASH

docker build -t ccs-conclave-document-check:$COMMIT_HASH .

docker compose -f docker-compose.built.yml run -e RAILS_ENV=test \
  ccs-conclave-document-check \
  sh -c "rake db:setup && rspec spec"


if [ $? -ne 0 ]; then
  echo "Tests failed! Exiting with status 1..."
  exit 1
fi
