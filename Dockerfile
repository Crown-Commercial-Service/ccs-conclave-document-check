FROM ruby:3.0.3-alpine AS base
WORKDIR /app
RUN apk add --update build-base clamav clamav-daemon curl libpq-dev nodejs
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 5

FROM ruby:3.0.3-alpine
WORKDIR /app
RUN apk --no-cache upgrade && apk --no-cache add clamav clamav-daemon curl libpq-dev nodejs
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
