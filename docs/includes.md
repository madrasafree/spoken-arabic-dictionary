# Shared Include Files

Documentation for all files pulled into pages via `<!--#include file="...">`.
These are not pages themselves — they provide shared code, markup, or content.

For DB schema see `docs/db.md`. For page behavior see `docs/pages.md`.

---

## Include Map

| File | Type | Included by |
|---|---|---|
| `inc/inc.asp` | Core bootstrap | Every .asp page |
| `inc/header.asp` | HTML `<head>` | Every public page |
| `inc/top.asp` | Navigation + search | Every public page |
| `inc/trailer.asp` | Footer + `</body>` | Every public page |
| `inc/time.asp` | Date/time helpers | ~35 pages |
| `inc/functions/functions.asp` | Android shada fix | ~15 pages |
| `inc/functions/string.asp` | String utilities | ~10 pages |
| `inc/functions/soundex.asp` | Phonetic search | 3 pages (buggy — see note) |
| `inc/banner.asp` | Promotional banner | `default.asp`, `word.asp` |
| `inc/topTeam.asp` | Team nav bar | `team/default.asp`, `team/media*.asp` |
| `team/inc/functions.asp` | Android shada fix | `guide.asp` |
| `team/inc/functions/string.asp` | String utilities (duplicate) | `default.asp`, `default.min.asp`, 2 task pages |
| `team/inc/functions/soundex.asp` | Phonetic search (correct version) | `default.asp`, `default.min.asp`, `team/edit.update.asp`, `team/new.insert.asp` |
| `team/inc/time.asp` | Date/time helpers (superset) | `profile.asp`, `welcome.asp` |
| `team/guide.embed.asp` | Guide body content | `guide.asp`, 4 word/sentence edit pages |
| `team/guide.embed.nikud.asp` | Hebrew vowel guide | 4 word/sentence edit pages |

---

## `inc/inc.asp`

**Type:** core bootstrap
**Must be:** first line of every `.asp` file — before any whitespace or HTML output

### Purpose

Sets up the VBScript environment and all shared ADODB objects used by every page.
Violating the "must be first" rule causes VBScript error 800a0400 (`Option Explicit`).

### Global variables declared

| Variable | Purpose |
|---|---|
| `con` | Active ADODB.Connection |
| `res`, `res2`, `res3` | Shared ADODB.Recordset handles |
| `cmd` | Shared ADODB.Command |
| `mySQL` | Reusable SQL string variable |
| `startTime`, `endTime`, `durationMs` | Used by logger wrapper parameters |

### Functions

**`OpenDB(db)`**
Creates all ADODB objects and opens `App_Data/<db>.mdb` using the Jet 4.0 provider.

**`closeDB()`**
Releases all ADODB objects by setting them to `Nothing`.

**`Go(url)`**
Closes the DB if open, releases objects, then redirects to `url`.
Used for safe post-action redirects (e.g. after INSERT or UPDATE).

**`OpenDbLogger(db, opType, afPage, opNum, sStr)`**
Wrapper around `OpenDB`. The SQL INSERT to a log table is permanently commented out — no logging is written.

**`CloseDbLogger(db, opType, afPage, opNum, durationMs, sStr)`**
Wrapper around `closeDb`. The log INSERT is also commented out.

**`intToStr(num, length)`**
Pads a number to a fixed string length with leading zeros.
Example: `intToStr(5, 2)` → `"05"`. Used internally by `AR2UTC`.

**`AR2UTC(date)`**
Converts an Arizona server timestamp (UTC−7) to an ISO 8601 UTC string.
Adds 7 hours, then formats as `YYYY-MM-DDTHH:MM:SSZ`.

### Used by

Every `.asp` page in the project.

---

## `inc/header.asp`

**Type:** shared HTML `<head>` content

### Purpose

Outputs everything that goes inside `<head>`: meta tags, CSS links, JS libraries,
and Google Analytics. Also reads and immediately clears the session flash message.

### Variables declared

