# Pages Documentation

Page-level documentation for selected public pages.

Documentation layout:
- `docs/pages.md`: page behavior and logic
- `docs/includes.md`: all shared include files

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
- Detailed include/embed file docs are in `docs/includes.md`.

---

## clock.asp

**URL:** https://milon.madrasafree.com/clock.asp
**Feature area:** dictionary (tools)
**Auth:** public
**DB access (page code):** none

### Purpose

An interactive clock utility for learning how to read time in spoken Arabic. Displays the current time with the option to change the time manually. Shows the Arabic terms for the hour and minutes with options for Hebrew transliteration or Arabic script. Also embeds two instructional YouTube videos.

### Includes

```
inc/inc.asp      -> shared bootstrap and DB objects (standard requirement)
inc/header.asp   -> shared head assets (Google Analytics, base CSS)
inc/top.asp      -> top navigation and session setup
inc/trailer.asp  -> footer and closing tags
```
*Note: No dead includes were found. Standard page wrapper is used.*

### Behavior & Logic

- **Client-Side Heavy:** The page is entirely driven by client-side JavaScript. There are no server-side VBScript variables or SQL queries executed within `clock.asp`.
- **Time Logic:** The JavaScript `getCurrentTime()` function retrieves the user's local system time on load. An interval `refresher` updates the clock every 60 seconds.
- **Manual Input:** Users can change the time using an standard HTML5 `<input type="time">`. This stops the auto-refresh interval.
- **Transliteration Engine:** Hardcoded JavaScript `switch` statements (`hhTaatik`, `mmTaatik`, `hhArabic`, `mmArabic`) handle the translation mapping of numbers to Arabic and Hebrew transliterated text.
- **Responsive Layout:** Includes inline CSS with extensive media queries for varied screen sizes.
- **Lazy Loading (Performance):** The YouTube iframes are intentionally left with `src="about:blank"` and are populated via JavaScript `loadDeferredIframe()` on `window.onload` to prevent blocking the initial page rendering.

---

## lists.asp

**URL:** https://milon.madrasafree.com/lists.asp?id=[ID]
**Feature area:** lists
**Auth:** public (with dynamic behavior for list owner / admins)
**DB access:** `arabicWords` (`lists`, `words`, `wordsLists`, `wordsMedia`), `arabicUsers` (`users`)

### Purpose

Displays a curated word list based on the provided `id` parameter. It supports query string sorting (Arabic word, Hebrew translation, pronunciation). It displays metadata like the list creator, creation date, views, and privacy level. For list owners (and admins), it provides inline management tools (adding/removing words).

### Includes

```
inc/inc.asp                   -> DB connection
inc/functions/functions.asp   -> General utility functions
inc/time.asp                  -> Date/Time formatting (Str2hebDate)
inc/header.asp                -> Shared head assets
inc/top.asp                   -> Top navigation
inc/trailer.asp               -> Footer and closing tags
```

### Behavior & Logic

- **Access Guard:** Validates if the list ID exists; redirects to `lists.all.asp` if not found.
- **Visibility Logic:** If the current logged-in user is not the list creator, it appends an `AND show` SQL condition to hide suspect/unchecked words.
- **View Tracker:** Increments the `viewCNT` in the `lists` table via an inline `UPDATE` query if the viewer is not the creator or site admin.
- **Sorting:** Supports sorting the `words` query based on a URL parameter (`order=a|e|h`). Defaults to the manual `pos` (position) field.
- **Admin/Creator Tools:** 
    - If the user owns the list, it shows "Remove" buttons (`.removeBtn`), powered by jQuery and pointing to `listsWord.remove.asp`.
    - Certain admin user IDs (`1, 73, 76`) can add new words via a quick-add AJAX form pointing to `listsWord.insert.asp`.
- **Client-Side:** Loads `team/js/jquery.list.update.js` which handles the AJAX word insertion logic and `newRelSelect` dropdown.


---

## default.asp

**URL:** https://milon.madrasafree.com/ / https://milon.madrasafree.com/default.asp
**Feature area:** dictionary (homepage / search)
**Auth:** public
**DB access:** `arabicWords` (`words`, `wordsShort`, `wordsMedia`, `labels`, `wordsLabels`, `sentences`, `wordsRelations`), `arabicUsers` (`users`), `arabicSearch` (`wordsSearched`, `latestSearched`)

### Purpose

