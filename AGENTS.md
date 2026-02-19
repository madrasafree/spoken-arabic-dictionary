# AGENTS.md — Spoken Arabic Dictionary

Agent instructions for working on this codebase. Read this file before making any changes.

---

## Project Overview

**Live site:** https://milon.madrasafree.com/
**Local dev:** http://localhost:8081 (IIS on Windows)

A free Hebrew→Arabic spoken-dialect dictionary. Founded 2005, transferred to Madrasa NGO in 2022.
Community-sourced words reviewed by experienced users.

---

## Technology Stack

| Layer | Technology |
|---|---|
| Server-side | Classic ASP (VBScript) |
| Database | Microsoft Access `.mdb` files |
| Web server | IIS on Windows (GoDaddy Windows web hosting) |
| DNS / CDN | Cloudflare |
| Deployment | Push to `main` → auto-deploy via GoDaddy git integration |
| Local dev | IIS on Windows, port 8081 |

---

## Repository Layout

```
/                        ← root ASP pages (word.asp, labels.asp, etc.)
inc/                     ← shared includes: inc.asp, header.asp, top.asp, trailer.asp
inc/functions/           ← utility functions (functions.asp, soundex.asp, string.asp)
team/                    ← team/admin tools (word submission, correction, media)
admin.*                  ← admin-only pages (require auth level 15)
css/                     ← stylesheets
js/                      ← scripts
img/                     ← images
App_Data/                ← MS Access .mdb databases (gitignored — server-only)
error_docs/              ← custom IIS error pages (only not_found.html is used)
docs/                    ← project documentation (blocked from public HTTP access)
docs/file-inventory.csv ← full file inventory with metadata
docs/pages/pages.md     ← page-by-page code/logic/dependency documentation
web.config              ← IIS production config (see web.config section below)
web.config.prod         ← reference copy of production web.config
web.config.local        ← reference copy of local dev web.config
```

**Gitignored:** `App_Data/`, `.well-known/`, `.claude/`, `.playwright-mcp/`

---

## Databases

All databases are MS Access `.mdb` files in `App_Data/` (gitignored, deployed separately).
Full schema documentation: **`docs/db.md`**

| Database | Status | Contents |
|---|---|---|
| `arabicWords` | Live | words, labels, sentences, lists, media, relations, history |
| `arabicUsers` | Live | users, authentication, feature flags |
| `arabicSearch` | Live | search term analytics and per-search event log |
| `arabicManager` | Live | team task management, subtasks, community voting |
| `arabicLogs` | Live (admin-only) | system monitor status (scheduled job health) |
| ~~`arabicSchools`~~ | Dead | MDB does not exist; dead code remains in `admin.log.duration.asp` |
| ~~`arabicSandbox`~~ | Dead | MDB does not exist (test DB removed); dead code remains in `admin.log.duration.asp` |

Connection and recordset objects (`con`, `res`, `res2`, `res3`) are opened in `inc/inc.asp`.
Use `openDbLogger` / `closeDbLogger` wrappers — not `openDB` / `closeDB` directly.

---

## Critical ASP Rules

### 1. Include order — MUST be first line
```asp
<!--#include file="inc/inc.asp"-->
```
This **MUST** be the very first line of every `.asp` file.
Never put anything before it — not even an HTML comment.
Violating this causes VBScript error 800a0400 (`Option Explicit` fails).

### 2. Standard page wrapper
Almost every public page uses these four includes in this order:
```
inc/inc.asp      ← DB connection + utility functions
inc/header.asp   ← CSS/JS <link>/<script> tags, Google Analytics
inc/top.asp      ← navigation bar, session handling
inc/trailer.asp  ← footer, avatar query, closing </body></html>
```

### 3. Variable declaration
`Option Explicit` is enforced via `inc/inc.asp`. All variables must be declared with `Dim`.

### 4. SQL — no parameterization
The codebase uses string-concatenated SQL (known SQL injection risks exist).
Do not introduce new SQL injection vectors. Note any existing ones in comments.

---

## web.config — Local vs Production

The production `web.config` is tracked in git. Local dev uses a different config.

**To switch to local dev mode:**
```bash
git update-index --skip-worktree web.config
# then overwrite web.config with the content of web.config.local
```

**To commit a web.config change:**
```bash
git update-index --no-skip-worktree web.config
# update web.config with production content (see web.config.prod)
# update web.config.prod to match
# commit both files
# re-enable skip-worktree and restore local content
```