| Variable | Purpose |
|---|---|
| `msg` | Flash message read from `Session("msg")`, cleared immediately |
| `q`, `qFix`, `bColor` | Declared here; used by some pages for search/display state |

### What it outputs

- OpenGraph meta tags (site name, locale, Facebook app ID)
- Viewport meta tag
- CSS: `normalize.css`, `nav.css`, `arabic_constant.css`, four responsive breakpoint files
- Favicon and `<link rel="image_src">` preview image
- Google Material Icons font (via CDN)
- jQuery 1.11.3 (via Google CDN)
- Google Analytics gtag snippet (property `G-3KCSSVHC9Z`)

### Used by

Every public-facing `.asp` page.

---

## `inc/top.asp`

**Type:** navigation bar and search input

### Purpose

Renders the top navigation bar and search box. Also normalizes the search query
from `request("searchString")` before the page body runs.

### Search input processing

Reads `request("searchString")` and produces three variables:

| Variable | Content |
|---|---|
| `strInput` | Raw input from request |
| `strDisplay` | Input after `gereshFix()` + trim + strip non-breaking spaces |
| `strClean` | Letters only — via `onlyLetters()` from `inc/functions/soundex.asp` |

Note: `gereshFix()` normalizes many Unicode apostrophe/quote variants to the
Hebrew geresh (`׳`) and gershayim (`״`) characters. This is defined here but
noted in a comment as "should be moved to `inc/functions/string.asp`".

### What it outputs

- Fixed top bar with logo and hamburger menu button
- Sidebar navigation menu (hidden by default, toggled by `toggleMenu()`)
- Search form with keyboard submit

### Functions declared

**`gereshFix(str)`**
Replaces Unicode apostrophe/quote variants with Hebrew geresh/gershayim.
Variants handled: `'`, `` ` ``, `'`, `'`, `‚`, `′`, `"`, `"`, `„`, `‟`, `″`, `＇`.

### DB access

Queries `arabicWords` (labels for nav), `arabicManager` (tasks count).

### Used by

Every public-facing `.asp` page.

---

## `inc/trailer.asp`

**Type:** page footer and closing tags

### Purpose

Outputs the page footer, `</body>`, and `</html>`. For logged-in users (role > 2),
also shows a profile avatar and quick word-add link.

### What it outputs

- Clock widget (`#showTime`) — clicking navigates to `clock.asp`
- Avatar image and profile/word-add links for logged-in contributors
- `toggleMenu()` / `showEmail()` / `hideEmail()` inline scripts
- `<script src="inc/functions/saa3a.js?v=3">` — Arabic keyboard/input helper

### DB access

For logged-in users only: `SELECT username, picture, gender FROM users WHERE id=<session userID>`
Opens `arabicUsers` via `openDbLogger` / `closeDbLogger`.

### Functions declared

**`toggleMenu()`** — toggles `#nav` display between `"table"` and `"none"`.
**`showEmail()` / `hideEmail()`** — show/hide an obfuscated email image on hover.

### Used by

Every public-facing `.asp` page.

---

## `inc/time.asp`

**Type:** date/time helper functions

### Purpose

Provides date formatting and human-readable time-ago functions.
Included by any page that needs to display timestamps or relative dates.

### Functions

**`isrTime()`** *(deprecated — replaced by `AR2UTC`)*
Adds 9 hours to server time to produce Israel local time.
Only worked on a now-defunct dev server (`ronen.*`); comment explicitly says it is replaced.

**`iso2nums(str)`**
Strips separators from an ISO 8601 string, leaving only the digits.
Example: `"2021-04-13T10:30:00Z"` → `"20210413103000"`. Used to sort dates as numbers.

**`dateToStrISO8601(date)`**
Formats a VBScript Date as `YYYY-MM-DDTHH:MM:SSZ` (no UTC conversion).
Same format as `AR2UTC` but does not shift the timezone.

**`dateToStr(date)`** *(deprecated — replaced by `dateToStrISO8601`)*
Formats date as `YYYY-MM-DD HH:MM:SS` (space separator, no `T` or `Z`).