Functions as both the website's homepage and the main dictionary search engine. Displays the search bar, tag cloud (topics), navigation tiles, recent community activity (conditionally), and handles all logic for processing search queries and rendering results (exact matches, soundex phonetic matches, substring matches, and sentence matches).

### Includes

```
inc/inc.asp                        -> DB connection
team/inc/functions/string.asp      -> String manipulation (used for search query cleanup)
inc/functions/functions.asp        -> General utility functions
inc/time.asp                       -> Time formatting
inc/header.asp                     -> Shared head assets (CSS/JS)
inc/top.asp                        -> Top navigation and search bar (HTML form)
team/inc/functions/soundex.asp     -> Phonetic soundex algorithm (server-side VBScript)
inc/banner.asp                     -> Promotional banner (conditionally displayed)
inc/trailer.asp                    -> Footer and closing tags
```

### Behavior & Logic

- **Search Algorithm:**
    - Cleans user input using `strClean` and `strDisplay` (defined likely in `top.asp` or a string include).
    - **Pass 1 (Exact & Short Words):** Checks for exact matches in `hebrewClean`, `arabicClean`, `arabicHebClean` or aliases in `wordsShort`.
    - **Pass 2 (Broad Exact):** Checks comma-separated alternative exact strings (`hebrewCleanMore`, `arabicCleanMore`, etc.).
    - **Pass 3 (Soundex):** If length > 1, calculates Hebrew/Arabic Soundex (`sndxArabicV1`, `sndxHebrewV1`) and queries for phonetic matches.
    - **Pass 4 (Substring/Like):** Searches for the string inside larger words using SQL `LIKE`.
    - **Pass 5 (Related):** Searches in the `searchString` catch-all column (e.g., misspellings, synonyms).
    - **Pass 6 (Sentences):** If the search contains a space, queries the `sentences` table for matches.
- **Result Rendering:** Combines all passes, deduplicating IDs using an inline VBScript array (`ids = ids & "," & res("id")`). Includes logic to fetch and render embedded media (YouTube, Clyp.it, SoundCloud, local OGG). Shows "Single/Plural" relations inline if applicable.
- **Client-Side:** Uses jQuery heavily to toggle visibility of different search result blocks (e.g. `#msgRsltsExct`, `#msgRsltsZeroExct`) based on the counts calculated during VBScript rendering (`data-count`).
- **Tag Cloud:** Queries `labels` and `wordsLabels` to generate a weighted font-size tag cloud.
- **Activity Feed (Disabled):** Contains an intricate set of SQL queries with `LEFT JOIN` to the MS Access `arabicUsers.mdb` file to pull recent user edits, new words, and list edits.
- **Search Analytics (Disabled):** Contains logging logic to write to the `arabicSearch` database (`wordsSearched`, `latestSearched`).


---

## word.asp

**URL:** https://milon.madrasafree.com/word.asp?id=[ID]
**Feature area:** dictionary (word entry)
**Auth:** public (with editor-specific blocks)
**DB access:** `arabicWords` (`words`, `labels`, `wordsLabels`, `wordsRelations`, `sentences`, `wordsSentences`, `wordsMedia`, `media`, `lists`, `wordsLists`), `arabicUsers` (`users`)

### Purpose

Displays the full dictionary entry for a specific word. Shows word properties (part of speech, gender, number, binyan), tags/labels, related words (synonyms, plurals, opposites, derivations), example sentences where the word appears, embedded media (audio/video), and the lists the word belongs to.

### Includes

```
inc/inc.asp                        -> DB connection
inc/functions/functions.asp        -> Utility functions
inc/time.asp                       -> Time functions
inc/header.asp                     -> Head assets
inc/top.asp                        -> Top navigation
inc/banner.asp                     -> Promotional banner
inc/trailer.asp                    -> Footer
```

### Behavior & Logic

- **Initialization:** Fetches the core word data from `words` joined with `arabicUsers.users` to get the creator's username. Sets an `og:image` meta tag based on the word's image if one exists.
- **Word Properties:** Translates numeric `partOfSpeach`, `gender`, and `number` into Hebrew strings using `SELECT CASE`.
- **Labels:** Queries `wordsLabels` to list associated topics.
- **Word Relations Engine:** Contains a massive `SELECT CASE` block handling `relationType` IDs (1 through 61) to define structural relationships between words, including:
    - Synonyms, Plurals/Singulars, Feminine/Masculine variations
    - Combinations ("מורכב מ")
    - Derivations (e.g. Masdar, Benoni Poel, form variations)
