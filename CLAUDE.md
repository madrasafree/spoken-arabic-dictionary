# Spoken Arabic Dictionary — Claude Instructions

Read this file before making any changes.
Full onboarding reference: `AGENTS.md` | DB schema: `docs/db.md` | Includes: `docs/includes.md` | Pages: `docs/pages.md` | Migration plan: `plan.md`

---

## Stack

Classic ASP (VBScript) + MS Access `.mdb` on IIS/GoDaddy. Push to `main` → **auto-deploys to production immediately**.
Migration target: Django + PostgreSQL + React (see `plan.md`).

---

## Critical ASP Rules

### 1. `inc/inc.asp` must be the very first line of every `.asp` file

```asp
<!--#include file="inc/inc.asp"-->
```

Nothing before it — not a comment, not whitespace, not HTML.
Violation causes VBScript error 800a0400 (`Option Explicit` fails) → page is broken.

### 2. Standard page wrapper (in this order)

```
inc/inc.asp      ← DB connection + shared objects
inc/header.asp   ← <head> assets, Google Analytics
inc/top.asp      ← nav bar, session handling
inc/trailer.asp  ← footer, </body></html>
```

### 3. All variables must be declared with `Dim`

`Option Explicit` is enforced via `inc/inc.asp`.

### 4. SQL — no parameterization exists; do not add new injection vectors

The codebase uses string-concatenated SQL. Always escape user input with `displayToSqlQuery()` from `inc/functions/string.asp` before putting it in a SQL string.
Known existing risk: `label.asp` — `Request("id")` concatenated directly into SQL.

### 5. DB connection wrappers

Use `openDbLogger` / `closeDbLogger` — not `openDB` / `closeDB` directly.
Cross-database foreign keys are logical only (not enforced by the engine).

---

## Push / Deploy Safety

Deploy is automatic: **push to `main` = live on production within seconds.**

### Always before pushing

1. `python tools/check-http.py --local` — verifies HTTP status of key routes
2. `python tools/browser-check.py --local` — loads pages in Chromium, checks for IIS errors

### PR required — do NOT push these directly to `main`

| File(s) | Reason |
|---|---|
| `web.config` | Bad config takes every page down instantly |
| `inc/*.asp` (shared includes) | Used by ~120 pages — breakage is site-wide |
| Database schema changes | Cannot rollback |
| Site-wide CSS / JS | Visual breakage everywhere |

Single `.asp` pages and docs → direct push to `main` is fine after local test.

---

## `web.config` — Frozen Locally

`web.config` is frozen locally via `git update-index --skip-worktree`.
**Do not edit `web.config` directly.** See `AGENTS.md` → "web.config — Local vs Production" for the full procedure.

---

## Auth Levels

| Level | Role |
|---|---|
| 0 | Anonymous / public |
| 1–2 | Registered user |
| 3+ | Team member (can access `team/` pages) |
| 15 | Admin (can access `admin.*` pages) |

Always verify auth level is checked on team and admin pages before saving changes.

---

## Databases

All `.mdb` files in `App_Data/` (gitignored — never committed).

| DB | Purpose |
|---|---|
| `arabicWords` | Words, labels, sentences, lists, media, history |
| `arabicUsers` | Users, auth, feature flags |
| `arabicSearch` | Search analytics |
| `arabicManager` | Team tasks, voting |
| `arabicLogs` | System monitoring (admin only) |

Dead DBs (code references exist but `.mdb` files do not): `arabicSchools`, `arabicSandbox`.

---

## After Modifying a File

Update the relevant row in `docs/file-inventory.csv` (lines count, size_kb, description, notes).
Update `docs/pages.md` if page logic/dependencies changed.

---

## Known Patterns — Do Not "Fix" Without Discussion

- **N+1 queries** in `labels.asp` / `label.asp` — intentional, manageable at current scale
- **`prevID` deduplication** in `label.asp` — guards against duplicate rows from `LEFT JOIN wordsMedia`
- **`openDbLogger` timing wrappers** — timing code is dead; do not remove the wrappers themselves
