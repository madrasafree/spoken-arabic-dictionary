# Pages Documentation

Page-by-page reference for all public and internal ASP pages in the site.

---

## about.asp

**URL:** https://milon.madrasafree.com/about.asp
**Feature area:** dictionary
**Auth:** public (no login required)
**DB access:** none (opens connection via `inc/inc.asp` but never queries)

### Structure

#### Includes

```
inc/inc.asp      ← DB connection + utility functions (required by inc/trailer.asp)
inc/header.asp   ← CSS/JS <link>/<script> tags, Google Analytics
inc/top.asp      ← navigation bar, session handling
inc/trailer.asp  ← footer, avatar query for logged-in users, closing </body></html>
```

These four includes are the **standard page wrapper** used by almost every public page.
Despite including `inc/inc.asp` (which opens a DB connection), this page never queries the DB.
The connection is kept because `inc/trailer.asp` uses it to load the avatar for logged-in users.

> **Classic ASP rule:** `<!--#include file="inc/inc.asp"-->` MUST be the very first line of the
> file. Never place any content (even an HTML comment) before it — doing so breaks
> `Option Explicit` in `inc/inc.asp` with VBScript error 800a0400.

#### Page-specific CSS

Inline `<style>` block in `<head>`. Classes defined:

| Class | Purpose |
|---|---|
| `.divStats` | Centers content blocks |
| `.table` | Constrains block width to `min(90%, 500px)` |
| `.body-text` | `line-height: 1.4em` for paragraph divs |
| `.note` | `font-size: small` for fine-print descriptions |
| `.text-right` | `text-align: right` (Hebrew history section, copyright list) |
| `.underlink` | `text-decoration: underline` (external link to Rothfarb portal) |
| `.contributors` | Indented contributor list (`padding-right: 15px; margin-top: 10px`) |
| `.word-check-icon` | Correct-mark image (`width: 15px; opacity: 0.4`) |
| `.section-gap` | `margin-top: 80px` before the copyright heading |
| `#copyrights+div b` | Underlines category labels in copyright list |
| `#copyrights+div li` | Adds spacing between copyright list items |

### Content Sections

| Lines | Topic |
|---|---|
| ~45–50 | What the dictionary is (free service for Hebrew speakers learning spoken Arabic) |
| ~52–66 | History: founded 2005 by Ronen Rothfarb, transferred to Madrasa NGO in 2022; contributor credits |
| ~68–74 | Who adds words — community-sourced (like Wikipedia) |
| ~76–85 | Who reviews words — veteran users; **stat hardcoded to Jan 2020 (96% reviewed)** |
| ~87–96 | Future plans — links to `team.tasks.asp` |
| ~98–105 | Usage numbers — **hardcoded 2021 stats** (996,000 sessions, 4.8M page views); links to `stats.asp` |
| ~107–160 | Copyright section — text, images (Wikimedia, Ronen), video (YouTube/arabic4hebs), audio |

### Migration Notes

1. **No server-side logic** — purely static content. Can be migrated to a plain HTML template or a CMS page with zero backend changes needed.
2. **DB connection overhead** — `inc/inc.asp` opens a connection that this page never uses. In the new stack, a static page won't open a DB connection at all, eliminating this overhead.
3. **No auth dependency** — page is fully public. No session logic required (the nav bar reads session vars but degrades gracefully for anonymous users).

---

## labels.asp

**URL:** https://milon.madrasafree.com/labels.asp
**Feature area:** dictionary
**Auth:** public (no login required)
**DB access:** arabicWords — `labels`, `wordsLabels`

### Purpose

Renders a tag cloud of all label (topic) categories. Each label appears as a clickable link; its font size scales with the number of words in that label. Clicking a label navigates to `label.asp`.

### Includes

```
inc/inc.asp      ← DB connection + utilities
inc/header.asp   ← CSS/JS (already loads jQuery 1.11.3)
inc/top.asp      ← nav bar
inc/trailer.asp  ← footer
```

**Duplicate script load** (line 18): `<script src=".../jquery.min.js">` is loaded explicitly in this page, redundant with `inc/header.asp` line 24. jQuery ends up loaded twice.

### Query params

| Param | Values | Effect |
|---|---|---|
| `?order=` | `a` / `e` / `h` | **Declared but never used** — SQL is hardcoded to `ORDER BY labelName` regardless |

### SQL

Two queries execute per page load:

1. `SELECT * FROM labels ORDER BY labelName` — fetches all labels
2. For each label row: `SELECT count(wordID) FROM wordsLabels WHERE labelID=X` — **N+1 pattern**: one extra COUNT query per label

### Font-size scale

