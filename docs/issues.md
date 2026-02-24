# Technical Issues & Cleanup Tracker

This document tracks technical debt, dead code, and other codebase issues discovered during analysis that should be addressed prior to or during the Django migration.

## Dead Code & Includes

*   **Cleanup Status:** The `cleanup-dead-code` branch has successfully removed significant technical debt, including orphaned admin pages, unused `includes/` headers, dead `team/` handlers, obsolete `team.task.*` system, and legacy PHP email scripts.
*   **`clock.asp`:** No dead code or dead includes detected. The `daqiqa` variable toggles dynamically based on grammar rules as expected. (Logged during documentation review).

## Ongoing Issues

*   **`lists.asp` Hardcoded Admin IDs:** Logic checking for admin capabilities relies on hardcoded user IDs (`session("userID")=1 or session("userID")=73 or session("userID")=76`), bypassing normal `session("role")=15` role checks.
*   **`lists.asp` Inline Admin Notes:** Displays a "משימות אדמין לדף זה" (Admin tasks for this page) block for `userID=1`. These sorts of task-tracking elements should be migrated to GitHub Issues or Monday.com boards rather than being shipped in production HTML.
*   **`lists.asp` HTML Structure:** Contains inline `<style>` blocks scattered randomly throughout the `<body>`, which violates general HTML standards and makes componentization in Django harder.
*   **`default.asp` Disabled Search Analytics:** The logic to write search terms to the DB is disabled via a hardcoded override condition: `if len(strDisplay)>500 then 'DISABLED - Normally it's len(strDisplay)>0`. This should likely be restored in the Django rebuild.
*   **`default.asp` Disabled Community Activity Feed:** The logic to show new recent uploads on the homepage is disabled via a hardcoded override condition: `If len(strDisplay)=500 then 'DISABLED - Normally it's len(strDisplay)=0`.
*   **`default.asp` Cross-DB Join Queries:** The activity feed (when it was active) executed an inline string join to a separate Access file: `IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"'`. This pattern needs to be converted to standard Django foreign key relations since PostgreSQL will be a single DB instance.
*   **`word.asp` SQL Injection Vulnerability:** `request("id")` is concatenated directly into SQL queries without sanitization, e.g., `WHERE words.id = "&wordId&"`. This must use parameterized queries in the Django rewrite.
*   **`word.asp` God-block for `wordsRelations`:** The page uses a massive `SELECT CASE` block spanning hundreds of lines to map `relationType` integers to string labels (e.g. 1 = synonym, 3 = plural/single, 54 = Masdar). The Django rewrite should model this with a `WordRelationType` lookup table.
*   **`word.asp` Hardcoded Role Checks:** Editor functions are enabled by checking `session("role") > 6`. Django permissions should be model/group based instead of integer inequalities.
*   **`label.asp` SQL Injection Vulnerability:** Similar to `word.asp`, both `request("id")` and `order` parameters are concatenated into raw SQL queries.
*   **`label.asp` Duplicated Tag Cloud Logic:** The VBScript loop and `SELECT CASE` block determining tag font sizes is identical to the one in `default.asp`. This should be an isolated component in Django.
*   **`sentences.asp` / `sentence.asp` SQL Injection Vulnerability:** `request("sID")` is concatenated directly into the raw SQL string without sanitization.
*   **Sentences Logic Duplication:** The complex logic involving `wordsSentences` and the `merge` column for determining spaces between Arabic words and hyperlinking them is fully duplicated across `word.asp`, `sentences.asp`, and `sentence.asp`. This requires a single Django reusable template filter or modeled property.
*   **`games.mem.*.asp` SQL Injection Vulnerability:** `request("LID")` is directly concatenated to SQL on the list-based game pages.
*   **`activity.asp` Broken Time Calculation:** The time-ago helper fails to accurately render `"לפני X שעות/ימים"` due to timezone mismatches between how MS Access records `Now()` and how timestamps are formatted, often throwing a localized error string in the UI. 
*   **`activity.asp` Cross-DB Join Queries:** Similar to the disabled block on `default.asp`, the three main queries execute an inline string join to a separate Access file: `IN '"&Server.MapPath("App_Data/arabicUsers.mdb")&"'`. This needs to be normalized in PostgreSQL.
*   **Parameter Mismatch Bugs (JET Errors):** 
    - `listsEdit.asp` expects the parameter `id=` but is occasionally linked with `LID=`, causing a JET Database error missing operator.
    - `team/mediaEdit.asp` expects the parameter `id=` but is linked via the team portal with `wordID=` and `mediaID=`, causing a similar JET error.

## Login & Profiles (login.asp, profile.asp)