**Production web.config does:**
- Custom 404 → `error_docs/not_found.html`
- Blocks public access to `/docs/` via `requestFiltering hiddenSegments`
- Sets compilation temp directory (absolute path — verify this matches GoDaddy's actual server path)

> **Note:** `web.config.prod` currently contains Plesk-style absolute paths (`G:\PleskVhosts\...`).
> If these don't match the actual GoDaddy server paths, the custom 404 and temp dir settings will silently fall back to IIS defaults. Verify with the hosting control panel.

---

## Auth Levels

| Level | Role |
|---|---|
| 0 | Anonymous / public |
| 1–2 | Registered user |
| 3+ | Team member (can access `team/` pages) |
| 15 | Admin (can access `admin.*` pages) |

---

## Deployment

**Host:** GoDaddy Windows web hosting
**CDN/DNS:** Cloudflare sits in front — DNS is pointed at Cloudflare, which proxies to GoDaddy.
**Deploy:** Push to `main` → GoDaddy git integration auto-deploys to production.

Always merge feature branches to `main` before expecting changes on the live site.

**Branch convention:** feature branches merged to `main`; push `main` to deploy.

### ⚠ Safety rules — mandatory before any push

**Always test before pushing:**
- ASP page changes → run `python tools/browser-check.py --local` against localhost:8081
- Any change → run `python tools/check-http.py --local` to confirm no broken routes
- web.config changes → apply the requestFiltering/hiddenSegments rules to the local web.config temporarily and verify locally before committing the production version

**Use a pull request (not a direct push to main) for anything that can break production:**

| Change type | Branch + PR required |
|---|---|
| `web.config` changes | **Yes** — infrastructure, instant effect on all pages |
| Shared includes (`inc/*.asp`) | **Yes** — used by ~120 pages |
| Database schema changes | **Yes** |
| CSS/JS loaded site-wide | **Yes** |
| Single `.asp` page | No — direct to main is fine after local test |
| Documentation / inventory | No — no runtime effect |

**Why PR for web.config:** A bad web.config takes down every page instantly. A PR gives a review checkpoint before the GoDaddy git integration auto-deploys.

---

## Testing Tools

Shared scripts in `tools/` — usable by any agent (Claude, Codex) or developer.

### Setup (once)
```bash
pip install -r tools/requirements.txt
playwright install chromium
```

### HTTP status checker
```bash
python tools/check-http.py              # production
python tools/check-http.py --local      # localhost:8081
```
Checks that key pages return 200, non-existent pages return 404 with the custom error page, and `/docs/` is blocked.
Exit code 0 = all passed, 1 = failures.

### Browser checker (Playwright)
```bash
python tools/browser-check.py              # production, headless
python tools/browser-check.py --local      # localhost:8081
python tools/browser-check.py --headed     # show browser window
python tools/browser-check.py --screenshot # save screenshots to tools/screenshots/
```
Loads pages in a real Chromium browser and checks:
- No IIS error screen ("Server Error", "HTTP Error", etc.)
- Nav bar is present (confirms inc/top.asp loaded)
- Key page text is present
- Custom 404 page is served (not the IIS default "File or directory not found")
- `/docs/` is blocked

### When to run
- After any change to `web.config` → run both scripts against production after deploy
- After editing an `.asp` page → run browser-check with `--local` to confirm no IIS error
- After merging to `main` → run both scripts against production to confirm deploy succeeded

---

## Documentation

- **`docs/file-inventory.csv`** — every file in the repo with metadata (size, lines, DB access, dependencies, feature area, can_delete, notes). Keep updated when files change.
- **`docs/pages/pages.md`** — structural documentation for each page: includes, SQL, query params, CSS, security notes. Documents code/logic/dependencies — not change history.

When modifying a file, update the relevant inventory row (lines, size_kb, description, notes).

---

## Key Patterns

### N+1 queries
`labels.asp` and `label.asp` run one COUNT query per label in a loop. This is a known pattern in the codebase — do not "fix" it without discussing it first, as the query volume is manageable at current scale.

### `prevID` deduplication
`label.asp` uses a `prevID` guard variable to skip duplicate word rows caused by `LEFT JOIN wordsMedia`.

### openDbLogger / closeDbLogger
Wrappers around DB open/close with timing. The timing result is not stored anywhere meaningful — timing-only code is dead code.
