# Shared Include Files

Documentation for files loaded via Classic ASP `#include`.
These files are shared infrastructure/components, not standalone public pages.

For DB schema see `docs/db.md`. For page behavior see `docs/pages.md`.

---

## Include Map

| File | Type | Primary usage |
|---|---|---|
| `includes/inc.asp` | Core bootstrap | First include in almost every ASP page |
| `includes/inc_online.asp` | Legacy bootstrap variant | Legacy/limited usage |
| `includes/inc_team.asp` | Team bootstrap variant | Team handlers / legacy team flows |
| `includes/header.asp` | Shared `<head>` block | Global CSS/JS/meta output |
| `includes/top.asp` | Main nav + search normalization | Global navigation |
| `includes/trailer.asp` | Footer + closing tags | Global footer/scripts |
| `includes/time.asp` | Date/time helpers | Pages rendering relative/ISO time |
| `includes/topTeam.asp` | Team toolbar strip | Team-area pages |
| `includes/banner.asp` | Promotional banner snippet | `default.asp`, `word.asp` |
| `includes/functions/functions.asp` | Android shada helpers | Word/list/sentence rendering |
| `includes/functions/string.asp` | String cleanup + SQL escaping helpers | Input normalization |
| `includes/functions/soundex.asp` | Search normalization + phonetic key helpers | Search/edit handlers |

Related embedded content in `team/`:
- `team/guide.embed.asp`
- `team/guide.embed.nikud.asp`

---

## `includes/inc.asp`

Core bootstrap include. Must be the first line in ASP pages that use it.

Responsibilities:
- Declares shared ADO objects (`con`, `res`, `res2`, `res3`, `cmd`) and common globals.
- Provides DB lifecycle wrappers (`openDbLogger` / `closeDbLogger`) used across the site.
- Provides shared utility helpers such as redirect helper (`Go`) and date formatting helpers (`intToStr`, `AR2UTC`).

---

## `includes/inc_online.asp`

Legacy bootstrap variant. Kept for compatibility with older flows.
Not the preferred include for new/updated pages.

---

## `includes/inc_team.asp`

Team bootstrap variant for team/admin flows.
Contains team-oriented shared setup and helper logic.

---

## `includes/header.asp`

Shared `<head>` output.

Responsibilities:
- Emits common meta tags and favicon/Open Graph metadata.
- Loads global CSS and JavaScript assets.
- Loads jQuery and Google Material Icons.
- Emits Google Analytics snippet.
- Handles one-shot flash message read/clear from session.

Used by root pages and subdirectories via `file`/`virtual` include paths.

---

## `includes/top.asp`

Main site navigation include.

Responsibilities:
- Renders the top navigation + menu/search UI.
- Normalizes `searchString` input (`strInput`, `strDisplay`, `strClean`).
- Reads labels/tasks counters for nav-related UI state.

---

## `includes/trailer.asp`

Global footer include.

Responsibilities:
- Renders footer widgets (clock/profile shortcuts).
- Loads final shared scripts near end-of-page.
- Closes page markup (`</body></html>`).
- For logged-in users, reads avatar/profile metadata from `arabicUsers`.

---

## `includes/time.asp`

Date/time helper functions used across multiple pages.

Key helpers:
- ISO string formatting
- relative "time ago" formatting
- Hebrew date rendering helpers

---

## `includes/topTeam.asp`

Team-only top strip rendered under the main nav on team pages.
Provides quick links for team workflows and environment visibility.

---

## `includes/banner.asp`

Standalone promotional snippet (HTML/CSS block) for Madrasa course CTA.
Used in selected public pages.

---

## `includes/functions/functions.asp`

Android rendering helpers for Arabic shada display behavior.
Main functions: `isAndroid()`, `showShada()`.

---

## `includes/functions/string.asp`

String normalization and SQL-escape helper collection.

Main functions:
- `displayToSqlQuery()`
- `gereshFix()`
- `getString()` (legacy)

---

## `includes/functions/soundex.asp`

Phonetic/normalization helpers for Hebrew/Arabic search.

Main functions:
- `onlyLetters()`
- `soundex()`

