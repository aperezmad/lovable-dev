FROM node:20-alpine

# Instalar dependencias del sistema incluyendo cliente de Postgres
RUN apk add --no-cache \
    git \
    curl \
    openssh-client \
    tar \
    bash \
    unzip \
    postgresql-client && \
    corepack enable && \
    corepack prepare pnpm@latest --activate

# Instalar Supabase CLI
RUN wget -O supabase.tar.gz https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz && \
    tar -xzf supabase.tar.gz && \
    mv supabase /usr/local/bin/supabase && \
    rm supabase.tar.gz && \
    chmod +x /usr/local/bin/supabase

# Crear y dar permisos COMO ROOT
RUN mkdir -p /home/node/app/node_modules && \
    chown -R node:node /home/node/app

# Cambiar a user node
USER node

# Instalar Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/home/node/.bun/bin:${PATH}"
RUN bun --version

WORKDIR /home/node/app