**`secPast(date1, date2)`**
Computes a Hebrew human-readable "time ago" label.
Uses `response.write` directly.

| Threshold | Output example |
|---|---|
| < 60s | `"לפני X שניות"` |
| < 2min | `"לפני דקה"` |
| < 1hr | `"לפני X דקות"` |
| < 2hr | `"לפני שעה"` |
| < 3hr | `"לפני שעתיים"` |
| < 24hr | `"לפני X שעות"` |
| < 2 days | `"אתמול"` |
| < 3 days | `"שלשום"` |
| < 5 days | weekday name |
| < 32 days | day + month name |
| < 96 days | month name |
| < 385 days | year number |
| else | error string |

**`Str2hebDate(strDate)`**
Formats an ISO 8601 date string as a Hebrew date (`DD לחודש YYYY`).
Uses `response.write` directly. Months are hardcoded Hebrew month names.

### Used by

~35 pages including `activity.asp`, `admin.asp`, all `admin.searchHistory.*` pages,
`word.asp`, `word.edit.asp`, `login.asp`, `lists.asp`, `profile.allwords.asp`.

### Notes

- `isrTime()` and `dateToStr()` are dead — both explicitly marked as replaced.
- `secPast()` and `Str2hebDate()` write to the response directly (unusual pattern).

---

## `team/inc/time.asp`

**Type:** date/time helpers — superset copy

### Purpose

Identical to `inc/time.asp` plus an additional copy of `intToStr` and `AR2UTC`
(which are normally provided by `inc/inc.asp`). Exists because `team/*.asp` handlers
that do not include `inc/inc.asp` still need time utilities.

### Difference from `inc/time.asp`

Adds `intToStr()` and `AR2UTC()` — which are already in `inc/inc.asp`.
This makes the file standalone for contexts where `inc/inc.asp` is not available.

### Used by

`profile.asp`, `welcome.asp` (alongside `inc/inc.asp` — the extra functions are
just unused duplicates in those pages).

---

## `inc/functions/functions.asp`

**Type:** Android rendering helper

### Purpose

Provides Android-specific rendering for Arabic shada (shadda) characters.
On Android, the standard shada Unicode point (`U+0651`) renders poorly,
so it can be swapped for the Presentation Form B variant (`U+FB1E`).

### Functions

**`isAndroid()`**
Returns `True` if `HTTP_USER_AGENT` contains `"android"` (case-insensitive).

**`showShada(word)`**
On Android: replaces `U+0651` (shada) with `U+FB1E` (Hebrew point varika form).
Otherwise returns the word unchanged.

### Used by

`dashboard.lists.asp`, `default.asp`, `games.mem.asp`, `games.mem.list.asp`,
`games.mem.pics.asp`, `json.asp`, `label.asp`, `lists.all.json.asp`, `lists.asp`,
`sentence.asp`, `sentenceEdit.asp`, `sentenceNew.asp`, `sentences.asp`,
`team.task.new.insert.asp`, `word.asp`, `word.edit.asp`, `word.history.asp`, `word.new.asp`.

### Notes

`team/inc/functions.asp` contains identical logic. Both exist because root pages
and team pages were written with separate include paths at different times.

---

## `team/inc/functions.asp`

**Type:** Android rendering helper (guide-specific copy)

### Purpose

Same as `inc/functions/functions.asp` — provides `isAndroid()` and `showShada()`.
Exists as a separate copy because `guide.asp` and the guide embed predated
the move to `inc/functions/`.

### Used by

`guide.asp` (directly), and implicitly through `team/guide.embed.asp` which calls
`showShada()` — that function must be in scope when the embed is rendered.

---

## `inc/functions/string.asp`

**Type:** string manipulation utilities

### Purpose

SQL-safe string escaping, apostrophe normalization, and text cleanup functions
for user-entered Arabic and Hebrew text.

### Functions

**`displayToSqlQuery(str)`**
Prepares a user-entered string for use in a SQL query:
1. Replaces each `'` with `''` (SQL-safe escaping)
2. Strips non-breaking space (`U+00A0 / ChrW(160)`)
3. Trims whitespace