- **CRITICAL / Security:** login.asp and login.fixhref.asp query passwords directly in plain text (password="""&Request("password")&"""). The database is currently storing passwords unhashed and without salt.
- **CRITICAL / Security:** login.asp contains severe SQL injection vulnerabilities in the authentication query. Both username and password variables are passed unescaped.
- **Architecture / Hardcoded Logic:** The maintenance mode check relies on the presence of a hardcoded siteName row: SELECT allowed FROM allowEdit WHERE siteName='arabic'.
- **Database / Dead Code:** login.asp comments out the mechanism to log successful logins (INSERT INTO loginLog) due to a "Godaddy bug". This table (loginLog) is no longer being securely populated.
- **Performance / N+1:** profile.asp executes 5 separate, sequential COUNT() SQL queries against multiple tables to determine what type of content a user has created (Words, Edits, Lists, Audio, Video). These should be combined into a single dashboard aggregation query.
- **Architecture / Postgres Migration:** `profile.asp` executes an MS Access cross-database JOIN (`FROM [users] IN 'arabicUsers.mdb'`) when querying the user's history. This is incompatible with Postgres.

## Word Management (`word.new.asp`, `word.edit.asp`, `word.history.asp`)

- **Hardcoded Users for Features:** In `word.new.asp` and `word.edit.asp`, specific user IDs are hardcoded for access to embedded media (`session("userID")=1 or session("userID")=73...`). This should be managed by role or permission flags.
- **Hardcoded Select Options:** Metadata lists such as `partOfSpeach`, `binyan`, `gender`, and `number` are hardcoded `<option>` elements in `word.new.asp`/`word.edit.asp` rather than dynamic data mappings. Furthermore, these explicit mappings have to be duplicated again in `word.history.asp` in VBScript to render the textual diff.
- **Pessimistic Locking Code Smell:** The editing lock system operates by writing an arbitrary string format into a `lockedUTC` string column (e.g., `2023-11-20T14:30Z_uid123`) and does string manipulation `right() / dateDiff / Replace` in VBScript to check the lock duration. This is fragile.
- **Cross-Database Joins:** `word.history.asp` runs multiple queries containing MS Access direct file joins (`FROM [users] IN 'arabicUsers.mdb'`). This requires refactoring for standard RDBMS cross-table JOINs on a centralized database.

## Sentence Management (`sentenceNew.asp`, `sentenceEdit.asp`)

- **CRITICAL / Security:** `sentenceEdit.asp` and `sentenceEdit.update.asp` are immediately vulnerable to SQL injection via the `sID` parameter (`WHERE id="&sID`).
- **Architecture / Mismatched Permissions:** The view page `sentenceNew.asp` enforces an admin requirement (`role < 7 & userID <> 90`), while the POST handler `sentenceNew.insert.asp` requires an editor bitmask (`role AND 2`). The same inconsistency exists in the edit pages.
- **Architecture / Hardcoded Limits:** `sentenceEdit.update.asp` hardcodes its loop limit for word-mappings to `for i=0 to 20`. Any Arabic sentence longer than 21 words will silently fail to save relationships for the trailing words.
- **Architecture / Destructive Form Handling:** The update handler (`sentenceEdit.update.asp`) brutally executes `DELETE FROM wordsSentences WHERE sentence=[ID]` and then runs `INSERT` for every field, rather than executing an intelligent `UPDATE` or `UPSERT`. This pattern destroys DB row stability and inflates auto-increment keys.

## Lists Management (`lists.asp`, `lists.all.asp`, Handlers)

- **Architecture / Hardcoded Admin Logic:** Hardcoded user IDs (`1`, `73`, `76`) control access to setting list privacy to "Private" or "Shared" in `listsNew.asp` and `listsEdit.asp`.
- **Architecture / In-UI Dev Notes:** `lists.asp` renders an HTML `div` with "Admin Tasks" explicitly to the screen for admin users. This belongs in a project tracker.
- **Architecture / Postgres Migration:** `lists.all.asp` executes an MS Access cross-database JOIN (`FROM [users] IN 'arabicUsers.mdb'`) to fetch the list creator's username.
- **CRITICAL / Security:** Multiple handlers (`listsWord.insert.asp`, `listsEdit.update.asp`, `listsToggle.asp`) are vulnerable to SQL injection because integer parameters (`wordID`, `listID`) are directly concatenated into SQL queries without casting to `CInt()` or parameterization.

## Team Tasks (`team.tasks.asp`, `team.task.*.asp`)

- **Status: DELETED.** The entire team tasks system was orphaned and has been permanently removed in the `cleanup-dead-code` branch.

## Database Architecture Issues

- **DB / `tasksVotes` (`arabicManager`)**: Stale / Broken. Originally related to the now-deleted team tasks system.
- **DB / `tasksLabels` (`arabicManager`)**: Write-only orphan. Related to the deleted team tasks system.
- **DB / `log` (`arabicManager`)**: Disabled. Same performance log schema as arabicSearch's `log` table. The INSERT code in `includes/inc_team.asp` was removed. Never written to; never read.
- **DB / `arabicSchools` & `arabicSandbox`**: Dead databases. References effectively removed.

## Include Files & Dead Code Issues

- **Cleanup Status:** The `cleanup-dead-code` branch successfully permanently purged almost all dead includes and removed global duration tracking (`durationMs`) that served no purpose.
- **Include Duplication (updated):** The old `team/inc/*` duplicate include tree was removed. Canonical helpers now live under `includes/functions/`. Keep future changes centralized there to avoid reintroducing drift.

## Admin Panel (`admin.*`)

