# Technical Issues & Cleanup Tracker

This document tracks technical debt, dead code, and other codebase issues discovered during analysis that should be addressed prior to or during the Django migration.

## Dead Code & Includes

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

- **CRITICAL / Security:** The handlers (`team.task.edit.update.asp` and `team.task.vote.asp`) are vulnerable to SQL injection via the unescaped `tID` parameter (`WHERE id="&tID`).
- **Architecture / Leftover Dev Output:** Handlers include full HTML scaffolding (`head`, `body`) and "To-Do" lists (`<ol id="fix">`) before executing their database logic, but then issue a standard `Response.Redirect`. This generates unnecessary overhead and represents orphaned dev-mode debugging code.
- **Performance / N+1 Queries:** The main loop in `team.tasks.asp` runs an `N+1` sub-query (`SELECT votes FROM tasksVoting WHERE taskID=...`) for every single task loaded on the page to fetch its vote count.

## Database Architecture Issues

- **DB / `tasksVotes` (`arabicManager`)**: Stale / Broken. Intended as an aggregate vote count per task (pre-computed from `tasksVoting`). Never written by any ASP page — the aggregation code was never completed or was removed.
- **DB / `tasksLabels` (`arabicManager`)**: Write-only orphan. Labels/tags associated with tasks. Rows are inserted in `team.task.new.insert.asp` when a new task is created, but the table is **never queried** anywhere in the codebase.
- **DB / `log` (`arabicManager`)**: Disabled. Same performance log schema as arabicSearch's `log` table. The INSERT code in `team/inc/inc.asp` is commented out. Never written to; never read.
- **DB / `arabicSchools` & `arabicSandbox`**: Dead databases. `arabicSandbox` was a testing DB removed along with test files. `arabicSchools` no longer exists. Both are still referenced in `admin.log.duration.asp`.

## Include Files & Dead Code Issues

- **Dead files — `inc/`**: `inc/top_admin.asp`, `inc/header2016x.asp`, `inc/header_admin.asp`, `inc/inc_admin.asp`, `inc/inc_onlineNEW.asp`, `inc/inc_sql.asp`, `inc/top.links.asp`, `inc/top.temp.asp`, `inc/topNav.asp`, `inc/trailer.2022.asp` are not included anywhere.
- **Dead files — `team/inc/`**: `team/inc/inc.asp`, `team/inc/header.asp`, `team/inc/top.asp`, `team/inc/trailer.asp`, `team/inc/topTeam.asp`, `team/inc/inc_online.asp` are not included by any active page.
- **Dead code within active files**: `inc/time.asp` (`isrTime()`, `dateToStr()`), `inc/functions/soundex.asp` (buggy `soundex()`), `inc/functions/string.asp` (`getString()`), `team/inc/time.asp` (`intToStr()`, `AR2UTC()`).
- **Duplicates**: `inc/functions/string.asp` and `team/inc/functions/string.asp`, `inc/functions/functions.asp` and `team/inc/functions.asp`, `inc/functions/soundex.asp` and `team/inc/functions/soundex.asp` (different implementations).

## Admin Panel (`admin.*`)

- **Security / Missing Auth:** `admin.allowEditToggle.asp`, `admin.readOnlyToggle.asp`, and other inline handler files do not check `session("role")`, potentially allowing unauthorized toggles if accessed directly (though obscured).
- **Architecture / Dead DBs:** `admin.log.duration.asp` continues to attempt to connect to and parse logs from `arabicSchools` and `arabicSandbox`, which no longer exist.
- **SQL Injection:** Administrative unlock queries inside `admin.locked.asp` directly append raw URL parameters to queries (e.g. `WHERE id="&wordID`), creating SQL injection vulnerabilities even in the admin section.

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

