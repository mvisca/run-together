FROM ruby:3.3.0-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    BUNDLE_PATH=/usr/local/bundle \
    JS_PACKAGE_MANAGER=pnpm \
    RAILS_ENV=production

# Dependencias del sistema (cambia poco - se cachea)
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

# Copiar SOLO archivos de dependencias primero (mejor caché)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Ahora sí copiar el resto del código
COPY . .

# Precompilar assets
RUN bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]