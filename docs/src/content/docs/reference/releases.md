---
title: "Release Notes"
description: "Version history and notable changes of the Claper project."
---

The following release notes summarize key features, improvements, and fixes in each version of Claper.

### v2.3.1
**Fixes and Improvements**
- Improve performance of presentations to load slides faster
- Fix manager layout on small screens
- Add clickable hyperlinks in messages
- Improve quiz export
- Add option to force login to submit quizzes
- Fix URL with question mark being flagged as a question

### v2.3.0
**Features**
- Add quizzes interaction with LTI AGS integration and QTI export
- Add join link in manager view to join attendee room more easily
- Export all interactions to CSV in the reports view
- Add Oban for asynchronous jobs (mailer and LMS API calls)

**Fixes and Improvements**
- New report view with better metrics and tab-view for all interactions
- Improve design of interaction boxes in attendee room
- Fix engagement rate stats
- Add button to trigger product tour instead of auto-start
- Improve UX for interactions and presentation settings in manager view
- Add pagination for events on the dashboard
- Fix SMTP adapter to work with secure connections
- Add soft delete for user accounts

### v2.2.0
**Features**
- Add duplicate feature on finished events
- Add Italian translation (thanks to @loviuz and @albanobattistella)
- Add `EMAIL_CONFIRMATION` env var to disable/enable email confirmation

**Fixes and Improvements**
- Improve performance of global reactions
- Change QR Code background color to white
- Improve auto-scroll of messages on the manager
- Fix pinning of questions
- Fix empty name picker during reconnect
- Update wording for options dropdown and access
- Fix dropdown positioning layering
- Allow owner/facilitators to join attendee room before event start
- Fix email templates

### v2.1.1
**Fixes and Improvements**
- Restrict OIDC to `client_secret_basic` and `client_secret_post` methods
- Fix minimum message length validation
- Fix poll option order
- Fix translations for current interactions
- Improve poll results UI
- Optimize resource usage when attendees join
- Fix duplicate event accessibility

### v2.1.0
**Features**
- LTI 1.3 integration (Beta)
- OpenID Connect integration
- New layout for presentation manager
- Duplicate event feature

**Fixes and Improvements**
- Improve embed compatibility with various providers
- Add option to polls to show results to attendees
- Fix input length validation for polls

### v2.0.1
**Features**
- Add Dutch translation (#91 by @robinaartsma)
- Add dynamic layout for presenter view

**Fixes and Improvements**
- Fix responsive layout on dashboard
- Fix presenter layout with embeds when messages are hidden
- Fix missing stream for form submits
- Fix unknown locales
- Fix embeds updates
- Add validation to prevent self-assign as facilitator
- Replace reactions toggle behavior for messages
- Improve embed integration in presenter view

### v2.0.0
**Features**
- Dynamic layout in manager view
- Quick event creation
- Question feature
- Toggle for reactions and poll results in attendee room
- Delete account option in settings
- Language switcher in settings
- Tour guide for new users
- Headers in exported CSV reports
- Spanish locale (thanks to @eduproinf)

**Fixes and Improvements**
- Multi-arch Docker image support (ARM/AMD64)
- Improved date picker UI
- Upgraded Ecto, Phoenix, LiveView
- Fix user avatars in reports
- Fix average voters stats
- Various UI/UX fixes
- Remove event end date
- Environment variable changes: `BASE_URL`, `SAME_SITE_COOKIE`, `SECURE_COOKIE`

### v1.7.0
- Keyboard shortcuts for settings (#64 by @Dhanus3133)
- Embed external content (YouTube, etc.) (#72 by @Dhanus3133)
- Pinned messages (#62 by @haruncurak)
- Reset password feature
- Indication when a form is saved
- Postmark adapter
- Email notifications to facilitators
- Presenter window navigation (#63 by @railsmechanic)
- Default avatar style update
- Security updates

### v1.6.0
- Improved QR code readability
- ARM Docker image
- Refactored runtime configuration
- Local storage improvements via `PRESENTATION_STORAGE_DIR`
- Fix poll/form panel scroll on mobile
- Fix message length validation and word break
- Fix date translations
- Minor form management fixes

### v1.5.0
- Nickname feature and toggle for anonymous messages
- URL info on instruction page with QR code
- German locale (thanks to @Dynnammo)
- Upgrade Moment and Moment Timezone for security
- Upgrade TailwindCSS v2 to v3
- UI fixes on moderator page
- Fix event link color contrast

### v1.4.1
- Add `GS_JPG_RESOLUTION` env var for JPG resolution (#40 by @mokaddem)
- Fix `MAX_FILE_SIZE_MB` not being updated

### v1.4.0
- Migrate to Phoenix 1.7 and LiveView 0.18
- Add multiple choice polls
- Import interactions from other presentations
- Introduce `MAX_FILE_SIZE_MB` env var
- Deactivate messages feature during presentations

### v1.3.0
- Add Forms feature for data collection
- Improve Docker Compose docs and file reference

### v1.2.1
- Fix presenter URL (400 error in production)

### v1.2.0
- Add password change form in settings
- Expand production deployment docs

### v1.1.1
**Security Updates**
- `ENABLE_MAILBOX_ROUTE`, `MAILBOX_USER`, `MAILBOX_PASSWORD` env vars to secure mailbox route
- Restrict `/users/register` when `ENABLE_ACCOUNT_CREATION` is false

### v1.1.0
- Added password authentication
- Removed passwordless auth and disabled email verification
- Introduced `ENABLE_ACCOUNT_CREATION` env var
- Improved French localization

### v1.0.0
Initial open-source release. Contributions welcome!