- **User Lists:** Displays which public lists contain the word. Allows logged-in users to add the word to their own lists via `#myLists` dropdown.
- **Media Support:** Iterates through `wordsMedia` to embed YouTube, Clyp.it, SoundCloud, or local OGG audio.
- **Sentences System:** Queries `wordsSentences`. Uses a `merge` integer column to dictate spacing logic when dynamically rebuilding the Arabic sentence string, applying a CSS highlight to the active word within the sentence.
- **Editor Notice:** If `session("role") > 6` and the word is missing metadata (`needsEdit = true`), an "Editor's Area" block is shown detailing what needs to be fixed. It also specifically looks for duplicate flags (`relationType = 99`).


---

## label.asp

**URL:** https://milon.madrasafree.com/label.asp?id=[ID]&order=[a|e|h]
**Feature area:** dictionary (tag/topic view)
**Auth:** public
**DB access:** `arabicWords` (`labels`, `wordsLabels`, `words`, `wordsMedia`)

### Purpose

Displays all dictionary entries associated with a specific topic/label (e.g., "Food", "Medical", "Colors"). Displays the full weighted tag cloud at the top (collapsible) and lists the related words below.

### Includes

```
inc/inc.asp                        -> DB connection
inc/functions/functions.asp        -> Utility functions
inc/header.asp                     -> Head assets
inc/top.asp                        -> Top navigation
inc/trailer.asp                    -> Footer
```

### Behavior & Logic
- **Header:** Fetches the `labelName` for the current ID to set the `<title>` and `<h1>`. Also dynamically points `og:image` to `img/labels/[ID].png`.
- **Sorting:** Allows sorting the word list via the `order` query string parameter (`a` = Arabic (default), `e` = English/pronunciation, `h` = Hebrew).
- **Tag Cloud:** Re-implements the exact same tag cloud weighing logic (`SELECT Case true... x>=0 AND x<=10...`) found in `default.asp` to display all available labels.
- **Word Listing:** Uses a large `INNER JOIN` to fetch `words`, `wordsLabels`, and `wordsMedia` where `labelID = [ID]`. Renders the collection using the standard search result card UI (Hebrew, Arabic, transliteration, verification status icons, and media indicators).
- **Client-Side:** Uses jQuery to handle toggling the visibility of the primary tag cloud via `#hide` and `#unhide` buttons, and counts the results to update the `#wordsSum` header.


---

## sentences.asp / sentence.asp

**URL:** https://milon.madrasafree.com/sentences.asp, https://milon.madrasafree.com/sentence.asp?sID=[ID]
**Feature area:** dictionary (sentences/sandbox)
**Auth:** public (with editor features)
**DB access:** `arabicWords` (`sentences`, `wordsSentences`)

### Purpose

Acts as a "sandbox" or experimental area for phrases and sentences. `sentences.asp` lists all available sentences. `sentence.asp` displays a single sentence with next/previous navigation.

### Includes

```
inc/inc.asp                        -> DB connection
inc/functions/functions.asp        -> Utility functions
inc/header.asp                     -> Head assets
inc/top.asp                        -> Top navigation
inc/trailer.asp                    -> Footer
```

### Behavior & Logic
- **`sentences.asp`:**
    - Queries all `sentences` ordered by ID descending.
    - Features a client-side jQuery toggle (`#toggleTaatik`) to show/hide the Hebrew transliteration using `<ruby>` and `<rt>` HTML tags.
    - Displays a "Page under construction" warning.
- **`sentence.asp`:**
    - Queries a single sentence via `sID`.
    - Calculates the "Next" and "Prev" sentence IDs manually via `MIN`/`MAX` and `<` / `>` SQL queries.
    - Conditionally displays "Edit Sentence" and "New Sentence" links if the user is an editor (`session("role")>6` or `session("userID")=90`).
- **Shared Sentence Rebuilding Engine:** Both pages (and `word.asp`) duplicate a complex VBScript loop that iterates over the junction table `wordsSentences`. It reconstructs the full Arabic string by splitting the original sentence by spaces, and iterating with a `location` and `merge` column to decide whether to append a space, open an anchor tag `<a>` mapping to `word.asp`, or close the tag.


---

## games.mem.asp, games.mem.pics.asp, games.mem.list.asp