**`gereshFix(str)`**
Normalizes various Unicode apostrophe/quote characters to the standard
Hebrew geresh (`׳`, `U+05F3`) and gershayim (`״`, `U+05F4`).
Handled variants: `'`, `` ` ``, `'`, `'`, `‚`, `′`, `‵`, `＇` → geresh;
`"`, `"`, `"`, `„`, `‟`, `″` → gershayim.

**`getString(f)`** *(deprecated)*
Older SQL-escape helper: just replaces `'` with `''`.
Kept for `team/edit.update.asp` label queries. Should be replaced by `displayToSqlQuery`.

### Used by

`inc/topTeam.asp`, `json.asp`, `lists.all.json.asp`, `sentenceNew.insert.asp`,
`team.task.new.insert.asp`, `word.edit.asp`.

### Notes

`team/inc/functions/string.asp` is an **identical** copy. The comment in the file
reads `{MOVE BACK TO FUNCTIONS/STRING.ASP AFTER DIRECTORY SORTING}` — this
directory sorting was never done and both copies still exist.

---

## `team/inc/functions/string.asp`

**Type:** string manipulation utilities (duplicate)

### Purpose

Identical content to `inc/functions/string.asp`. Same functions:
`displayToSqlQuery()`, `gereshFix()`, `getString()`.

### Used by

`default.asp`, `default.min.asp`, `team.task.edit.update.asp`, `team.task.vote.asp`.

### Notes

This is an exact duplicate of `inc/functions/string.asp`. The file itself contains
a comment: `{MOVE BACK TO FUNCTIONS/STRING.ASP AFTER DIRECTORY SORTING}`.
Both files should eventually be consolidated into one.

---

## `inc/functions/soundex.asp`

**Type:** phonetic search normalization (buggy version)

### Purpose

Provides `onlyLetters()` to strip non-letter characters from Hebrew/Arabic text,
and `soundex()` to produce a phonetic key used for fuzzy search matching.

### Functions

**`onlyLetters(str)`**
Strips everything except Hebrew letters (`א–ת`), Arabic letters (`ؠ–ي`, etc.),
digits, and a set of apostrophe variants. Normalizes those apostrophes to Hebrew geresh.
Uses regex (`RegExp`) with `Global = True`.

**`soundex(str)`**
Produces a phonetic representation by mapping each letter to a consonant class:
- `א`,`ו`,`י` at position 1 → `A`, `W`, `Y`
- `ב`,`ב` → `B`; `ג`/`ج` → `K` (or `J` with geresh); `ד`/`د`,`ذ`,`ض` → `D`
- `ה`,`ח`/`ه`,`ح`,`خ` → `H`; `ז`/`ز` → `S` (or `J` with geresh)
- `ט`/`ط`,`ت`,`ת`,`ث` → `T` (or `S` with geresh); `כ`,`ך`/`ك`,`ق`,`ק` → `K`
- `ל`/`ل` → `L`; `מ`,`ם`/`م` → `M`; `נ`,`ן`/`ن` → `N`; `ס`/`ص`,`س`,`ظ` → `S`
- `ע`/`ع` → `A` (or `R` with geresh); `פ`,`ף`/`ف` → `F`; `צ`,`ץ` → `S` (or `D`)
- `ר`/`ر`,`غ` → `R`; `ש`,`ש`/`ش`,`ج` → `J`

### Used by

`sentenceEdit.update.asp`, `sentenceNew.insert.asp`.
Also used indirectly via `inc/top.asp` which calls `onlyLetters()`.

### Bug

The `soundex()` function receives raw input but does **not** call `onlyLetters()`
on it before processing. This means punctuation and non-letter characters can
produce incorrect soundex keys. The `team/inc/functions/soundex.asp` version
fixes this by calling `ltrs = onlyLetters(input)` first.

---

## `team/inc/functions/soundex.asp`

**Type:** phonetic search normalization (correct version)

### Purpose

Same as `inc/functions/soundex.asp` — provides `onlyLetters()` and `soundex()`.

