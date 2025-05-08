---
title: "Deployment"
description: "Setup, build, and deploy Claper locally or in production."
---

## Prerequisites

- Elixir & Erlang (`asdf` recommended)
- Node.js & npm
- PostgreSQL 15+
- Docker & Docker Compose (optional)

## Local Development

1. Copy and edit environment variables:

   ```bash
   cp .env.sample .env
   ```

2. Install Elixir dependencies and setup the database:

   ```bash
   mix deps.get
   mix ecto.setup        # creates, migrates, seeds
   ```

3. Install front-end assets and start the server:

   ```bash
   cd assets && npm install
   cd ..
   iex -S mix phx.server
   # or use helper
   ./dev.sh start
   ```

4. Visit `http://localhost:4000`.

## Building a Release

1. Compile production assets and build release:

   ```bash
   ./build.sh
   ```

2. The release archive is in `_build/prod/rel/claper`.

## Docker & Docker Compose

- **Local dev with Docker**:

  ```bash
  docker-compose up --build
  ```

  - Database on port `5432`
  - App on port `4000`
  - Volumes persist uploads and DB.

- **Production**:

  - Multi-stage `Dockerfile` builds a minimal Alpine image.
  - Uses `mix release --overwrite`.
  - Exposes port `4000`, runs migrations and seeds on start.
  - `docker-compose.yml` includes Traefik labels for TLS.

## Environment Variables

Defined in `.env` or passed via `env_file`:

- `DATABASE_URL`, `SECRET_KEY_BASE`
- `PRESENTATION_STORAGE_DIR`
- `MAIL_TRANSPORT`, `SMTP_*`
- `ENABLE_ACCOUNT_CREATION`, `EMAIL_CONFIRMATION`
- OIDC: `OIDC_ISSUER`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`, etc.