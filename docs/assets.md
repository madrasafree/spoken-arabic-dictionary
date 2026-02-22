# Static Assets Documentation

This document catalogs the primary JavaScript and CSS files used across the Spoken Arabic Dictionary project.

## JavaScript (`.js`)

Most JavaScript in the project relies on **jQuery 1.11.3** (loaded via CDN in `inc/header.asp`).

### Global / Core Scripts

| File | Purpose | Notes |
|---|---|---|
| `inc/youtube.js` | YouTube iframe lazy-loading. | Replaces `.youtube` div placeholders with actual iframe embeds on click to improve initial page load performance. |
| `inc/functions/saa3a.js` | Arabic Clock logic. | Used entirely by `clock.asp`. Contains the transliteration engine for time, updating every 60 seconds (`setInterval`). |

### Editor / Admin Scripts (`team/js/`)

| File | Purpose | Notes |
|---|---|---|
| `team/js/jquery.new.edit.js` | Editor UI logic. | Powers `word.new.asp` and `word.edit.asp`. Handles UI pane toggling, text character counters, and the complex AJAX-driven "Relations" builder. |
| `team/js/jquery.list.update.js` | List management AJAX. | Powers the inline "add word to list" functionality on `lists.asp`. Queries `json.asp` for word lookups. |
| `team/js/scripts.js` | Legacy / Dead functions. | Contains one active function (`validateForm` for image links). The rest are dead/legacy functions (`lookUp`, `updateSelect`, `nikudTyper`) pointing to dead endpoints like `http://localhost/arabic` and `http://ronen.rothfarb.info`. Should be aggressively pruned. |

## Stylesheets (`.css`)

All main stylesheets are loaded in `inc/header.asp`. No CSS preprocessors (SASS/LESS) are used.

### Global Styles

| File | Purpose |
|---|---|
| `css/normalize.css` | Standard browser style reset. |
| `css/arabic_constant.css` | The primary design system: typography, colors, layout grid, and base component styles. |
| `css/arabic_utils.css` | Utility classes (margins, padding, colors) for quick inline styling. |
| `css/nav.css` | Specifically handles the top navigation bar and slide-out hamburger menu. |

### Responsive Breakpoints

Rather than using inline `@media` queries within the main CSS file, the project splits breakpoints into entirely separate CSS files loaded conditionally by the browser:

| File | Purpose |
|---|---|
| `css/arabic_upto499wide.css` | Mobile portrait (width ≤ 499px) |
| `css/arabic_from500wide.css` | Tablet/Desktop (width ≥ 500px) |
| `css/arabic_upto499high.css` | Short screens (height ≤ 499px) |
| `css/arabic_from500high.css` | Standard screens (height ≥ 500px) |

### Specific Contexts

| File | Purpose |
|---|---|
| `css/devMode.css` | Visual indicators when the application is running in a local development environment. |
| `css/arabic_admin.css` | Admin dashboard styling. |
| `css/arabic_admin_slider.css` | UI toggles in the admin dashboard. |
| `team/inc/arabicTeam.css` | Baseline styles for the `/team` (Editor) section forms and tables. |
| `team/inc/edit.css` | Very specific tweaks for `word.edit.asp` and `word.new.asp`. |
| `team/inc/guide.css` | Styling for the Transliteration Guide (`guide.asp`). |

---

## Migration Notes (Django)

1. **Dead JS Refactor:** `team/js/scripts.js` contains a massive amount of dead code attempting to hit hardcoded deprecated domains or `localhost`. This file should be audited and mostly deleted.
2. **AJAX Endpoints:** The editor scripts heavily rely on `json.asp` to fetch word lists via AJAX. A robust Django REST API endpoint will need to be developed to replace this.
3. **CSS Consolidation:** The paradigm of splitting `@media` queries into 4 distinct physical CSS files is heavily outdated. During migration, these should be compiled (via SASS/Tailwind) or consolidated into standard inline media queries to reduce HTTP requests.
4. **HTML-coupled JS:** Many files (like `clock.asp` and the lists manager) have JavaScript variables and functions mixed inline with VBScript or HTML. These should be decoupled into static assets where possible.