**URLs:** 
- https://milon.madrasafree.com/games.mem.asp
- https://milon.madrasafree.com/games.mem.pics.asp?LID=[ID]
- https://milon.madrasafree.com/games.mem.list.asp?LID=[ID]
**Feature area:** dictionary (games)
**Auth:** public
**DB access:** `arabicWords` (`words`, `wordsLists`, `lists`)

### Purpose

A suite of simple "memory" (flashcard) games designed to help users learn words.
- `games.mem.asp`: Global mode. Pulls 20 random verified words that have an associated image.
- `games.mem.pics.asp`: Same visual image-card layout, but locked strictly to the words within a specific user List (`LID`).
- `games.mem.list.asp`: Purely text-based flip cards based on a specific user List (`LID`). 

### Includes

```
inc/inc.asp                        -> DB connection
inc/functions/functions.asp        -> Utility functions (shada fix)
inc/header.asp                     -> Head assets
inc/top.asp                        -> Top navigation
inc/trailer.asp                    -> Footer
```

### Behavior & Logic
- **`games.mem.asp` & `games.mem.pics.asp`:** Both use a masonry CSS column layout (`column-count`). They display the Hebrew word and image. A jQuery click listener `$('.pin').click(...)` blindly toggles `slideToggle` on the hidden `.txtDiv` which contains the Arabic text and transliteration. `games.mem.asp` uses an Access `Rnd()` function to randomize 20 results.
- **`games.mem.list.asp`:** Uses a CSS 3D transform (`rotateY(180deg)`) triggered by a jQuery click event to physically flip HTML div cards, revealing the Arabic on the back.


---

## activity.asp

**URL:** https://milon.madrasafree.com/activity.asp
**Feature area:** dashboard (site activity feed)
**Auth:** public
**DB access:** `arabicWords` (`lists`, `words`, `history`, `labels`), `arabicUsers` (`users`)

### Purpose

Displays a unified timeline of recent community contributions to the dictionary: newly created lists, recently added words, and recent word edits.

### Includes

```
inc/inc.asp                        -> DB connection
inc/time.asp                       -> Time logic (secPast)
inc/header.asp                     -> Head assets
inc/top.asp                        -> Top navigation
inc/trailer.asp                    -> Footer
```

### Behavior & Logic
- **Data Gathering:** Runs three massive, distinct SQL queries:
  1. Top 10 recently updated Lists.
  2. Top 20 recently created Words.
  3. Top 30 most recent word Edits (from the `history` table).
- **Cross-Database Joins:** All three queries perform an inline `LEFT JOIN` stretching across into the `arabicUsers.mdb` file to pull the user's avatar (`picture`) and `username` based on the creator ID.
- **Sorting Logic:** Because the queries are sequential and independent, the timeline isn't sorted at the database level. Instead, the server renders all items into `.actions` HTML divs with a `data-time` attribute. A jQuery block (`$(".actions").sort(sort_li)`) kicks in *after* page load to re-arrange the HTML nodes chronologically in the DOM based on that data attribute.
- **Diff Engine:** For word edits, the page contains a huge VBScript block that manually compares every "Old" and "New" column state (e.g., `hebrewOld` vs `hebrewNew`). If there's a mismatch, it outputs a UI row showing what changed. 


## login.asp / login.fixhref.asp

**URLs:** https://milon.madrasafree.com/login.asp, https://milon.madrasafree.com/login.fixhref.asp
**Feature area:** authentication
**Auth:** public
**DB access:** `arabicUsers` (`users`, `allowEdit`, `loginLog`)

### Purpose
Handles user authentication and session creation. login.fixhref.asp appears to be a legacy or alternative version of the login handler that manages redirects slightly differently using the HTTP_REFERER.

### Behavior & Logic
- Checks `allowEdit` table to see if the site is in maintenance mode.
- Queries the users table for a matching username/password.
- Establishes multiple session variables (userID, userName, email, role, name).
- Redirects user based on the `returnTo` or `ref` parameter.


---

## welcome.asp

**URL:** https://milon.madrasafree.com/welcome.asp
**Feature area:** user onboarding
**Auth:** public
**DB access:** none

### Purpose
A static HTML orientation guide for new users/editors explaining how to log in, create lists, add words, and edit entries. Uses simple jQuery anchor scrolling.

---

## profile.asp / profile.allwords.asp

