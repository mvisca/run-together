FROM ruby:3.3.0-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    BUNDLE_PATH=/usr/local/bundle \
    JS_PACKAGE_MANAGER=pnpm \
    RAILS_ENV=development

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential postgresql-client git curl \
    libpq-dev libssl-dev libreadline-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v '~> 2.5'

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    corepack enable && \
    corepack prepare pnpm@8.15.0 --activate && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN bundle install && pnpm install

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bin/dev"]