- **Security / Missing Auth:** `admin/allowEditToggle.asp`, `admin/readOnlyToggle.asp`, and other inline handler files do not check `session("role")`, potentially allowing unauthorized toggles if accessed directly (though obscured).
- **SQL Injection:** Administrative unlock queries inside `admin/locked.asp` directly append raw URL parameters to queries (e.g. `WHERE id="&wordID`), creating SQL injection vulnerabilities even in the admin section.

## Dashboard & Users (`dashboard.asp`, `users.asp`)

- **Performance / N+1 Queries:** `dashboard.asp` executes over 40 individual `SELECT COUNT(*)` queries sequentially to build the dashboard matrix. This should be refactored into a single aggregation query using `CASE WHEN` statements in PostgreSQL.
- **Architecture / Hardcoded Exclusions:** `users.asp` heavily hardcodes user IDs to exclude from the directory: `id NOT IN (2,5,6,7,36,37,48)`. This should be replaced with a `is_system_user` boolean or explicit role filtering mechanism in Django.
- **Data Integrity:** The developer explicitly left a comment in `users.asp` indicating that `loginTimeUTC` is "A MESS!! day & month get mixed up".
- **Documentation:** `dashboard.asp` queries an undocumented `taskNoPlural` table to find words without a plural form block.
- **Architecture / Missing Auth:** `dashboard.asp` and `dashboard.lists.asp` do not contain any `session("role")` guarding at the top of the file, inadvertently exposing the administrative metrics to the public.

## API & Statistics (`json.asp`, `stats.topSearch.asp`)

- **CRITICAL / Security:** `json.asp` is vulnerable to SQL injection. It parses the comma-separated `relData` query string parameter and concatenates the value directly into the SQL query without parameterization (e.g. `hebrewClean LIKE '%"&search&"%'`).
- **CRITICAL / Security:** `stats.topSearch.asp` concatentates the `q` query string variable directly into the `WHERE` clause (`WHERE typed LIKE """& q &"%"""`), enabling SQL injection.
- **Architecture / Hardcoded Data:** The yearly analytics table in `stats.asp` is completely hardcoded in the HTML structure and stale since 2021.
- **Architecture / Manual Serialization:** `json.asp` builds JSON strings manually through VBScript string concatenation loops, increasing the risk of syntax errors if the data contains unescaped quotes or invalid characters.

## Admin Panel Tools (`admin.*.asp`)

- **Cleanup Status:** The entire subset of `admin.searchHistory.*.asp` and `admin.monitors.asp` pages has been deleted as obsolete technical debt.
- **Security / Authorization Logic:** `admin/userControl.asp` explicitly checks `session("role") <> 15`. This indicates fragile and inconsistent RBAC implementation across admin tools.
- **SQL Injection Risk:** Many admin handlers, such as `admin/wordsShort.asp`, take `request("sStrNew")` and concatenate it directly into `INSERT` queries, violating parameterization standards even for admins.

## Dictionary Core Pages (`default.asp`, `word.asp`, `label.asp`, `sentence.asp`, `activity.asp`)

- **CRITICAL / Security:** `label.asp` concatenates `Request("id")` directly into `SELECT labelName FROM labels WHERE id=` without validation or parameterization.
- **Architecture / Missing Auth:** `activity.asp` does not contain a session guard, exposing all edit history and contributor names to the public.
- **Architecture / Complexity:** `word.asp` is ~1000 lines with 12+ table joins — the single most complex page. It should be refactored into a Django view with clean serializers.
- **Architecture / Complexity:** `default.asp` is ~950 lines handling search, logging, rendering, and soundex matching — multiple responsibilities that should be split into separate views.

## Media Pages (`team/mediaEdit.asp`, `team/mediaNew.asp`, `team/mediaControl.asp`)

- **UX / Responsiveness (Partial Fix):** The media edit/new/control pages were not responsive on mobile. Fixed in Feb 2026: `#dashboard` now uses `max-width` instead of a fixed `800px` width, inputs/selects in the form are set to `width: 100%`, and `mediaControl.asp`'s wide table is wrapped in `overflow-x: auto`. However, **horizontal scrolling still exists on real mobile devices** (verified on device). Full responsiveness of `mediaControl.asp`'s 12-column table on small screens requires a deeper redesign (e.g., a card-based layout or column-hiding pattern). Low priority — team-only page.

## Team Handlers (`team/*.asp`) — see `handlers.md` for full analysis

- **Security / SQL Injection:** `team/new.insert.asp` concatenates ~25 form fields into an INSERT query using only `gereshFix()` (single-quote doubling), which is insufficient protection.
- **Architecture / No CSRF:** All team action handlers execute database mutations via GET requests with no CSRF token protection.
- **Dead Code:** Old dead handlers like `team/user.insert.asp` and status toggles have been deleted to clean up the codebase.
- **Architecture / Hardcoded Constants:** `word.correct.quick.asp` has `Const lblCnt = 22` — will silently break if labels are added beyond 22.
- **Architecture / Abandoned TODO:** `new.insert.asp` line 93 contains `'TEMP SEARCH STRING VALUE - REMOVE CODE WHEN FIELD REMOVE FROM DB` — this TODO has been pending for years.
