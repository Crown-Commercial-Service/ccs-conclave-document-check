FROM ruby:3.0.3-alpine AS build

WORKDIR /app

RUN apk add --update build-base nodejs clamav clamav-daemon libpq-dev

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 5

FROM ruby:3.0.3-alpine

COPY --from=build /usr/local/bundle /usr/local/bundle

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