- **Security / Authorization Logic:** `admin.searchHistory.asp` and its variants use `if session("role") < 7 then Redirect`, which means Editors (Role 7) and Admins (Role 15) can view it. However, `admin.monitors.asp` uses `session("role") < 14`, and `admin.userControl.asp` explicitly checks `session("role") <> 15`. This indicates fragile and inconsistent RBAC implementation across admin tools.
- **SQL Injection Risk:** Many admin handlers, such as `admin.wordsShort.asp`, take `request("sStrNew")` and concatenate it directly into `INSERT` queries, violating parameterization standards even for admins.
- **Architecture / Logic Duplication:** The entire `searchHistory` suite consists of 6 nearly identical physical ASP files that only differ by a single `WHERE` string condition. In Django, this should be collapsed into a single paginated API view with query/filter parameters.
- **Documentation:** `admin.monitors.asp` queries an undocumented MS Access database called `arabicLogs.mdb` (`monitors` table), which is not listed in `db.md`.

## Dictionary Core Pages (`default.asp`, `word.asp`, `label.asp`, `sentence.asp`, `activity.asp`)

- **CRITICAL / Security:** `label.asp` concatenates `Request("id")` directly into `SELECT labelName FROM labels WHERE id=` without validation or parameterization.
- **Architecture / Missing Auth:** `activity.asp` does not contain a session guard, exposing all edit history and contributor names to the public.
- **Architecture / Complexity:** `word.asp` is ~1000 lines with 12+ table joins — the single most complex page. It should be refactored into a Django view with clean serializers.
- **Architecture / Complexity:** `default.asp` is ~950 lines handling search, logging, rendering, and soundex matching — multiple responsibilities that should be split into separate views.
- **Architecture / Duplication:** `default.min.asp` duplicates most of `default.asp` logic. In Django, this should be a single view with a `?minimal=true` flag or a separate serializer.

## Team Handlers (`team/*.asp`) — see `handlers.md` for full analysis

- **Security / SQL Injection:** All status handlers (`word.correct.asp`, `word.erroneous.asp`, `word.reset.asp`, `word.hide.asp`) concatenate `Request()` values directly into INSERT/UPDATE queries. Only `word.hide.asp` validates with `CLng()`.
- **Security / SQL Injection:** `team/new.insert.asp` concatenates ~25 form fields into an INSERT query using only `gereshFix()` (single-quote doubling), which is insufficient protection.
- **Security / SQL Injection:** `team/user.insert.asp` concatenates username, password, email directly into INSERT.
- **Architecture / No CSRF:** All team action handlers execute database mutations via GET requests with no CSRF token protection.
- **Dead Code / Debug Output:** Every handler contains `response.write` debug lines that dump variable values to the browser before the redirect. These are swallowed by IIS buffering but are still dead code. `word.correct.quick.asp` has ~60 such lines and always outputs "OOPS! There seems to be an error" on line 10.
- **Dead Code / GoDaddy Timezone:** Five handlers contain a `ronen.rothfarb.info` host check to add 9 hours for GoDaddy's US timezone. This domain has been dead for years.
- **Dead Code / Email Notifications:** `new.insert.asp`, `user.insert.asp`, and `word.correct.quick.asp` fetch username/email from `arabicUsers` for email notifications, but the redirect to the PHP email sender only fires for the dead domain `rothfarb.info`. On the live site, **no email notifications are sent**.
- **Security / No Email Verification:** `user.insert.asp` has the auth check commented out (intentionally, for registration), but the email verification redirect only fires on the dead domain. New accounts are created with **no email verification** on the live site.
- **Security / Password Storage:** `user.insert.asp` stores the password via `getString()` which only does quote escaping — no hashing is visible server-side. Passwords may be stored in cleartext.
- **Architecture / Hardcoded Constants:** `word.correct.quick.asp` has `Const lblCnt = 22` — will silently break if labels are added beyond 22.
- **Architecture / Abandoned TODO:** `new.insert.asp` line 93 contains `'TEMP SEARCH STRING VALUE - REMOVE CODE WHEN FIELD REMOVE FROM DB` — this TODO has been pending for years.