**URLs:** https://milon.madrasafree.com/profile.asp?id=[ID], https://milon.madrasafree.com/profile.allwords.asp?id=[ID]
**Feature area:** user profile
**Auth:** public (with editor views for hidden words)
**DB access:** `arabicUsers` (`users`), `arabicWords` (`words`, `history`, `lists`, `media`, `wordsMedia`)

### Purpose
Displays a user's activity dashboard. profile.asp shows a summary of their metrics (words added, edits, lists, media), recent activity feeds, and edits. profile.allwords.asp is a dedicated page just to list every single word the user has ever added.

### Behavior & Logic
- **Metrics Check:** Executes 5 separate COUNT() SQL queries in sequence to determine if the user has words, edits, lists, audio, and video content.
- Builds a tile menu dynamically based on the metrics.
- Uses inline Javascript/jQuery `fadeToggle` to switch between "tabs" (Lists, Words, Edits, Audio, Video).
- If the viewer is an editor (session("role") And 2 > 0), it appends an extra section showing words created by this user that are currently hidden (show=false).
- Calculates relative time formatting (e.g., "5 minutes ago") via VBScript DateDiff.


## word.new.asp / word.edit.asp

**URLs:** https://milon.madrasafree.com/word.new.asp, https://milon.madrasafree.com/word.edit.asp?id=[ID]
**Feature area:** word management (editor)
**Auth:** Editor (session("role") and 2 > 0) or specific creators.
**DB access:** `arabicWords` (`words`, `labels`, `media`, `wordsMedia`, `wordsRelations`, `wordsLabels`), `arabicUsers` (`allowEdit`)

### Purpose
Forms for adding a new word or editing an existing word in the dictionary. It includes inputs for translations, transliterations, part of speech, tags, relations, and embedded media.

### Behavior & Logic
- **Permissions:** word.new.asp requires an editor role bitmask (session("role") AND 2). word.edit.asp requires either a manager/admin role (>6), or the user must be the original creator AND the word must not be approved yet (status<>1).
- **Read-Only Mode:** Checks `allowEdit` table where `siteName='readonly'`.
- **Locking Mechanism (word.edit.asp):** Implements a 30-minute pessimistic lock on the word to prevent concurrent edits. Updates lockedUTC in the database. `word.unlock.asp` allows releasing this lock dynamically (e.g., when the user cancels out of the edit form).
- **UI:** Heavily utilizes jQuery to toggle the visibility of different metadata sections (Tags, Relations, Notes, Examples, Media) to keep the initial form clean.
- **Relations Engine:** A complex client-side UI to add relations (synonyms, antonyms, conjugations) to other words, tied via Javascript to hidden form inputs.


---

## word.history.asp

**URL:** https://milon.madrasafree.com/word.history.asp?id=[ID]
**Feature area:** auditing
**Auth:** general access
**DB access:** `arabicWords` (`words`, `history`, `labels`, `errorTypes`), `arabicUsers` (`users` via cross-db join)

### Purpose
Displays a detailed audit trail of all changes made to a specific word, including the user who made the change, the timestamp, and the exact fields altered.

### Behavior & Logic
- **Diff Display:** Hardcodes mappings for status and metadata integer values back to display strings (e.g., partOfSpeech=3 -> "פועל") to show visual "Old vs New" diff blocks.
- **Action Mapping:** Maps numeric action codes in the history table to actions like "Edited", "Hidden", "Marked as Mistake", or "Archived".

---

## admin.asp

**URL:** https://milon.madrasafree.com/admin.asp
**Feature area:** admin
**Auth:** Admin (`session("role") = 15`)
**DB access:** `arabicUsers` (`allowEdit`, `loginLog`, `users`)

### Purpose
The main control panel for site administrators. Displays server metrics, user login history, and links to all other admin features.

### Behavior & Logic
- Validates that the user is an admin; redirects to `team/login.asp` if not.
- Queries `allowEdit` table to check the current status of maintenance mode (login disable) and Read-Only mode.
- Renders HTML toggle switches that link to `admin.allowEditToggle.asp` and `admin.readOnlyToggle.asp`.
- Queries `loginLog` to display the most recent login, logging a note that login auditing was disabled in November 2021.

---

## admin.allowEditToggle.asp & admin.readOnlyToggle.asp

**URL:** `admin.allowEditToggle.asp` / `admin.readOnlyToggle.asp`
**Feature area:** admin
**Auth:** implicit reliance on `inc.asp` / no direct session check implemented inline
**DB access:** `arabicUsers` (`allowEdit`)