### Key difference from `inc/functions/soundex.asp`

The `soundex()` function correctly calls `onlyLetters(input)` on its input before
processing: `ltrs = onlyLetters(input)`. The `inc/functions/soundex.asp` version
uses `ltrs = input` (bug — does not clean input first).

### Used by

`default.asp`, `default.min.asp`, `team/edit.update.asp`, `team/new.insert.asp`.

### Notes

The file itself is marked `'DUPLICATE FILES!!! also under inc folder`.
Both copies exist because of the old `team/inc/` vs `inc/` directory split.
The `default.asp` (main search) correctly uses this version.

---

## `inc/banner.asp`

**Type:** promotional banner embed

### Purpose

A self-contained HTML+CSS block advertising Madrasa Free Arabic courses.
Renders a responsive banner with a logo, tagline, and CTA button.
No ASP or VBScript — pure HTML and CSS.

### What it outputs

A full-width banner (`<section class="madrasa-banner-wrapper">`) with:
- Madrasa logo (from `madrasafree.com`)
- Headline: *"מדרסה – לומדים לתקשר בערבית"*
- Subtext: *"קורסים לכל הרמות. הירשמו עכשיו!"*
- CTA button linking to `madrasafree.com/our-courses/zoom?utm_source=...`

Responsive: on mobile (≤768px) the layout collapses to vertical stacking.

### Used by

`default.asp`, `word.asp`.

---

## `inc/topTeam.asp`

