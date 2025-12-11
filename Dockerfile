# Base estable
FROM ruby:3.3.0-bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias básicas
RUN apt-get update && \
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
      wget && \
    rm -rf /var/lib/apt/lists/*

# Bundler (install latest)
RUN gem install bundler

# Node & Yarn
# Install Node 20 (current LTS) from NodeSource to avoid deprecated Node 18
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get update && \
  apt-get install -y nodejs && \
  npm install -g yarn@1.22.22 && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar Gemfile primero para cache
COPY Gemfile Gemfile.lock ./

# Instalar gems
RUN bundle install

# Copiar package.json y yarn.lock para cache de node
COPY package.json yarn.lock ./
RUN yarn install

# Copiar el resto del proyecto
COPY . .

# Copiar el script de entrypoint
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Exponer el puerto
EXPOSE 3000

# Configurar entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]