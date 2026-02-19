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