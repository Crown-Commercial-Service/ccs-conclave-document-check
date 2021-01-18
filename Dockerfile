FROM ruby:2.7.2-alpine

ENV BUILD_PACKAGES curl-dev ruby-dev postgresql-dev build-base tzdata bash clamav clamav-daemon

# Update and install base packages
RUN apk update && apk upgrade && apk add bash $BUILD_PACKAGES

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Create app directory
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

# Install Gem dependencies
RUN bundle install --deployment --without development test

COPY . .

# Run app in production environment
ENV RAILS_ENV=production

# Configure Rails to serve the assets
ENV RAILS_SERVE_STATIC_FILES=true

# Send logs to STDOUT so that they can be sent to CloudWatch
ENV RAILS_LOG_TO_STDOUT=true

# Run the web app on port 8080
ENV PORT=8080
EXPOSE 8080

# Ensure our entry point script is executable
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ./docker-entrypoint.sh
