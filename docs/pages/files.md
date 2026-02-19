# Shared Include Files

Documentation for files that are pulled into pages via `<!--#include file="...">`.
These are not pages themselves — they provide shared code, markup, or content.

See also:
- `docs/pages/pages.md` for page behavior
- `docs/pages/issues.md` for dead code and defects

---

## `inc/inc.asp`

**Type:** core bootstrap include
**Must be:** first line of every `.asp` file (before any whitespace or HTML)

### Purpose

Sets up the VBScript environment and all shared objects needed by every page.
Violating the "must be first" rule causes a VBScript `Option Explicit` error (800a0400).

### Global variables declared

| Variable | Type | Purpose |
|---|---|---|
| `con` | ADODB.Connection | Active DB connection |
| `res`, `res2`, `res3` | ADODB.Recordset | Shared recordset handles |
| `cmd` | ADODB.Command | Shared command object |
| `mySQL` | String | Reusable SQL string variable |
| `startTime`, `endTime`, `durationMs` | Timer vars | Used by logger wrappers |
| `userIP`, `opTime` | String | Captured in logger wrappers |

### Functions

**`OpenDB(db)`**
Opens the DB connection and creates all ADODB objects.
Opens the `.mdb` file at `App_Data/<db>.mdb` using the Jet 4.0 provider.

**`closeDB()`**
Releases all ADODB objects by setting them to `Nothing`.

**`Go(url)`**
Closes the DB connection if open, releases objects, then redirects to `url`.
Used for safe post-action redirects.

**`OpenDbLogger(db, opType, afPage, opNum, sStr)`**
Captures `userIP` and `opTime`, then calls `OpenDB`.
The SQL INSERT to a log table is commented out — no logging is written.

**`CloseDbLogger(db, opType, afPage, opNum, durationMs, sStr)`**
Same pattern as `OpenDbLogger` but on close. Also commented out.
Calls `closeDb` at the end.

**`intToStr(num, length)`**
Pads a number to a fixed string length with leading zeros.
Used internally by `AR2UTC`.

**`AR2UTC(date)`**
Converts an Arizona server timestamp (UTC−7) to an ISO 8601 UTC string.
Returns format: `YYYY-MM-DDTHH:MM:SSZ`.

### Used by

Every `.asp` page in the repository.

---

## `inc/header.asp`

**Type:** shared head section include

### Purpose

Outputs the `<head>` content that every public page needs: meta tags, CSS links,
JS libraries, and Google Analytics. Also reads and clears the session flash message.

### Variables declared

| Variable | Purpose |
|---|---|
| `msg` | Flash message read from `Session("msg")`, cleared immediately after read |
| `q`, `qFix`, `bColor` | Declared here; used by some pages for search/display state |

### What it outputs

- OpenGraph and Facebook meta tags (site name, locale, app ID)
- Viewport meta tag
- CSS links: `normalize.css`, `nav.css`, `arabic_constant.css`, responsive variants by width and height
- Favicon and link preview image
- Google Material Icons font (via Google Fonts CDN)
- jQuery 1.11.3 (via Google CDN)
- Google Analytics gtag snippet (property `G-3KCSSVHC9Z`)

### Used by

Every public-facing `.asp` page.

---

## `inc/top.asp`

**Type:** navigation and search include

### Purpose

Renders the top navigation bar and search box. Also normalizes the search input
from the `searchString` query parameter before the page body runs.

### Search input processing

Reads `request("searchString")` and runs it through:
1. `gereshFix()` — replaces various apostrophe/quote Unicode variants with the
   Hebrew geresh (`׳`) and gershayim (`״`) characters
2. Strips non-breaking spaces (`ChrW(160)`)
3. `onlyLetters()` — strips non-letter characters for the clean search string

Results stored in:
- `strInput` — raw input from request
- `strDisplay` — normalized for display
- `strClean` — letters only, for DB query

### Functions declared

**`gereshFix(str)`**
Normalizes apostrophes and quotes to Hebrew geresh/gershayim.
Handles many Unicode variants: `'`, `` ` ``, `'`, `'`, `‚`, `′`, `"`, `"`, `„`, etc.
Note: comment says this should be moved to `inc/functions/string.asp`.

### Used by

Every public-facing `.asp` page.

---

## `inc/trailer.asp`

**Type:** footer and closing tags include

### Purpose

Outputs the page footer, closes `</body>` and `</html>`.
For logged-in users (role > 2), also shows an avatar image and quick-add link.

### What it outputs

- Clock widget (`#showTime`) — clicking navigates to `clock.asp`
- Footer table with:
  - Avatar image (logged-in users only): queries `users` table for picture/gender
  - Quick word add link (logged-in users only): links to `word.new.asp`
  - Team login link: links to `users.landingPage.asp`
- Inline `toggleMenu()` script — toggles `#nav` between `table` and `none`
- `<script src="inc/functions/saa3a.js?v=3">` — Arabic keyboard / input helper

### DB access

For logged-in users only: `SELECT username, picture, gender FROM users WHERE id=<session userID>`
Uses `openDbLogger` / `closeDbLogger` wrappers (from `arabicUsers` DB).

### Functions declared

**`toggleMenu()`**
Toggles the `#nav` element's display between `"table"` and `"none"`.
Called by the hamburger menu button in `inc/top.asp`.

### Used by

Every public-facing `.asp` page.

---

## `team/inc/functions.asp`

**Type:** helper include for guide content

### Purpose

Provides Android-specific rendering for Arabic shada (shadda) characters.
On Android, the standard shada Unicode point (`U+0651`) renders poorly,
so it is swapped for the Presentation Form B variant (`U+FB1E`).

### Functions declared

**`isAndroid()`**
Returns `True` if the request's `HTTP_USER_AGENT` contains `"android"` (case-insensitive).

**`showShada(word)`**
If running on Android, replaces `U+0651` with `U+FB1E` in `word`.
Otherwise returns `word` unchanged.

### Used by

- `guide.asp` (directly)
- Team word/sentence edit and new pages (via guide embed)

---

## `team/guide.embed.asp`

**Type:** embedded content include

### Purpose

The full body of the transliteration/pronunciation guide:
consonant table, vowel table, shada section, definite article, and special characters.
Each row shows the Arabic character, Hebrew transliteration label, and an audio player.

### Structure

| Section | Content |
|---|---|
| Consonants | Table of Arabic consonants with Hebrew transliteration and audio |
| Vowels | Short and long vowels |
| Shada | Gemination marker, with Android-aware rendering via `showShada()` |
| Article | Definite article rules (sun/moon letters) |
| Extra characters | Non-standard characters used in loanwords |

### Embedded by

- `guide.asp` — public pronunciation guide page
- `team/word.new.asp`, `team/word.edit.asp`, `team/sentence.new.asp`, `team/sentence.edit.asp` — shown inline when editing words/sentences
