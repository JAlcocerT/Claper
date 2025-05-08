---
title: "Web Layer"
description: "Phoenix web interface: endpoint, router, controllers, LiveView, and plugs."
---

The web interface lives under `lib/claper_web/`:

## Endpoint & Router

- **ClaperWeb.Endpoint**
  Configures HTTP/HTTPS, sockets, static asset serving.
- **ClaperWeb.Router**
  Defines pipelines (`:browser`, `:api`), routes for controllers and LiveViews.

## Controllers

- **PageController** – static pages and home.
- **EventController**, **PostController**, **StatController** – CRUD APIs.
- **UserRegistrationController**, **UserSessionController**, **UserConfirmationController**, **UserSettingsController**, **UserResetPasswordController** – user flows.
- **UserOidcAuthController** – OIDC callback handling.
- **MailboxGuard** – secure in-app email preview.

## LiveView & Channels

- **LiveAuth**: `UserLiveAuth`, `AttendeeLiveAuth` – real-time auth flows.
- **ModalComponent**, **LiveHelpers** – UI helpers.
- **PresenceChannel** – track connected users.

## Views & Templates

Each controller has a corresponding `*.View` for rendering HTML or JSON.

## Plugs

- **ClaperWeb.Plugs.Iframe** – allow embedding in iframes when enabled.
- **LocalePlug** – set locale from user preferences or default.
- **UserAuth** – guard routes and manage sessions.

## Notifiers

- **LeaderNotifier**, **UserNotifier** – deliver in-app and email notifications.