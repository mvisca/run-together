# Base estable
FROM ruby:3.3.0-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias básicas
RUN apt-get update --fix-missing || apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      gnupg2 \
      build-essential \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      git \
      ca-certificates \
      apt-transport-https \
      wget \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Bundler (install latest)
RUN gem install bundler

# Node & PNPM
# Install Node 20 (current LTS) from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g pnpm && \
    rm -rf /var/lib/apt/lists/*

# Indicar a Rails que use pnpm
ENV JS_PACKAGE_MANAGER=pnpm

WORKDIR /app

# Copiar Gemfile primero para cache
COPY Gemfile Gemfile.lock ./

# Instalar gems
RUN bundle install

# Copiar package.json y pnpm-lock.yaml para cache de node
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

# Copiar el resto del proyecto
COPY . .

# Copiar el script de entrypoint
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Exponer el puerto
EXPOSE 3000

# Configurar entrypoint y comando por defecto
ENTRYPOINT ["docker-entrypoint.sh"]
CMD []