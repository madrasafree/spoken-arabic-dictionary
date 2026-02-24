# Database Documentation

All databases are MS Access `.mdb` files in `App_Data/` (gitignored, deployed separately).
Connection is opened via `OpenDbLogger(db, ...)` / `CloseDbLogger(db, ...)` in `includes/inc.asp`.

Cross-database foreign keys are not enforced by the DB engine — they are logical only.

See also: `docs/pages.md`, `docs/includes.md`

---

## Database Index

| Database | Status | Purpose |
|---|---|---|
| `arabicWords` | Live | Core dictionary: words, sentences, labels, lists, media, history |
| `arabicUsers` | Live | Users, authentication, feature flags |
| `arabicSearch` | Live | Search term analytics and history |
| `arabicManager` | Live | Team task management and community voting |
| `arabicLogs` | Live (admin-only) | System monitoring (scheduled job status) |

---

## `arabicWords`

**Used by:** ~40 pages including `default.asp`, `word.asp`, `label.asp`, `labels.asp`,
`sentence.asp`, `lists.asp`, `games.mem.asp`, `profile.asp`, team word/sentence edit pages.

### `words`

Main dictionary entries.

| Field | Type | Notes |
|---|---|---|
| `id` | INT PK | |
| `hebrew` | VARCHAR | Hebrew translation |
| `hebrewDef` | VARCHAR | Hebrew definition / gloss |
| `hebrewClean` | VARCHAR | Hebrew normalized for search |
| `hebrewCleanMore` | VARCHAR | Comma-separated additional Hebrew search variants |
| `arabic` | VARCHAR | Arabic script |
| `arabicWord` | VARCHAR | Hebrew transliteration |
| `arabicClean` | VARCHAR | Arabic normalized for search |
| `arabicCleanMore` | VARCHAR | Additional Arabic search variants |
| `arabicHeb` | VARCHAR | Alternative transliteration |
| `arabicHebClean` | VARCHAR | Normalized alternative transliteration |
| `arabicHebCleanMore` | VARCHAR | Additional variants |
| `pronunciation` | VARCHAR | Latin transliteration |
| `partOfSpeach` | INT | 0–9 part-of-speech code |
| `gender` | INT | 0=neutral, 1=masc, 2=fem, 3=unknown |
| `number` | INT | 0=uncountable, 1=singular, 2=dual, 3=plural, 4=unknown, 5=irrelevant, 6=collective |
| `binyan` | INT | Verb pattern (0–10); only relevant for verbs |
| `status` | INT | -1=suspect/error, 0=unchecked, 1=verified |
| `show` | BOOLEAN | Visibility flag |
| `imgLink` | VARCHAR | URL to image |
| `imgCredit` | VARCHAR | Image attribution text |
| `info` | VARCHAR | Additional notes |
| `example` | VARCHAR | Usage examples |
| `searchString` | VARCHAR | Extra search keywords |
| `creatorID` | INT FK | → `arabicUsers.users.id` |
| `creationTimeUTC` | DATETIME | UTC creation timestamp |
| `lockedUTC` | VARCHAR | Lock info for concurrent edit prevention (UTC + userID) |
| `root` | VARCHAR | Root / origin form |
| `link` | VARCHAR | External URL |
| `linkDesc` | VARCHAR | Description for the external link |
| `dialect` | VARCHAR | Dialect / variant notes |
| `origin` | VARCHAR | Etymology |

### `sentences`

Phrase and sentence examples.

| Field | Type | Notes |
|---|---|---|
| `id` | INT PK | |
| `hebrew` | VARCHAR | Hebrew sentence |
| `hebrewClean` | VARCHAR | Normalized Hebrew |
| `arabic` | VARCHAR | Arabic sentence |
| `arabicClean` | VARCHAR | Normalized Arabic |
| `arabicHeb` | VARCHAR | Hebrew transliteration |
| `arabicHebClean` | VARCHAR | Normalized transliteration |
| `info` | VARCHAR | Notes |
| `creator` | INT FK | → `arabicUsers.users.id` |
| `creationTimeUTC` | DATETIME | |
| `show` | BOOLEAN | Visibility |
| `status` | INT | Same scale as `words.status` |

### `wordsSentences`

Junction: words ↔ sentences.

| Field | Notes |
|---|---|
| `sentence` | FK → `sentences.id` |
| `word` | FK → `words.id` |
| `location` | Position / ordering within sentence |
| `merge` | Int controlling spacing/concatenation (e.g. 1=hyperlink w/o trailing space, 2=add space, etc) |

### `labels`

Topic / subject tags shown on the labels page.

| Field | Notes |
|---|---|
| `ID` | PK |
| `labelName` | Tag name (ordered alphabetically) |

### `wordsLabels`

Junction: words ↔ labels.