### Purpose
Action handlers to flip the site-wide boolean flags for allowing logins (`allowEdit`) or enabling Read-Only mode (`readOnly`).

### Behavior & Logic
- Contains a minimal script that executes an `UPDATE` on the `allowEdit` table, flipping the `allowed` boolean for the respective row (`siteName='arabic'` or `siteName='readOnly'`).
- Immediately redirects the user back to the referrer (`Request.ServerVariables("HTTP_REFERER")`).

---

## admin.locked.asp

**URL:** https://milon.madrasafree.com/admin.locked.asp
**Feature area:** admin
**Auth:** Admin (`session("role") < 14` guard)
**DB access:** `arabicWords` (`words`)

### Purpose
Displays a table of words that are currently locked by pessimistic editing locks and allows admins to forcibly unlock them.

### Behavior & Logic
- Queries the `words` table for any row where `lockedUTC` is not empty (`len(lockedUTC)>1`).
- Renders the results in a table, displaying the locking timestamp and word translations.
- Provides an "unlock" link pointing to itself with parameters `?unlock=true&id=[ID]`.
- Handles the unlock request by executing an `UPDATE words SET lockedUTC='' WHERE id=[ID]` query, effectively removing the lock manually.

---


## dashboard.asp

**URL:** https://milon.madrasafree.com/dashboard.asp
**Feature area:** dashboard (admin/editor)
**Auth:** public (no session guard)
**DB access:** `arabicWords` (`words`, `taskNoPlural`)

### Purpose
A metrics dashboard displaying counts of words sliced by various metadata states (hidden, suspect, missing arabic, missing POS). Functions as a content quality-control panel.

### Behavior & Logic
- Executes roughly 40 sequential `SELECT COUNT(*)` queries to populate an HTML table of metrics.
- Calculates percentages in VBScript based on the total counts.
- Links to `dashboard.lists.asp?listID=[ID]` to view the specific words that fall into each category.

---

## dashboard.lists.asp

**URL:** https://milon.madrasafree.com/dashboard.lists.asp?listID=[ID]
**Feature area:** dashboard
**Auth:** public (no session guard)
**DB access:** `arabicWords` (`words`, `taskNoPlural`)

### Purpose
Displays the specific words that correspond to the metric categories clicked in `dashboard.asp`.

### Behavior & Logic
- Uses a `select case listID` block to map the integer ID to a specific SQL `WHERE` clause (e.g. `listID=4` maps to `len(arabic)=0`).
- This design inherently protects against SQL injection since the `listID` parameter never enters the SQL query string directly.
- Displays words up to a `TOP 100` limit.
- If the viewer is an editor (`session("role")>6`) and `listID=1` (unchecked words), it renders inline "Quick Edit" and "Quick Approve" buttons.

---

## users.asp

**URL:** https://milon.madrasafree.com/users.asp
**Feature area:** community
**Auth:** public
**DB access:** `arabicUsers` (`users`)

### Purpose
Displays a directory of dictionary contributors/volunteers, showing their avatars and usernames.

### Behavior & Logic
- Excludes specific hardcoded system/admin user IDs `(2,5,6,7,36,37,48)`.
- Uses jQuery to count the number of users rendered and displays the total.

---

## users.landingPage.asp

**URL:** https://milon.madrasafree.com/users.landingPage.asp
**Feature area:** user portal
**Auth:** editor (`session("role") and 2`)
**DB access:** none

### Purpose
A simple static HTML menu serving as a portal for logged-in contributors, linking to their profile, the dashboard, media bank, and task lists.

---

## guideTeam.asp

**URL:** https://milon.madrasafree.com/guideTeam.asp
**Feature area:** documentation
**Auth:** public
**DB access:** none

### Purpose
A static HTML transliteration and dictionary-standard guide for team members. Explains how to spell properly (e.g. `ث` is always `ת'`), how to add images, and how to write examples. Includes the `showShada()` VBScript function inline.

---

## stats.asp

**URL:** https://milon.madrasafree.com/stats.asp
**Feature area:** statistics
**Auth:** public
**DB access:** `arabicWords` (`words`, `labels`, `lists`, `media`, `wordsRelations`), `arabicUsers` (`users`), `arabicSearch` (`wordsSearched`)

