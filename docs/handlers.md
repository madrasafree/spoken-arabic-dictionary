# Handlers Documentation

Server-side action handlers — ASP files that receive form submissions or GET requests, execute database mutations, and redirect. They do **not** render full HTML pages.

---

## Word Status Handlers

**Status: DELETED.** The four word status handlers (`word.correct.asp`, `word.erroneous.asp`, `word.reset.asp`, `word.hide.asp`) were removed during the `cleanup-dead-code` effort as they contained significant issues (debug output, SQL injection, dead timezone logic) and are obsolete. Below is documentation for historical context.

These handlers followed an almost identical pattern: auth check → read params → build timestamp → INSERT into `history` → UPDATE `words` → redirect.

### `team/word.correct.asp`

**Trigger:** Editor clicks "Approve" on a word.
**Auth:** `(session("role") and 2) = 0` → requires bit-2 role (Editor+).
**DB:** `arabicWords` (`history` INSERT, `words` UPDATE)

**Flow:**
1. Reads `wordID` and `status` from `Request`.
2. Sets `action = 3` (verified), `status = 1` (approved).
3. Inserts a history record and updates the word status.
4. Redirects to `word.asp?id=`.

**Issues found:**
- **Debug output left in production:** Lines 10-16 contain `response.write` calls that dump `wordID`, `action`, `statusOld`, `status` to the browser **before** the redirect. Since `Response.Redirect` follows, these are emitted as HTML before the 302 header, which causes a "headers already sent" error in strict servers. In IIS with buffering enabled, the output is silently discarded — but it's still dead code.
- **SQL Injection:** `wordID` and `statusOld` are taken from `Request()` and concatenated directly into the INSERT query (line 36).
- **Dead code:** `openDB "arabicWords"` on line 27 is called but immediately followed by `openDbLogger` on line 31 which opens a *different* connection. The first `openDB` connection is never used. (`openDB` is commented out on line 30.)
- **Legacy GoDaddy timezone logic:** Lines 18-24 check if the host is `ronen.rothfarb.info` to add 9 hours. This domain is long-dead. This block is effectively dead code on the current `milon.madrasafree.com` host.

---

### `team/word.erroneous.asp`

**Trigger:** Editor flags a word as erroneous.
**Auth:** Same bit-2 check.
**DB:** `arabicWords` (`history` INSERT, `words` UPDATE)

**Flow:**
1. Reads `wordID`, `status`, `errorType`, `explain`.
2. Sets `action = 2` (error report), `status = -1`.
3. Inserts history with error types and explanation, updates word status.
4. Redirects to `word.asp?id=`.

**Issues found:**
- **Same debug output problem** as `word.correct.asp` (lines 11-21).
- **SQL Injection:** `errorTypes` and `explain` from `Request()` go directly into the INSERT query (line 41).
- **Same dead GoDaddy timezone block** (lines 25-31).

---

### `team/word.reset.asp`

**Trigger:** Editor resets a word to "unchecked" status.
**Auth:** Same bit-2 check.
**DB:** `arabicWords` (`history` INSERT, `words` UPDATE)

**Flow:**
1. Sets `action = 1`, `status = 0` (unchecked).
2. Same INSERT/UPDATE pattern.

**Issues found:**
- Identical debug output and SQL injection issues as above.
- Same dead GoDaddy timezone block.

---

### `team/word.hide.asp`

**Trigger:** Editor toggles word visibility (hide ↔ unhide).
**Auth:** Same bit-2 check.
**DB:** `arabicWords` (`history` INSERT, `words` UPDATE)

**Flow:**
1. Reads `id` via `CLng(Request("id"))` — **this is the only handler that validates the ID type** using `CLng`.
2. Queries current `show` value, toggles it.
3. Inserts history and flips `show` in `words`.
4. Redirects to `../word.asp?id=`.

**Issues found:**
- Debug `response.write` on lines 33-34.
- `explain` field from `Request()` goes directly into INSERT (line 50) — SQL injection.
- Same dead GoDaddy timezone block (lines 37-43).
- Note: Uses relative redirect (`../word.asp`) instead of `baseA` like the others. Inconsistent.

---

### Common pattern across all four

| Issue | correct | erroneous | reset | hide |
|---|---|---|---|---|
| Debug `response.write` | ✅ | ✅ | ✅ | ✅ |
| SQL injection | ✅ | ✅ | ✅ | ✅ |
| Dead GoDaddy timezone | ✅ | ✅ | ✅ | ✅ |
| No CSRF protection | ✅ | ✅ | ✅ | ✅ |
| `CLng` on ID | ❌ | ❌ | ❌ | ✅ |

**Django migration note:** These four handlers should collapse into one Django view with an `action` parameter and proper Django ORM transactions.

---

## `team/word.correct.quick.asp`