| Field | Notes |
|---|---|
| `wordID` | FK → `words.id` |
| `labelID` | FK → `labels.id` |

### `media`

Audio and video files attached to words.

| Field | Type | Notes |
|---|---|---|
| `ID` | INT PK | |
| `mType` | INT | 1=YouTube, 21=clyp.it, 22=SoundCloud, 23=local OGG |
| `mLink` | VARCHAR | External ID or local filename |
| `credit` | VARCHAR | Attribution text |
| `creditLink` | VARCHAR | Attribution URL |
| `description` | VARCHAR | |
| `speaker` | INT FK | → `arabicUsers.users.id` |
| `creationTime` | DATETIME | |

### `wordsMedia`

Junction: words ↔ media.

| Field | Notes |
|---|---|
| `wordID` | FK → `words.id` |
| `mediaID` | FK → `media.id` |

### `wordsRelations`

Semantic relationships between words.

| Field | Notes |
|---|---|
| `word1` | FK → `words.id` |
| `word2` | FK → `words.id` |
| `relationType` | See codes below |

**`relationType` codes:**

| Code | Meaning |
|---|---|
| 0 | Other |
| 1 | Hebrew synonyms |
| 2 | Arabic synonyms |
| 3 | Singular ↔ plural (word1=singular, word2=plural) |
| 4 | Masculine ↔ feminine |
| 5 | Antonyms |
| 6 | Similar in Arabic (but different meaning) |
| 7 | Similar in Hebrew (but different meaning) |
| 8 | Response / reply |
| 10 | Part of multi-word expression |
| 12 | Additional Hebrew meaning |
| 13 | Additional Arabic meaning |
| 20 | Derived form |
| 50 | Active participle |
| 52 | Passive participle |
| 54 | Verbal noun / infinitive |
| 60 | Passive form |
| 99 | Duplication / repetition |

### `wordsShort`

Single-character search optimization index.

| Field | Notes |
|---|---|
| `id` | PK |
| `sStr` | Single character or short string |
| `wordID` | FK → `words.id` |

### `lists`

User-created word lists.

| Field | Type | Notes |
|---|---|---|
| `id` | INT PK | |
| `listName` | VARCHAR | Title |
| `listDesc` | VARCHAR | Description |
| `privacy` | INT | 0=private, 1=link-only, 2=public, 3=shared |
| `type` | INT | List type code |
| `creator` | INT FK | → `arabicUsers.users.id` |
| `creationTimeUTC` | DATETIME | |
| `lastUpdateUTC` | DATETIME | |
| `viewCNT` | INT | View counter for public lists |

### `wordsLists`

Junction: words ↔ lists.

| Field | Notes |
|---|---|
| `listID` | FK → `lists.id` |
| `wordID` | FK → `words.id` |
| `pos` | Position / order within list |

### `listsUsers`

Lists bookmarked / favorited by users.

| Field | Notes |
|---|---|
| `list` | FK → `lists.id` |
| `user` | FK → `arabicUsers.users.id` |
| `pos` | Order in user's favorites |

### `history`

Full audit trail of word edits.

| Field | Notes |
|---|---|
| `id` | PK |
| `word` | FK → `words.id` |
| `user` | FK → `arabicUsers.users.id` |
| `action` | 1=new, 2=error report, 3=verified, 4=fix, 5=hide, 6=unhide, 7=archive, 8=restore |
| `actionUTC` | UTC timestamp |
| `showNew`, `showOld` | Visibility before/after |
| `hebrewNew`, `hebrewOld` | Hebrew before/after |
| `arabicNew`, `arabicOld` | Arabic before/after |
| `statusNew`, `statusOld` | Status before/after |
| `labelsNew`, `labelsOld` | Comma-separated label IDs before/after |
| *(other `New`/`Old` pairs)* | All main word fields tracked |
| `explain` | Reason for change |


### `taskNoPlural`

Undocumented view/table joining words to flag those missing a plural relation.
Queried by `dashboard.asp` and `dashboard.lists.asp` (List ID 13 and 14).

| Field | Notes |
|---|---|
| `word1` | FK → `words.id` |

---

## `arabicUsers`

**Used by:** `login.asp`, `profile.asp`, `includes/trailer.asp`, admin user management pages,
`team/` pages (session role checks).

### `users`

| Field | Type | Notes |
|---|---|---|
| `id` | INT PK | |
| `username` | VARCHAR | Login handle |
| `name` | VARCHAR | Real name |
| `password` | VARCHAR | Password (**likely cleartext** — `user.insert.asp` applies only `Replace(pwd,"'","''")`, no hash function) |
| `email` | VARCHAR | Email address |
| `role` | INT | Auth level — see table below |
| `userStatus` | INT | 1=active, 77=frozen, 88=suspended, 99=deleted |
| `about` | VARCHAR | User bio |
| `gender` | INT | 1=male, 2=female |
| `picture` | BOOLEAN | Has custom profile photo |
| `joinDateUTC` | DATETIME | Account creation date |