### Purpose
Provides a public-facing static data page showing cumulative metrics of the dictionary (total users, total words, total images, etc.) alongside a hardcoded historical table of metrics from 2012 to 2021.

### Behavior & Logic
- Connects sequentially to all three main MS Access databases in one page load.
- Displays basic calculated percentages and metrics.
- Hardcoded HTML table for yearly metrics — **last updated in 2021, no longer maintained**. The Google Analytics integration that sourced these numbers may no longer be active.

---


## json.asp

**URL:** https://milon.madrasafree.com/json.asp?relData=[wordID],[searchString]
**Feature area:** api/ajax
**Auth:** public / editor
**DB access:** `arabicWords` (`words`)

### Purpose
An AJAX endpoint returning JSON data of existing dictionary words. Utilized by editor scripts (like `jquery.list.update.js` and `jquery.new.edit.js`) to power auto-suggest and word relation linking UIs.

### Behavior & Logic
- Expects a comma-separated query string `relData` containing an `id` to exclude, and a `search` string to match.
- Performs two queries: 
  1. An exact match search.
  2. A fuzzy `LIKE` search to fill in the remaining slots up to 10 total results limit (`TOP [10-count]`).
- Appends results via a manual JSON string concatenation loop (no serialization library is used).
- Sets `Response.ContentType = "application/json"`.

---

## Admin Panel (`admin.*.asp`)

The administrative panel consists of ~24 distinct `.asp` files, largely split into user management, search history analytics, and system monitors.

**Auth:** Most files require Admin privileges (`session("role") = 15`), though some mistakenly use inverse logic or different thresholds.
**DB access:** Varies, but primarily reads `arabicUsers`, `arabicSearch`, and `arabicWords`.

### User Management (`admin.user*.asp`)
Includes `admin.userControl.asp`, `admin.userControl.full.asp`, `admin.userEdit.asp`, `admin.userNew.asp`, and their respective `.update`/`.insert` handlers.
- Queries `arabicUsers` (`users`).
- Renders tables of users with status color codes (Active, Frozen, Suspended, Deleted).
- Allows assigning specific roles (Guest/1, Editor/7, Admin/15) via basic form submissions.

### Search History Analytics (`admin.searchHistory.*.asp`)
**Status: DELETED.** The entire suite of `admin.searchHistory.*.asp` files and variants was permanently removed.

Includes `admin.searchHistory.asp` (Index) and multiple variants: `.last50.asp`, `.24h.asp`, `.7days.asp`, `.since2009.asp`, `.noExact.asp`, `.noSentence.asp`.
- Queries `arabicSearch` (`wordsSearched`, `latestSearched`).
- The logic across these files is largely identical, differing primarily by the SQL `WHERE` clause (e.g. `WHERE actionUTC > dateAdd('d',-7,now())`).
- Uses VBScript `SELECT CASE` logic to assign CSS color classes to results based on whether a search yielded an exact match, a partial match, or no results.

### Miscellanous Admin Tools
- **`admin.wordsShort.asp`**: Allows inline creation/editing of shorthand aliases (`sStr`) mapped to a specific `wordID`. 
- **`admin.monitors.asp`**: **DELETED.** Iterated through database metrics (e.g., total list views) to calculate averages for system health reporting. Contains a button to send an admin alert email via `admin.monitors.email.php`.
- **`admin.labelControl.asp`**: Basic UI for adding and editing word categories ("labels").
- **`admin.select.asp`**: **DELETED.** Dedicated UI to edit the custom dropdown option lists used throughout the site.
- **`admin.loginHistory.asp`**: **DELETED.** Displays the active sessions table (`loginLog`).
- **`admin.listAllWords.asp`**: **DELETED.** Produces a massive, paginated HTML table of the entire dictionary.

---

## activity.asp

**URL:** https://milon.madrasafree.com/activity.asp
**Feature area:** admin/community
**Auth:** public (no session guard)
**DB access:** `arabicWords` (`words`, `labels`, `lists`, `media`, `history`), `arabicUsers` (`users`)

### Purpose
Displays a real-time activity feed of recent word edits, additions, and media uploads across the dictionary.

### Behavior & Logic
- Pre-loads all label names into a VBScript array to decode label IDs in the history stream.
- Queries the `history` table joined with `words` and `users` to build a timeline of actions.
- Uses `secPast()` from `inc/time.asp` to render relative timestamps ("5 minutes ago").
- Distinguishes action types (new, edit, approve, hide, error report) with color-coded CSS.