**Trigger:** Editor quick-approves a word from the dashboard unchecked list.
**Auth:** `session("role") < 7` → requires Editor (7) or Admin (15).
**DB:** `arabicWords` (`words` SELECT + UPDATE, `labels` + `wordsLabels` SELECT, `history` INSERT), `arabicUsers` (`users` SELECT)

**Flow:**
1. Loads the entire word record via `SELECT * FROM words WHERE id=`.
2. Copies every single field into Old/New variable pairs (they're identical — this is a "no change" approval).
3. Sets `status = 1` (approved), `action = 4` (quick-fix).
4. Builds a massive ~40-field INSERT into `history`.
5. Does a separate UPDATE for the `searchString` memo field (workaround for MS Access error 80040e57 — text field too long for single INSERT).
6. Updates the word record.
7. Opens `arabicUsers` to fetch username/email (unused in the redirect flow — leftover from removed email notification).
8. Redirects to `/dashboard.lists.asp?listID=1`.

**Issues found:**
- **Massive debug output:** ~60 `response.write` lines dumping every field value. Line 10 always writes `"OOPS! There seems to be an error"` before any logic runs — this was likely a dev-mode debug header that was never removed.
- **SQL injection** on `wordID` (line 51).
- **Unused DB query:** Lines 244-262 open `arabicUsers` to fetch `uName` and `userEmail`, but these variables are never used after the email redirect was disabled (line 269 checks for dead domain `rothfarb.info`).
- **Hardcoded label count:** `Const lblCnt = 22` (line 33) — will break silently if labels are added beyond 22.
- **Dead commented-out code:** Lines 276-281 contain old email redirect logic.

---

## `team/new.insert.asp`

**Trigger:** Contributor submits a new word via `word.new.asp`.
**Auth:** `(session("role") and 2) = 0` → bit-2 check.
**DB:** `arabicWords` (`words` INSERT, `wordsLabels` INSERT, `wordsRelations` INSERT, `wordsShort` INSERT, `labels` SELECT), `arabicUsers` (`users` SELECT)

**Flow:**
1. Reads all word fields from `Request()`, applies `gereshFix()` for quote escaping.
2. Runs `soundex()` on Hebrew and Arabic for phonetic search.
3. Inserts into `words` table with ~25 fields.
4. Gets `MAX(id)` for the new word.
5. Optionally inserts a YouTube link into `wordsLinks`.
6. Loops through label checkboxes and inserts into `wordsLabels`.
7. Processes word relations via a `SELECT CASE` block to normalize directional relation types.
8. If Hebrew/Arabic is a single character, adds to `wordsShort`.
9. Opens `arabicUsers` to fetch username/email for (disabled) email notification.
10. Redirects to `word.asp?id=`.

**Issues found:**
- **SQL injection** on multiple fields concatenated into INSERT.
- **Unused email code:** Lines 245-271 fetch username/email but the email redirect (line 269) only fires for dead domain `rothfarb.info`.
- Orphaned `response.write` debug lines (139, 147-148, 154, 267).
- `searchString` field is hardcoded to empty string with comment "TEMP SEARCH STRING VALUE - REMOVE CODE WHEN FIELD REMOVE FROM DB" (line 93-95) — this TODO has been pending for years.

---

## `team/user.insert.asp`

**Status: DELETED.** This file was permanently removed in the `cleanup-dead-code` branch.

**Trigger:** New volunteer registration form submission.
**Auth:** **None** — line 11 has the auth check **commented out**: `'If (session("role") and 2) = 0 then Response.Redirect "login.asp"`.
**DB:** `arabicUsers` (`users` SELECT + INSERT)

**Flow:**
1. Reads username, password, name, email, gender from `Request()`.
2. Generates a random 4-digit email verification code.
3. Checks if email already exists → redirects to `joinus.asp` if taken.
4. Checks if username already exists → redirects to `joinus.asp` if taken.
5. Inserts the new user with role `3` (contributor).
6. Sets session variables and auto-logs in the new user.
7. If on `rothfarb.info`, redirects to `send_email_verify.php` (dead domain → never fires).
8. Otherwise redirects to `profile.asp?id=`.

**Issues found:**
- **Auth check disabled:** The auth guard is commented out (line 11). This is **intentional** — the registration page must be accessible to unauthenticated users. But the lack of any anti-spam protection (CAPTCHA, rate limiting) is a concern.
- **Debug output:** Line 10 `Response.Write "TOP of code"`, line 43 `"opened DB"`, line 78 SQL dump, line 104 `"END OF INSERT"`.
- **Password stored with minimal escaping:** `getString()` wraps password with single quotes and replaces `'` with `&#39;` — no hashing visible. The password field in the DB may be stored in cleartext or with only client-side hashing.
- **Dead email verification:** Lines 106-108 only trigger for `rothfarb.info`. On the live site, email verification is **skipped entirely**.
- **GoDaddy timezone block** on line 65 checks `rothfarb.info` (dead).

---

## `team/edit.update.asp`

**Trigger:** Contributor saves an edit to an existing word.
**Auth:** `(session("role") and 2) = 0` → bit-2 check. Also checks `allowEdit` flag.
**DB:** `arabicWords` (multiple tables: `words` SELECT + UPDATE, `history` INSERT, `wordsLabels` DELETE + INSERT, `wordsMedia` SELECT, `wordsRelations` INSERT), `arabicUsers` (`users` SELECT)
**Lines:** 590 — the largest handler in the codebase.

**Not fully analyzed here.** Key structure:
1. Loads old word values.
2. Reads new values from form.
3. Compares old vs. new for every field to build a diff.
4. Inserts a full history record with all Old/New pairs.
5. Updates the word record.
6. Rebuilds label associations (DELETE all + INSERT new).
7. Handles new word relations.

**Issues found:**
- Same SQL injection and debug output patterns.
- At 590 lines, it's the most complex handler and a prime candidate for refactoring.

---

## Media Handlers

### `team/mediaNew.asp` / `team/mediaNew.insert.asp`

- **mediaNew.asp**: Form to add a new audio/video/image media record to a word.
- **mediaNew.insert.asp**: Inserts into `media` table. Checks `allowEdit` flag.

### `team/mediaEdit.asp` / `team/mediaEdit.update.asp`

- **mediaEdit.asp**: Form to edit an existing media record.
- **mediaEdit.update.asp**: Updates the `media` table and logs to `history`.

### `team/mediaControl.asp`

- Lists all media files for a given word. Read-only UI.

---

## Summary: Dead Code Patterns Across All Handlers

| Pattern | Files affected |
|---|---|
| `response.write` debug output | All handlers |
| GoDaddy `ronen.rothfarb.info` timezone check | correct, erroneous, reset, hide, user.insert |
| `rothfarb.info` email redirect (never fires) | new.insert, user.insert, word.correct.quick |
| Commented-out `'openDB` followed by `openDbLogger` | All handlers |
| `'response.end` commented-out breakpoints | All handlers |
| Full HTML scaffold (`<html><head>`) in handlers that redirect | word.correct.quick, new.insert, user.insert |

---

## PHP Email Scripts

**Status: DELETED.** All five PHP files handling email notifications were permanently removed in the `cleanup-dead-code` branch because they were effectively dead code (only firing for dead domains) and presented security risks.

Four PHP files handle email notifications. **All are effectively dead** — the ASP handlers that redirect to them only do so when the host is `rothfarb.info` (dead domain). On the live site, these scripts are **never called**.

### `admin.monitors.email.php`

**Trigger:** Button click on `admin.monitors.asp`.
**Purpose:** Sends a nightly monitoring report with list average view count to `admin@madrasafree.com`.
**Issues:** Takes `listsAvgVC` from `$_GET` unsanitized and injects it into the HTML email body. Debug output.

### `team/send_email.newWord.php`

**Trigger:** (Dead) `new.insert.asp` redirect after new word submission.
**Purpose:** Sends admin notification email with new word ID and Arabic text.
**Issues:** Takes `wordID`, `arabic`, `username` from `$_GET` unsanitized — XSS risk in email body.

### `team/send_email.php`

**Trigger:** (Dead) General confirmation email to contributor.
**Purpose:** Sends a "thank you for contributing" email to the user who added a word.
**Issues:** Sends to `admin@madrasafree.com` (line 13) instead of the contributor's email — likely a bug. Uses `$_GET` params unsanitized.

### `team/send_email_verify.php`

**Trigger:** (Dead) `user.insert.asp` redirect after new account registration.
**Purpose:** Sends email verification link to the new user.
**Issues:**
- The verification link on line 38 points to the dead domain: `http://ronen.rothfarb.info/arabic/team/user.verifyEmail.asp`.
- The file `user.verifyEmail.asp` **does not exist** in the codebase — it was never created or has been deleted.
- The redirect on line 71 also points to the dead domain.
- References external images on `image.ibb.co` which may have expired.
- Debug `echo` statements on lines 14-21.

### `team/send_email_wordEdit.php`

**Trigger:** (Dead) `edit.update.asp` redirect after word edit.
**Purpose:** Sends confirmation email to the editor.
**Issues:** Same `$_GET` unsanitized pattern. Sends to `admin@madrasafree.com` instead of the editor. References external `image.ibb.co` images.

### Summary

**All five PHP email scripts are dead code.** They are never invoked on the live site because the ASP handlers only redirect to them when running on the dead `rothfarb.info` domain. In Django, email notifications should be reimplemented using Django's `send_mail()` with proper templates.
