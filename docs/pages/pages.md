# Pages Documentation

Page-level documentation for selected public pages.

Documentation layout:
- `docs/pages/pages.md`: page behavior and logic
- `docs/pages/files.md`: included and embedded file documentation

---

## about.asp

**URL:** https://milon.madrasafree.com/about.asp  
**Feature area:** dictionary  
**Auth:** public  
**DB access (page code):** none

### Purpose

Public "About" page with project history, contributors, usage highlights, and copyright notes.

### Includes

```
inc/inc.asp      -> shared bootstrap and DB objects
inc/header.asp   -> shared head assets
inc/top.asp      -> top navigation
inc/trailer.asp  -> footer and closing tags
```

### Behavior

- No query parameters are read in `about.asp`.
- No SQL is executed in `about.asp` itself.
- Content is mostly static Hebrew text with inline CSS in the page.

### Content blocks

- Project description
- Project history and contributors
- Community contribution model
- Review process note
- Future plans link (`team.tasks.asp`)
- Usage numbers section
- Copyright section

### Notes

- Usage/review percentages are hardcoded text values.
- DB connection is opened through includes, but the page body itself is static.

---

## labels.asp

**URL:** https://milon.madrasafree.com/labels.asp  
**Feature area:** dictionary  
**Auth:** public  
**DB access:** `arabicWords` (`labels`, `wordsLabels`)

### Purpose

Renders a labels tag cloud where font size indicates label popularity.

### Includes

```
inc/inc.asp      -> shared bootstrap and DB objects
inc/header.asp   -> shared head assets
inc/top.asp      -> top navigation
inc/trailer.asp  -> footer and closing tags
```

### Query behavior

1. `SELECT * FROM labels ORDER BY labelName`
2. For each label: `SELECT count(wordID) FROM wordsLabels WHERE labelID=<id>`

This is an intentional N+1 pattern in current architecture.

### Font-size scale

- `0-10` -> `0.8em`
- `11-30` -> `1em`
- `31-70` -> `1.3em`
- `71-120` -> `1.5em`
- `121-180` -> `1.7em`
- `181-300` -> `1.9em`
- `300+` -> `2.4em`

### Output

Each label links to `label.asp?id=<labelId>`.

---

## guide.asp

**URL:** https://milon.madrasafree.com/guide.asp  
**Feature area:** dictionary  
**Auth:** public  
**DB access (page code):** none

### Purpose

Wrapper page for the transliteration/pronunciation guide.

### Includes

```
inc/inc.asp            -> shared bootstrap and DB objects
inc/header.asp         -> shared head assets
team/inc/functions.asp -> helper functions used by guide content
inc/top.asp            -> top navigation
team/guide.embed.asp   -> embedded guide body
inc/trailer.asp        -> footer and closing tags
```

### Behavior

- Sets guide page title and header.
- Loads `team/inc/guide.css`.
- Injects full guide content from `team/guide.embed.asp`.
- Provides `#links` anchor target used by the embedded content.
- No request parameters or form handling in `guide.asp`.

### Notes

- Page acts mainly as a shell around embedded guide content.
- Detailed include/embed file docs are in `docs/pages/files.md`.
