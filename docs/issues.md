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