---

## default.asp

**URL:** https://milon.madrasafree.com/ (or `default.asp`)
**Feature area:** dictionary (homepage / search)
**Auth:** public
**DB access:** `arabicWords` (many tables), `arabicUsers`, `arabicSearch`, `arabicManager`

### Purpose
The main homepage and search engine for the dictionary. Accepts a search query `q`, performs lookups across multiple field variants, and renders the matching word(s) with full detail.

### Behavior & Logic
- Handles exact match, fuzzy match (`LIKE`), and soundex phonetic matching.
- Logs every search into `arabicSearch` (`wordsSearched`, `latestSearched`).
- Renders word card with Arabic script, transliteration, Hebrew translation, images, audio, video, examples, and related words.

---


## clock.asp

**URL:** https://milon.madrasafree.com/clock.asp
**Feature area:** dictionary (learning tool)
**Auth:** public
**DB access:** none

### Purpose
An interactive Arabic clock learning tool. Displays an SVG analog clock and transliterates the current time into Arabic using `saa3a.js`.

---

## games.mem.asp / games.mem.list.asp / games.mem.pics.asp

**URL:** https://milon.madrasafree.com/games.mem.asp
**Feature area:** games
**Auth:** public
**DB access:** `arabicWords` (`words`, `media`, `wordsMedia`, `lists`, `wordsLists`)

### Purpose
Memory-matching card games. `games.mem.asp` picks 20 random image-based words. `games.mem.list.asp` plays from a specific word list. `games.mem.pics.asp` is a picture-only variant.

### Behavior & Logic
- Queries words that have images and randomizes them server-side.
- Renders a card grid with CSS flip animations and matching logic in jQuery.

---

## label.asp

**URL:** https://milon.madrasafree.com/label.asp?id=[ID]
**Feature area:** dictionary
**Auth:** public
**DB access:** `arabicWords` (`labels`, `words`, `wordsLabels`, `media`, `wordsMedia`)

### Purpose
Displays all words that belong to a given topic label/category. Supports sorting by Arabic, transliteration, or Hebrew.

### Behavior & Logic
- Reads the `id` parameter and queries the label name, then joins `wordsLabels` with `words` to list matching entries.
- Renders each word with its image thumbnail if available.
- Supports admin hide/show toggle for editors.

---

## sentence.asp

**URL:** https://milon.madrasafree.com/sentence.asp?id=[ID]
**Feature area:** dictionary
**Auth:** public
**DB access:** `arabicWords` (`sentences`, `words`, `wordsSentences`, `media`)

### Purpose
Displays a single example sentence with its Arabic text, Hebrew translation, and linked words.

### Behavior & Logic
- Queries the `sentences` table and joins with `wordsSentences` to find which dictionary words appear in the sentence.
- Highlights linked words within the sentence text.
- Provides edit link for editors.

---

## sentences.asp

**URL:** https://milon.madrasafree.com/sentences.asp
**Feature area:** dictionary
**Auth:** public
**DB access:** `arabicWords` (`sentences`, `words`, `wordsSentences`, `media`)

### Purpose
Browse/index page listing all example sentences in the dictionary, with pagination.

---

## word.asp

**URL:** https://milon.madrasafree.com/word.asp?id=[ID]
**Feature area:** dictionary
**Auth:** public
**DB access:** `arabicWords` (many tables), `arabicUsers` (`users`)

### Purpose
The full word detail page. Shows all aspects of a dictionary entry: Arabic, Hebrew, transliteration, images, audio, video, examples, word relations, labels, and edit history.

### Behavior & Logic
- The most complex page in the system (~1000 lines).
- Queries across 12+ tables to assemble the full word card.
- Renders media (images, audio, YouTube videos), related words, example sentences, and category labels.
- If the viewer is an editor, shows the edit toolbar with links to `word.edit.asp`, approval/hiding handlers.

---

## Team Section Pages (`team/*.asp`)

- **`team/default.asp`**: Team section homepage. Shows open tasks and recent media.
- **`team/mediaControl.asp`**: Lists audio/video files attached to a word.
- **`team/mediaEdit.asp`**: Form to edit an existing media record.
- **`team/mediaNew.asp`**: Form to upload/create a new media record.

> **Handlers** (word status actions, insert handlers, email scripts) are documented separately in **[handlers.md](handlers.md)**.
