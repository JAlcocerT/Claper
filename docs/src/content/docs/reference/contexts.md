---
title: "Core Context Modules"
description: "Business-logic contexts in the Claper project"
---

Claper uses Phoenix contexts to encapsulate domain logic. Each module under `lib/claper/` is a context exposing CRUD and business operations.

### Claper.Accounts

Purpose: Manage user lifecycle (registration, authentication, confirmation, password reset, OIDC, magic links).

Key functions:
- `create_user(attrs) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}`  
- `get_user_by_email(email) :: %User{} | nil`  
- `get_user_by_email_and_password(email, pwd) :: %User{} | nil`  
- `generate_user_session_token(%User{}) :: String.t()`  
- `deliver_user_confirmation_instructions(user, url_fun) :: {:ok, token} | {:error, :already_confirmed}`  
- `confirm_user(token) :: {:ok, %User{}} | :error`  
- `deliver_user_reset_password_instructions(user, url_fun)`  
- `reset_user_password(user, attrs) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}`  
- **OIDC**: `create_oidc_user/1`, `get_or_create_user_with_oidc/1`, etc.

### Claper.Events

Purpose: CRUD, pagination, and expiration of Event resources; manage activity leaders.

Key functions:
- `list_events(user_id, preload \\\ \[]) :: [%Event{}]`  
- `paginate_events(user_id, params, preload) :: {[%Event{}], total_count, total_pages}`  
- `list_not_expired_events(user_id)` / `paginate_not_expired_events/3`  
- `list_expired_events(user_id)` / `paginate_expired_events/3`  
- `list_managed_events_by(email)` / `paginate_managed_events_by/3`  
- `count_managed_events_by(email)` / `count_expired_events(user_id)`

### Other Contexts

- **Claper.Forms** – build and process custom forms.  
- **Claper.Polls** – live polls, option tallying.  
- **Claper.Quizzes** – question sets, scoring.  
- **Claper.Posts** – rich-text posts and comments.  
- **Claper.Presentations** – slide deck uploads & navigation.  
- **Claper.Embeds** – embed external URLs securely.  
- **Claper.Interactions** – real-time interactions data.  
- **Claper.Stats** – aggregate and report usage statistics.  
- **Claper.Mail** / **Claper.Mailer** – email delivery abstraction.  
- **Claper.Repo** – Ecto repository for database access.

Contexts share a common pattern:
1. Query builders using `Ecto.Query`.
2. CRUD APIs: `list_*`, `get_*`, `create_*`, `update_*`, `delete_*`.
3. Pagination via `Repo.paginate/3`.
4. Preload associations where needed.