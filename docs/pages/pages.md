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
**Auth:** public
**DB access:** arabicWords — `labels`, `wordsLabels`

### Purpose

Tag cloud of all label (topic) categories. Font size of each label scales with the number of words it contains. Clicking navigates to `label.asp`.

### Includes

```
inc/inc.asp      ← DB connection + utilities
inc/header.asp   ← CSS/JS including jQuery
inc/top.asp      ← nav bar
inc/trailer.asp  ← footer
```

### SQL

1. `SELECT * FROM labels ORDER BY labelName` — all labels alphabetically
2. For each label: `SELECT count(wordID) FROM wordsLabels WHERE labelID=X` — **N+1 pattern**: one COUNT query per label

### Font-size scale (word count → CSS font-size)

| Word count | Font size |
|---|---|
| 0–10 | 0.8em |
| 11–30 | 1em |
| 31–70 | 1.3em |
| 71–120 | 1.5em |
| 121–180 | 1.7em |
| 181–300 | 1.9em |
| 300+ | 2.4em |

### Links to

- `label.asp?id=X`

---

## label.asp

**URL:** https://milon.madrasafree.com/label.asp?id=X
**Feature area:** dictionary
**Auth:** public
**Required param:** `?id=` (label ID — integer, no validation)
**DB access:** arabicWords — `labels`, `wordsLabels`, `words`, `wordsMedia`

### Purpose

Displays all words in a given label. Top of page has the same tag cloud as `labels.asp` (collapsed by default, toggled by "הצג רשימת נושאים"). Below that is the word list for the selected label, with status icons and links to `word.asp`.

### Includes

```
inc/inc.asp                  ← DB connection + utilities
inc/functions/functions.asp  ← isAndroid() / showShada() for Android Arabic rendering
inc/header.asp               ← CSS/JS including jQuery
inc/top.asp                  ← nav bar
inc/trailer.asp              ← footer
```

### Query params

| Param | Values | Default | Effect |
|---|---|---|---|
| `?id=` | integer | — | **Required.** Which label to show. |
| `?order=` | `e` / `h` | `arabicWord` | Sort word list by pronunciation (`e`) or Hebrew translation (`h`) |

### SQL

1. `SELECT labelName FROM labels WHERE id=` + LID — fetch current label name for the page title
2. Tag cloud N+1 (same as `labels.asp`): `SELECT * FROM labels` + N × `SELECT count(wordID) FROM wordsLabels WHERE labelID=X`
3. Word list: `SELECT DISTINCT words.id, words.arabic, words.arabicWord, words.hebrewTranslation, words.hebrewDef, words.pronunciation, words.status, words.imgLink, wordsLabels.labelID, wordsMedia.mediaID FROM (words INNER JOIN wordsLabels ...) LEFT JOIN wordsMedia ... WHERE show AND wordsLabels.labelID=LID ORDER BY <order>`

The `LEFT JOIN wordsMedia` can produce duplicate word rows when a word has multiple media entries. `DISTINCT` reduces but doesn't eliminate them; a `prevID` guard in the render loop skips any repeated word ID.

### Word status icons

| `status` value | Display |
|---|---|
| `1` | Green checkmark — reviewed OK |
| `-1` | Red "ערך בבדיקה" badge — under review |
| other | Orange "טרם נבדק" badge — not yet reviewed |

### Page-specific CSS

| Selector | Purpose |
|---|---|
| `#hide`, `#unhide` | Toggle buttons for the tag cloud |
| `.eng`, `.heb` | Column layout for word entries |
| `.pos`, `.def` | Part-of-speech and definition inline display |
| `.result` | Word card styling |
| `.icons`, `.correct`, `.imgLink`, `.audio`, `.erroneous` | Status and media icon positioning |
| `@media (max-width: 600px)` | Stacks columns on narrow screens |

### Security

`LID = Request("id")` is concatenated directly into SQL with no type-checking or parameterization — SQL injection risk on both queries that use it (label name lookup and word list).

### OG image

`<meta property="og:image" content=".../img/labels/<LID>.png" />` — one image per label ID expected in `img/labels/`. Missing images break social share previews for that label.

### Links to

- `label.asp?id=X` (self — tag cloud links highlight current label)
- `word.asp?id=X` — each word card