| Word count | Font size |
|---|---|
| 0–10 | 0.8em |
| 11–30 | 1em |
| 31–70 | 1.3em |
| 71–120 | 1.5em |
| 121–180 | 1.7em |
| 181–300 | 1.9em |
| 300+ | 2.4em |

### Dead code

| Type | Location | Detail |
|---|---|---|
| Variable | Line 2 | `nikud` — declared, set to `""`, never read |
| Variable | Lines 3–8 | `order` — populated from `?order=` query param, but never used in any SQL |
| Variable | Line 9 | `countMe` — declared, never incremented or output |
| Duplicate script | Line 18 | jQuery already loaded by `inc/header.asp` |
| CSS class | Line 20 | `.tag` — defined but never applied to any element (the `<li>` tags only use inline `font-size`) |

### Links to

- `label.asp?id=X` — individual label word list

---

## label.asp

**URL:** https://milon.madrasafree.com/label.asp?id=X
**Feature area:** dictionary
**Auth:** public (no login required)
**Required param:** `?id=` (label ID — integer, no validation)
**DB access:** arabicWords — `labels`, `wordsLabels`, `words`, `wordsMedia`

### Purpose

Displays all words belonging to a given label. Shows the same tag cloud as `labels.asp` (collapsed by default with a toggle), then the word list for the selected label with status icons and links to `word.asp`.

### Includes

```
inc/inc.asp                  ← DB connection + utilities
inc/functions/functions.asp  ← isAndroid() + showShada() — included but never called here
inc/header.asp               ← CSS/JS including jQuery
inc/top.asp                  ← nav bar
inc/trailer.asp              ← footer
```

### Query params

| Param | Values | Effect |
|---|---|---|
| `?id=` | integer | **Required.** Label ID. Used directly in SQL — see Security below. |
| `?order=` | `e` / `h` (default: `arabicWord`) | Sort order for the word list (`e`=pronunciation, `h`=Hebrew translation) |

### SQL

1. Fetch label name: `SELECT labelName FROM labels WHERE id=` + LID
2. Tag cloud N+1 (same as `labels.asp`): `SELECT * FROM labels` + N × `SELECT count(wordID) FROM wordsLabels WHERE labelID=X`
3. Word list: `SELECT DISTINCT words.id, words.arabic, words.arabicWord, words.hebrewTranslation, words.hebrewDef, words.pronunciation, words.status, words.imgLink, wordsLabels.labelID, wordsMedia.mediaID FROM (words INNER JOIN wordsLabels ON words.id = wordsLabels.wordID) LEFT JOIN wordsMedia ON words.id = wordsMedia.wordID WHERE show AND wordsLabels.labelID=LID ORDER BY <order>`

The `LEFT JOIN wordsMedia` means a word with multiple media rows can appear more than once even with `DISTINCT`. The `prevID` guard (line 146) deduplicates at render time — only the first occurrence of each word ID is output.

### Word status display

| `status` value | Rendered as |
|---|---|
| `1` | Green checkmark icon — reviewed OK |
| `-1` | Red badge "ערך בבדיקה" — under review |
| other | Orange badge "טרם נבדק" — not yet reviewed |

### Page-specific CSS

| Selector | Purpose |
|---|---|
| `#lingolearn button:hover` | **Dead** — `#lingolearn` never appears in the page HTML |
| `#hide`, `#unhide` | Tag cloud toggle buttons |
| `.eng`, `.heb` | Word entry column layout |
| `.pos`, `.def` | Part-of-speech and definition inline display |
| `.result` | Word card background, border, hover state |
| `.icons`, `.correct`, `.imgLink`, `.audio`, `.erroneous` | Status and media icon positioning |
| `@media (max-width: 600px)` | Stacks `.eng`/`.heb` columns on narrow screens |

### Dead code

| Type | Location | Detail |
|---|---|---|
| Dead CSS | Lines 38–40 | `#lingolearn button:hover` — `#lingolearn` element does not exist in this page |
| Commented JS | Line 180 | `document.title = ...` — permanently commented out |
| Unused include | Line 2 | `inc/functions/functions.asp` — `isAndroid()` and `showShada()` are never called |
| Meta casing | Line 34 | `name="Description"` — should be lowercase `name="description"` (HTML spec) |

### Security

**SQL injection** (lines 23 and 142): `LID = Request("id")` is concatenated directly into SQL strings with no type-checking or parameterization. A crafted `?id=` value can inject arbitrary SQL against the `arabicWords` database.

### OG image

`<meta property="og:image" content=".../img/labels/<LID>.png" />` — expects one image per label ID in `img/labels/`. If the image is missing, social share previews will be broken for that label.

### Links to

- `label.asp?id=X` (self — tag cloud links)
- `word.asp?id=X` — each word card links to its word page