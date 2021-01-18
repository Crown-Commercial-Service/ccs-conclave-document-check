FROM ruby:2.7.2-alpine

ENV BUILD_PACKAGES curl-dev ruby-dev postgresql-dev build-base tzdata bash clamav clamav-daemon rsyslog wget clamav-libunrar

# Update and install base packages
RUN apk update && apk upgrade && apk add bash $BUILD_PACKAGES nodejs-current-npm git

COPY config/antivirus /etc/clamav
COPY bootstrap.sh /
COPY check.sh /

RUN mkdir /var/run/clamav && \
    touch /var/run/clamav/clamd.pid && \
    chown clamav:clamav /var/run/clamav/clamd.pid && \
    touch /var/run/clamav/clamd.sock && \
    chown clamav:clamav /var/run/clamav/clamd.sock && \
    chmod 750 /var/run/clamav && \
    chown -R clamav:clamav bootstrap.sh check.sh /etc/clamav && \
    chmod u+x bootstrap.sh check.sh

EXPOSE 3310/tcp

USER clamav
#
#CMD ["/bootstrap.sh"]

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Create app directory
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

COPY . .

# Install Gem dependencies
RUN bundle install

# Run app in production environment
ENV RAILS_ENV=production

# Configure Rails to serve the assets
ENV RAILS_SERVE_STATIC_FILES=true

# Send logs to STDOUT so that they can be sent to CloudWatch
ENV RAILS_LOG_TO_STDOUT=true

# Run the web app on port 8080
ENV PORT=8080
EXPOSE 8080

RUN echo "[bootstrap] Schedule freshclam DB updater."
RUN freshclam
RUN /usr/bin/freshclam -d -c 6

RUN echo "[bootstrap] Run clamav daemon..."
RUN exec /usr/sbin/clamd -c /etc/clamav/clamd.conf

