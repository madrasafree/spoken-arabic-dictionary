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

### Quirks & Dead Code
- Some inline `<style>` and `<script>` blocks break HTML structure by appearing outside `<head>`.
- Admin-specific developer notes are hardcoded at the bottom (IDs: 1), which function as an inline task tracker (e.g. "איחוד 3 התצוגות לדף אחד").

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

### Quirks & Dead Code
- **Disabled Code Blocks:** The "Recent Community Activity" and "Search History Logging" blocks are explicitly disabled via hardcoded impossible conditions: `If len(strDisplay)=500 then 'DISABLED - Normally it's len(strDisplay)=0` and `if len(strDisplay)>500 then 'DISABLED...`.
- App warning logic (`fromApp`) expects `request("app") = "androidFromPortal"`. Focuses on legacy Cordova app deprecation.

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

### Quirks & Security
- **Hardcoded Relation IDs:** The relationship mapping logic (1 = synonym, 3 = plural, 50 = Benoni, etc.) is entirely hardcoded in the VBScript rather than being driven by a database lookup table.
- **SQL Injection Risk:** The `wordId = request("id")` query string parameter is concatenated directly into SQL queries without sanitization (e.g., `WHERE words.id = "&wordId&"`).
- **Inline Styles:** Scattered CSS and `request("app")` logic similar to other legacy pages.

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

### Quirks & Security
- **SQL Injection Risk:** Both `Request("id")` and the translated `Request("order")` variables are appended directly into various SQL queries without parameterization or strict casting.
- **Duplicated Logic:** The tag cloud generation logic is copy-pasted directly from `default.asp`. This violates DRY principles and should be consolidated into a single component or utility in the Django rewrite.
- **Assumed Image Assets:** Assumes an image exists for the OpenGraph meta tag based purely on the `ID` (`img/labels/<%=LID%>.png`). If absent, this produces a broken `og:image`.

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

### Quirks & Security
- **SQL Injection Risk:** `sID = request("sID")` is concatenated directly into SQL queries on `sentence.asp`.
- **Logic Duplication:** The sentence rebuilding loop (involving the `merge` integer and space interpolation) is duplicated identically three times across the codebase (`word.asp`, `sentences.asp`, `sentence.asp`). This makes maintaining the HTML structure for sentences extremely fragile.
- **Hardcoded Role Checks:** Just like `word.asp`, editors are checked via `session("role")>6 or session("userID")=90`.
- **Features "Coming Soon":** `sentence.asp` has a hardcoded HTML list of features that are "coming later" (edit history, media attachment, favorites, lists), indicating the feature is unfinished.

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

### Quirks & Security
- **SQL Injection Risk:** The `LID` URL parameter is concatenated directly into SQL queries on the list-specific game pages without strict type checking.

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

### Quirks & Security
- **Time Calculation Error:** The `secPast` function throws an error/outputs garbage text for recent edits because of shifting timezone/UTC calculation mismatches between the Access `Now()` function and how timestamps were stored. 
- **Legacy `arabicUsers` Coupling:** The hardcoded `IN '"&Server.MapPath(...)&"'` syntax breaks entirely under PostgreSQL architecture and must be refactored into a standard ORM join.

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

### Quirks & Security
- **CRITICAL SECURITY RISK:** Passwords are not hashed. They are queried in plain text.
- **CRITICAL SQL INJECTION:** Both username and password inputs are directly concatenated into the SQL query without parameterization (where username="""&Request("username")&""" and password="""&Request("password")&""").
- loginLog insertion is commented out in login.asp due to a "GODADDY 2021-11-24" error.

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

### Quirks & Security
- **Performance / N+1:** The metric counting executes 5 independent sequential queries instead of one aggregated summary query.
- **Cross-Database Join:** Like `activity.asp`, it performs a hardcoded MS Access cross-database `LEFT JOIN` on `arabicUsers.mdb` to join the history table.

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
- **Locking Mechanism (word.edit.asp):** Implements a 30-minute pessimistic lock on the word to prevent concurrent edits. Updates lockedUTC in the database.
- **UI:** Heavily utilizes jQuery to toggle the visibility of different metadata sections (Tags, Relations, Notes, Examples, Media) to keep the initial form clean.
- **Relations Engine:** A complex client-side UI to add relations (synonyms, antonyms, conjugations) to other words, tied via Javascript to hidden form inputs.

### Quirks & Security
- **Hardcoded Admin Access:** Video/Image embedded linking features are restricted using hardcoded user IDs (session("userID")=1 or session("userID")=73...).
- **Unused Features:** Includes draft/inactive UI elements for "Dialect" and "Origin" marked as "לא פעיל עדיין" (Not active yet).
- **Hardcoded Mappings:** Parts of speech, binyan, gender, and numbers are hardcoded HTML <option> values rather than driven by a database table.

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

### Quirks & Security
- **Cross-Database Join:** Performs an MS Access cross-database JOIN to rabicUsers.mdb (FROM [users] IN 'arabicUsers.mdb') to fetch usernames for the history log. This is a migration blocker for Postgres.
