# Static Assets Documentation

This document catalogs the primary JavaScript and CSS files used across the Spoken Arabic Dictionary project.

## JavaScript (`.js`)

Most JavaScript in the project relies on **jQuery 1.11.3** (loaded via CDN in `includes/header.asp`).

### Global / Core Scripts

| File | Purpose | Notes |
|---|---|---|
| File | Purpose | Notes |
|---|---|---|
| `assets/js/youtube.js` | YouTube iframe lazy-loading. | Replaces `.youtube` div placeholders with actual iframe embeds on click to improve initial page load performance. |
| `assets/js/saa3a.js` | Arabic Clock logic. | Used entirely by `clock.asp`. Contains the transliteration engine for time, updating every 60 seconds (`setInterval`). |

### Editor / Admin Scripts (`assets/js/`)

| File | Purpose | Notes |
|---|---|---|
| `assets/js/jquery.new.edit.js` | Editor UI logic. | Powers `word.new.asp` and `word.edit.asp`. Handles UI pane toggling, text character counters, and the complex AJAX-driven "Relations" builder. |
| `assets/js/jquery.list.update.js` | List management AJAX. | Powers the inline "add word to list" functionality on `lists.asp`. Queries `json.asp` for word lookups. |
| `assets/js/scripts.js` | Legacy / Dead functions. | Contains one active function (`validateForm` for image links). The rest are dead/legacy functions (`lookUp`, `updateSelect`, `nikudTyper`) pointing to dead endpoints like `http://localhost/arabic` and `http://ronen.rothfarb.info`. Should be aggressively pruned. |

## Stylesheets (`.css`)

All main stylesheets are loaded in `includes/header.asp`. No CSS preprocessors (SASS/LESS) are used.

### Global Styles & Responsive Breakpoints

Rather than using split breakpoints, the project uses a single consolidated `milon_main.css` file which contains all base rules, normalization, nav styles, and internal `@media` breakpoints.

| File | Purpose |
|---|---|
| `assets/css/milon_main.css` | The primary design system: typography, colors, layout grid, nav styles, and fully integrated responsive media queries. |

### Specific Contexts

| File | Purpose |
|---|---|
| `assets/css/devMode.css` | Visual indicators when the application is running in a local development environment. |
| `assets/css/arabic_admin.css` | Admin dashboard styling. |
| `assets/css/arabic_admin_slider.css` | UI toggles in the admin dashboard. |
| `assets/css/arabicTeam.css` | Baseline styles for the `/team` (Editor) section forms and tables. |
| `assets/css/edit.css` | Very specific tweaks for `word.edit.asp` and `word.new.asp`. |
| `assets/css/guide.css` | Styling for the Transliteration Guide (`guide.asp`). |

---

## Migration Notes (Django)

1. **Dead JS Refactor:** `assets/js/scripts.js` contains a massive amount of dead code attempting to hit hardcoded deprecated domains or `localhost`. This file should be audited and mostly deleted.
2. **AJAX Endpoints:** The editor scripts heavily rely on `json.asp` to fetch word lists via AJAX. A robust Django REST API endpoint will need to be developed to replace this.
3. **CSS Consolidation:** ~~The paradigm of splitting `@media` queries into 4 distinct physical CSS files is heavily outdated.~~ *Completed:* Responsive breakpoint files have been successfully collapsed into `assets/css/milon_main.css`.
4. **HTML-coupled JS:** Many files (like `clock.asp` and the lists manager) have JavaScript variables and functions mixed inline with VBScript or HTML. These should be decoupled into static assets where possible.
