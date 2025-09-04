FROM ruby:3.1.2

# OS packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    curl \
    ca-certificates \
    gnupg \
 && rm -rf /var/lib/apt/lists/*

# Node.js 20 + Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get update -y && apt-get install -y --no-install-recommends nodejs \
 && npm install -g yarn \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /rails-docker

# bundle cache
COPY Gemfile Gemfile.lock /rails-docker/
RUN bundle install

# app
COPY . /rails-docker