**Type:** team navigation bar (for team/* pages accessed from root)

### Purpose

Renders the navigation bar shown on team pages that are served from the root
folder (`team.tasks.asp`, `team.task.*.asp`, etc.). These pages use `inc/top.asp`
for the standard public bar and then `inc/topTeam.asp` to add a team-specific
search bar and breadcrumb.

Includes `inc/functions/string.asp` itself (for `gereshFix()` used in the search input).

### What it outputs

- Profile avatar image for logged-in contributors (role > 2), or a generic menu icon
- Top search bar with submit button
- Slide-out navigation menus (user menu + main site links)
- Breadcrumb showing current page title
- Site logo linking to `default.asp`

### DB access

For logged-in users: `SELECT username, picture, gender FROM users WHERE id=<session userID>`
Opens `arabicUsers` via `openDbLogger` / `closeDbLogger`.

### Used by

`team/default.asp`, `team/mediaControl.asp`, `team/mediaEdit.asp`, `team/mediaNew.asp`.

---

## `team/guide.embed.asp`

**Type:** embedded guide content

### Purpose

The full body of the transliteration/pronunciation guide:
28-consonant table, vowel table, shada section, definite article rules, and
special characters. Each row shows the Arabic character, Hebrew transliteration
label, and an inline audio player (linking to Wikimedia `.ogg` files).

Uses `showShada()` from `team/inc/functions.asp` for Android-aware shada rendering.

### Structure

| Section | Content |
|---|---|
| Consonants | 28-row table with Arabic letter, transliteration, audio player |
| Vowels | Short vowels (fatha, kasra, damma) and long vowels |
| Shada | Gemination marker with Android-aware rendering |
| Definite article | Rules for sun/moon letters (`ال`) |
| Extra characters | Non-standard letters used in loanwords |

### Used by

`guide.asp`, `word.new.asp`, `word.edit.asp`, `sentenceNew.asp`, `sentenceEdit.asp`.

---

## `team/guide.embed.nikud.asp`

**Type:** embedded reference content

### Purpose

A compact keyboard shortcut guide for typing Hebrew nikud (vowel diacritics).
No ASP/VBScript — pure HTML with a table layout.

Covers two Windows input methods:
- **Windows 10**: Right Alt key combinations
- **Windows 7**: Caps Lock + Shift combinations

Shows the key to press and the resulting nikud character (e.g. `כְ`, `כֱ`, `כִ`).

### Used by

`word.new.asp`, `word.edit.asp`, `sentenceNew.asp`, `sentenceEdit.asp`.
Shown inside a collapsible tab next to `team/guide.embed.asp`.

---

## Dead files — `inc/`

These files exist in `inc/` but are **not included anywhere** in the active codebase.

| File | Description | Why it's dead |
|---|---|---|
| `inc/top_admin.asp` | Admin nav bar with links to `userControl.asp`, `loginHistory.asp`, etc. | Never referenced via `#include` in any active page |
| `inc/header2016x.asp` | Legacy 2016 `<head>` include | Not included anywhere; superseded by `inc/header.asp` |
| `inc/header_admin.asp` | Admin `<head>` stub (links to `inc/arabicManager.css`) | Not included anywhere |
| `inc/inc_admin.asp` | Old bootstrap with hardcoded local IP (`127.0.0.1`) | Not included anywhere; superseded by `inc/inc.asp` |
| `inc/inc_onlineNEW.asp` | Old bootstrap with production URL hardcoded | Not included anywhere |
| `inc/inc_sql.asp` | SQL Server connection variant (never deployed) | Not included anywhere; uses SQLNCLI11 provider |
| `inc/top.links.asp` | Sub-nav sidebar for the links section pages | Not included anywhere |
| `inc/top.temp.asp` | Experimental top bar (inline `gereshFix`, grid layout) | Not included anywhere; condition always false (`instr(url,"xxx.asp")`) |
| `inc/topNav.asp` | 2022 redesign top bar (jQuery-based hamburger) | Not included anywhere; was a redesign candidate never merged |
| `inc/trailer.2022.asp` | 2022 redesign footer (multi-column nav, JS-based clock) | Not included anywhere; was a redesign candidate never merged |

---

## Dead files — `team/inc/`

These `team/inc/*.asp` files exist but are **not included by any active page**.
All active `team/*.asp` pages use root-level `inc/` includes (`inc/inc.asp`,
`inc/header.asp`, etc.) — not the copies in `team/inc/`.

| File | Description |
|---|---|
| `team/inc/inc.asp` | Old bootstrap with hardcoded `baseA` URL |
| `team/inc/header.asp` | Old `<head>` include with `baseA`-prefixed CSS paths |
| `team/inc/top.asp` | Old nav bar with `baseA`-prefixed image paths |
| `team/inc/trailer.asp` | Old footer with `baseA`-prefixed image paths |
| `team/inc/topTeam.asp` | Small team toolbar (3 links only) |
| `team/inc/inc_online.asp` | Old bootstrap pinned to `ronen.rothfarb.info` URL |

These files appear to have been the original team-section includes when `team/*.asp`
pages were in a separate virtual directory. After the consolidation into a single
root deploy, the team pages switched to root-relative `inc/` includes and these
copies were left behind.

---

## Dead code within active files

| File | Issue |
|---|---|
| `inc/time.asp` | `isrTime()` — explicitly comments "REPLACED BY AR2UTC"; condition checks a non-existent dev server |
| `inc/time.asp` | `dateToStr()` — explicitly comments "REPLACED by dateToStrISO8601" |
| `inc/functions/soundex.asp` | `soundex()` does not call `onlyLetters()` on its input; the correct version is `team/inc/functions/soundex.asp` |
| `inc/functions/string.asp` | `getString()` is labeled "older function"; `displayToSqlQuery()` is the replacement |
| `team/inc/time.asp` | `intToStr()` and `AR2UTC()` duplicate what `inc/inc.asp` already provides |

---

## Duplicates

Two pairs of files have identical content and should eventually be consolidated:

| Pair | Status |
|---|---|
| `inc/functions/string.asp` ↔ `team/inc/functions/string.asp` | Byte-for-byte identical. Both needed because different pages use different include paths. |
| `inc/functions/functions.asp` ↔ `team/inc/functions.asp` | Same functions (`isAndroid`, `showShada`), slightly different file names. |

One pair has different implementations (one buggy, one correct):

| Pair | Status |
|---|---|
| `inc/functions/soundex.asp` ↔ `team/inc/functions/soundex.asp` | Different: `inc/` version has a bug (doesn't sanitize input). The `team/inc/` version is correct and used by `default.asp`. |
