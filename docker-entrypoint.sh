#!/usr/bin/env bash

# because the APP_RUN_SIDEKIQ parameter is defined in /Environment/ccs/cmp and not /Environment/ccs/cmpsidekiq,
# we have to check for it being false, so we can run the rails server, otherwise run sidekiq
echo TCPAddr clamavd > /etc/clamav/clamd.conf && echo TCPSocket 3310 >> /etc/clamav/clamd.conf

bundle exec rails server