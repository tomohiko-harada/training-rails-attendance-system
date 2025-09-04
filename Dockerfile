FROM ruby:3.2.2
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs
RUN mkdir /training-rails-attendance-system
WORKDIR /training-rails-attendance-system
COPY Gemfile Gemfile.lock /training-rails-attendance-system/
RUN bundle install