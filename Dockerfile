FROM ruby:3.0.3

WORKDIR /app

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  clamav \
  clamav-daemon

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]