**`role` values** (matches AGENTS.md auth levels):

| Value | Meaning |
|---|---|
| 0 | Anonymous / failed login |
| 1–2 | Registered user |
| 3–5 | Contributor |
| 6–7 | Editor |
| 15 | Admin |

### `allowEdit`

Feature flags / site-wide switches.

| Field | Notes |
|---|---|
| `siteName` | PK — e.g. `'readonly'`, `'arabic'` |
| `allowed` | BOOLEAN — is the feature enabled |

### `loginLog`

Login audit trail. Written by `login.fixhref.asp` on successful login; read in admin dashboard.

| Field | Notes |
|---|---|
| `userID` | FK → `users.id` |
| `loginTimeUTC` | Timestamp |

---

## `arabicSearch`

**Used by (active):** `default.asp`, `default.min.asp` (write on every search); `stats.asp`,
`stats.topSearch.asp` (read).
**Legacy/deleted readers:** `admin.searchHistory.*.asp` (removed).

### `wordsSearched` — Live

Aggregate search term statistics. One row per unique search term, updated on every search.

| Field | Notes |
|---|---|
| `id` | PK |
| `typed` | Search term as entered |
| `searchCount` | Total number of searches for this term |
| `result` | 1=exact match, 2=soundex match, 9=no results; combined codes (11, 21, 91) also used |
| `translated` | Classification field — **never written via SQL**; shown in admin UI dropdowns only |

### `latestSearched` — Live

Per-search event log. One row per search event. Written by `default.asp` and `default.min.asp`.
The old admin readers (`admin.searchHistory.*.asp`) were deleted.

| Field | Notes |
|---|---|
| `searchTime` | UTC timestamp |
| `searchID` | FK → `wordsSearched.id` |


---

## `arabicManager`

**Used by (current code):** no active ASP pages.
**Historical usage:** old `team.tasks.asp`, `team.task.edit.asp`,
`team.task.new.insert.asp`, `team.task.edit.update.asp`, `team.task.vote.asp` (all deleted).

### `tasks`

| Field | Type | Notes |
|---|---|---|
| `id` | INT PK | |
| `title` | VARCHAR | Task title |
| `notes` | VARCHAR | Description / details |
| `project` | INT | Project / component grouping |
| `status` | INT | See codes below |
| `priority` | INT | 1=urgent, 2=important, 3=regular, 5=low, 99=none |
| `type` | INT | See codes below |
| `section` | INT | Site section affected — see codes below |
| `private` | BOOLEAN | Internal / hidden from public |
| `img` | BOOLEAN | Has screenshot attached |
| `dateStart` | DATETIME | Created / opened |
| `dateEdit` | DATETIME | Last modified |
| `dateEnd` | DATETIME | Completed |

**`status` codes:**

| Code | Meaning |
|---|---|
| 1 | In progress |
| 2 | Before next project |
| 3 | Next project |
| 9 | Future |
| 15 | Suggestions / ideas |
| 42 | Done |
| 99 | Cancelled |

**`type` codes:**

| Code | Meaning |
|---|---|
| 0 | Unclassified |
| 1 | Admin |
| 10 | Code — new feature |
| 11 | Code — improvement |
| 12 | Code — bug fix |
| 20 | Content — words |
| 21 | Content — multimedia |
| 29 | Content — other |

**`section` codes:**

| Code | Meaning |
|---|---|
| 0 | Other |
| 1 | Search engine |
| 2 | Word page |
| 3 | Personal lists |
| 4 | Fixed lists |
| 5 | Games |
| 6 | Sentences |

### `subTasks` — Live

| Field | Notes |
|---|---|
| `id` | PK |
| `task` | FK → `tasks.id` |
| `title` | Sub-task title |
| `place` | Order within parent task |
| `isDone` | BOOLEAN — completion status |

### `tasksVoting` — Live

One row per user per task they voted for.
Historical writer: `team.task.vote.asp` (deleted).
Max 3 active votes per user enforced in application code.

| Field | Notes |
|---|---|
| `taskID` | FK → `tasks.id` |
| `userID` | FK → `arabicUsers.users.id` |


---

## `arabicLogs`

**Used by (current code):** no active ASP page.
**Historical usage:** `admin.monitors.asp` (deleted).

### `monitors`

Tracks the last run time and health of scheduled/background jobs.

| Field | Notes |
|---|---|
| `mID` | PK — monitor type (1 = personal lists counter) |
| `status` | 1=OK, other=error |
| `actionUTC` | UTC timestamp of last run |

---

