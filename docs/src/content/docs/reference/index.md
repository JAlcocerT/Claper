---
title: "Claper Reference"
description: "High-level overview of the Claper project, its modules, dependencies, and configuration."
---

## Project Overview

Claper is a Phoenix (Elixir) web application for creating and managing interactive events, presentations, polls, quizzes, forms, and embedded content. It features:

- User management (registration, authentication, password reset, email confirmation, OIDC).
- Real-time updates via Phoenix LiveView and Channels.
- Learning Tools Interoperability (LTI) 1.3 support for LMS integration (OIDC login, launch validation, grade reporting).
- File/image uploads and processing (Mogrify, S3 form uploads).
- Background jobs with Oban.
- AWS S3 and local filesystem storage options.

## Key Features

- **Accounts**: Traditional sign-up/sign-in, magic links, external OIDC providers.
- **Events**: Create, paginate, expire, and manage access.
- **Presentations**: Upload and display slide decks.
- **Polls & Quizzes**: Live polling and scoring.
- **Forms & Posts**: Custom forms and rich-text posts.
- **Embeds**: External content embedding with security controls.
- **Real-time**: LiveView components, Presence, notifications.
- **LTI 1.3**: Full OIDC and tool service implementation.

## Modules

- **Core Contexts** (`lib/claper/*.ex`): Business logic contexts (Accounts, Events, Polls, etc.).
- **Web Layer** (`lib/claper_web/*`): Endpoint, router, controllers, views, LiveView, plugs.
- **LTI 1.3** (`lib/lti_13/*`): Modules and services for LTI flows.
- **Utilities** (`lib/utils/*`): File upload and S3-upload helpers.
- **Config** (`config/*.exs`): Application, environment, runtime settings.
- **Assets** (`assets/*`): JavaScript, CSS (Tailwind), build scripts.

## Dependencies

- **Elixir** `~> 1.12`, **Phoenix** `~> 1.7`
- **Ecto**, **Postgrex**
- **bcrypt_elixir**, **joken**, **jose**, **oidcc**
- **Oban** (background jobs)
- **ExAws**, **ExAws.S3**, **Hackney**
- **Mogrify**, **SweetXml**
- **Phoenix LiveView**, **esbuild**, **Dart Sass**
- **Swoosh** (email), **Finch**, **Req**
- **UUID**, **Porcelain**, **Libcluster**, **CSV**

## Configuration & Environment

Configuration is driven by `config/*.exs` and an optional `.env` file in the project root. Key variables:

- `DATABASE_URL` – PostgreSQL connection URI.
- `SECRET_KEY_BASE` – Phoenix secret for cookies/sessions.
- `PRESENTATION_STORAGE` – `"local"` or `"s3"`.
- `PRESENTATION_STORAGE_DIR` – local upload directory.
- `MAIL_TRANSPORT`, `MAIL_FROM`, SMTP settings.
- Feature flags: `ENABLE_ACCOUNT_CREATION`, `EMAIL_CONFIRMATION`, etc.
- OIDC: `OIDC_ISSUER`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`, `OIDC_SCOPES`, etc.

See `.env.sample` for defaults and examples.

## Project Structure

```
. 
├── lib/
│   ├── claper/           # Context modules
│   ├── claper_web/       # Phoenix web interface
│   ├── lti_13/           # LTI 1.3 integration
│   └── utils/            # Helpers
├── config/               # Elixir & Phoenix configs
├── assets/               # Front-end assets
├── docker-compose.yml    # Local development with Docker
├── Dockerfile            # Production release multi-stage build
├── build.sh              # CI/CD build & release script
└── dev.sh                # Helper for local `mix` commands
```

## Static Code Analysis

- **Languages**: Elixir, JavaScript/Node.js, Bash.
- **Linters**: Credo (Elixir), Prettier/ESLint (assets).
- **Docs**: ExDoc configuration in `mix.exs`.
- **Tests**: Ecto integration tests under `test/`.