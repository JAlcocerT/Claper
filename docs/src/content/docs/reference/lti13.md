---
title: "LTI 1.3 Integration"
description: "Modules supporting LTI 1.3 OIDC, launch validation, and tool services."
---

Claper includes a full LTI 1.3 tool implementation under `lib/lti_13/`, covering:

## Core Modules

- **Lti13.Registrations** – manage tool registrations (issuer, client_id, deployment_id).
- **Lti13.Deployments** – track tool deployments in an LMS.
- **Lti13.Users** – associate LTI users with local accounts.
- **Lti13.Nonces** – generate and verify single-use nonces.
- **Lti13.Resources** – represent resource links (line items, results).
- **Lti13.Jwks** – JSON Web Key Set management (generate, validate keys).
- **Lti13.QuizScoreReporter** – send quiz scores back via AGS.

## Tool-Specific Flows (`Lti13.Tool`)

- **OidcLogin** (`Lti13.Tool.OidcLogin`)
  Handles the OIDC-based login and JWT validation.
- **LaunchValidation** (`Lti13.Tool.LaunchValidation`)
  Validates incoming LTI launch requests (JWT, nonce, message claims).
- **MessageValidators.ResourceMessageValidator**
  Ensures resource launch parameters are correct.

### Services (`Lti13.Tool.Services`)

- **AccessToken** – obtain and refresh OAuth2 access tokens.
- **AGS (Assignment & Grade Services)**
  - `Lti13.Tool.Services.AGS.LineItem` – create/manage gradebook columns.
  - `Lti13.Tool.Services.AGS.Score` – submit scores back to the LMS.
- **NRPS (Names & Roles Provisioning Service)**
  - `Lti13.Tool.Services.NRPS` – fetch class roster.
  - `Lti13.Tool.Services.NRPS.Membership` – membership object.

## Typical Flow

1. **Registration**: Administrator registers your tool in the LMS.
2. **OIDC Login**: Redirect to `OidcLogin.authenticate/2`.
3. **Launch**: LMS posts a signed JWT to `/lti/launch`, validated by `LaunchValidation`.
4. **Service Calls**: Use `AccessToken` to call AGS/NRPS endpoints.