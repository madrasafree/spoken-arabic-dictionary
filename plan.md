# Madrasa Spoken Arabic Dictionary — Improvement Plan

## 🧭 Strategic Vision

Transform the legacy ASP/Access dictionary into a modern, maintainable, SEO-strong, AI-powered Arabic learning platform — while keeping the site live and Google rankings intact throughout the process.

## 🏛️ Architecture Decision

| | Current | Target |
|---|---|---|
| Backend | Classic ASP (VBScript) | **Django (Python) or FastAPI** |
| Database | MS Access `.mdb` | **PostgreSQL** |
| Frontend | Server-rendered HTML | **Django templates + React components where needed** |
| Hosting | GoDaddy Windows/IIS | **Modern Linux hosting (Render / Railway / VPS)** |
| Audio | Embedded (Clypit/YouTube) | **Hosted files + AI TTS (Palestinian dialect)** |
| Search | Custom Soundex | **Morphological + phonetic + relevance ranking** |
| Auth | Manual/closed | **Django auth, reopened post-migration** |

> **Note on Stack:** Django is aligned with the OpenEdX ecosystem. However, FastAPI might offer faster development, especially with AI agents. This decision should be finalized before starting Phase 1.

## 🗺️ Migration Strategy: Gradual (Strangler Fig Pattern)

Rather than a risky "big bang" rewrite, migrate feature by feature:

- **Phase 0** → Stabilize legacy (bug fixes, cleanup)
- **Phase 1** → New stack setup + database migration
- **Phase 2** → Migrate core pages (word, search, home)
- **Phase 3** → Migrate user/auth/lists/team features
- **Phase 4** → AI content features (audio, sentences)
- **Phase 5** → Madrasa ecosystem integration

Run old and new in parallel behind a reverse proxy (Cloudflare) — swap pages one by one. **Zero downtime. No Google ranking loss.**

## 🔑 URL & SEO Strategy

Since the site ranks strongly on Google — this is **critical**:

| Current URL | New URL | Strategy |
|---|---|---|
| `/word.asp?id=123` | `/word/123/` or `/word/123/slug` | 301 redirect old → new |
| `/label.asp?id=5` | `/label/5/` | 301 redirect |
| `/lists.asp` | `/lists/` | 301 redirect |

**Action items:**

- [ ] Create and submit a `sitemap.xml` to Google Search Console **now** (before migration)
- [ ] Set up Google Search Console if not already done
- [ ] Document all existing URL patterns before migration
- [ ] Implement 301 redirects at Cloudflare or Django level
- [ ] Consider SEO-friendly slug URLs: `/word/123/yalla` (id + Arabic word transliteration)

## Phase 0 — Stabilize Legacy (Start Now)

**Goal:** Stop the bleeding, fix known issues, no new features.

### 🐛 Bug Fixes

- [ ] **High Priority:** Fix login flow (currently manual/broken for regular users)
- [ ] **High Priority:** Fix list creation (currently not functional)
- [ ] Remove dead database references (arabicSchools, arabicSandbox) from `admin.log.duration.asp`

### 🧹 Code Cleanup

- [ ] Audit all files — identify dead/unused pages
- [ ] Extract copy-pasted logic into shared includes
- [ ] Reorganize flat root files into feature folders:
    - `/word/` → `word.asp`, `word.edit.asp`, `word.new.asp`, `word.history.asp`
    - `/sentence/` → `sentence.asp`, `sentenceNew.asp`, `sentence.edit.asp`
    - `/lists/` → `lists.asp`, `listsNew.asp`, `listsEdit.asp`, etc.
    - `/label/` → `label.asp`, `labels.asp`
    - `/user/` → `login.asp`, `profile.asp`, `users.asp`
    - `/admin/` → all `admin.*.asp` files
    - `/games/` → `games.mem.*.asp`
    - `/stats/` → `stats.asp`, `activity.asp`, `dashboard.asp`
- [ ] Add `docs/file-inventory.md` — document every file's purpose and status (live/dead)
- [ ] Complete `docs/pages/pages.md` and `docs/db.md`

### 🔒 Security

- [ ] Audit SQL queries for injection vulnerabilities (MS Access + ASP classic)
- [ ] Review session management and auth levels
- [ ] Ensure admin pages (auth level 15) are properly protected

## Phase 1 — New Stack Setup & Database Migration

**Goal:** Get the new stack running with real data, not yet public.

### 🛠️ Setup

- [ ] Create a new repo: `madrasafree/spoken-arabic-dictionary-v2`
- [ ] Set up Django project with PostgreSQL
- [ ] Set up Django REST Framework for API endpoints
- [ ] Set up React (bundled via Vite) for interactive components
- [ ] Apply Madrasa branding/design system from the start
- [ ] Connect to Cloudflare for DNS (keep old site live)

### 🗄️ Database Migration

- [ ] **High Priority:** Write Python script to migrate data directly from local `.mdb` files to PostgreSQL.
- [ ] Design PostgreSQL schema (based on existing Access schema + improvements)
- [ ] Key tables: `words`, `labels`, `sentences`, `lists`, `list_words`, `users`, `media`, `search_log`, `edit_history`, `tasks`
- [ ] Write migration scripts (Python)
- [ ] Validate migrated data (word count ~9,000, check integrity)
- [ ] Add proper **indexing** from day one (word text, Hebrew translation, search fields)

### 🔐 Auth System

- [ ] Implement Django auth with user levels (anonymous / registered / team / admin)
- [ ] Plan for reopening registration post-migration
- [ ] SSO consideration: shared login with Madrasa WordPress + OpenEdX (future)

## Phase 2 — Core Pages Migration (First Public Phase)

**Goal:** Launch the new stack for read-only pages. Search, word view, home.

### 🔍 Search (Highest Priority)

The current Soundex-based search has wrong results and wrong ordering. Replace with:

- [ ] **Morphological analysis** — Arabic root/pattern matching (consider `camel-tools` Python library)
- [ ] **Phonetic matching** — Hebrew transliteration → Arabic phonetics
- [ ] **Fuzzy matching** → Handle typos in both Hebrew and Arabic script
- [ ] **Relevance ranking** — Exact match > starts with > contains > phonetic > morphological
- [ ] **Full-text search index** — PostgreSQL `tsvector` or Elasticsearch (if scale demands)
- [ ] **Multi-script search** — Hebrew text, Arabic script, and Hebrew transliteration of Arabic
- [ ] **Search analytics** — Log what users search for (already exists, keep it)

### 📄 Core Pages

- [ ] Home / search page (`default.asp` → `/`)
- [ ] Word detail page (`word.asp` → `/word/<id>`)
- [ ] Label/category page (`label.asp` → `/label/<id>`)
- [ ] Labels list (`labels.asp` → `/labels/`)
- [ ] About page (`about.asp` → `/about/`)
- [ ] Stats page (`stats.asp` → `/stats/`)

### 🎨 UX & Design

- [ ] Apply Madrasa branding and design system
- [ ] Mobile-first responsive design (RTL support for Arabic)
- [ ] Improve word card layout — Arabic word, Hebrew translation, transliteration, dialect tag, audio player, sentences
- [ ] Add dialect tagging display (Palestinian / MSA)

## Phase 3 — User, Team & Content Features

**Goal:** Enable login, content contribution, team workflow.

### 👤 Users & Registration

- [ ] Reopen registration (Hebrew-speaking learners + Arabic/Hebrew team members)
- [ ] User profiles (`profile.asp` → `/profile/<id>`)
- [ ] User roles: **Anonymous** (read) / **Registered** (lists, contribute) / **Team** (review, edit) / **Admin**

### ✍️ Word Contribution & Review

- [ ] Word submission form (`word.new.asp` → `/word/new/`)
- [ ] Word edit form (`word.edit.asp` → `/word/<id>/edit/`)
- [ ] Edit history (`word.history.asp` → `/word/<id>/history/`)
- [ ] **Team review queue** — Make it easier for team + teachers to approve/reject words

### 👩‍🏫 Teacher Workflow

- [ ] **Community Lists:** Decide on lists strategy: keep community lists? Teacher-created lists for students?
- [ ] Lists pages (`lists.asp` → `/lists/`)
- [ ] Create/edit lists (fix the current broken flow)
- [ ] Connect lists to OpenEdX — teachers assign word lists as learning activities

### 📈 Team Task Management

- [ ] Migrate `team.tasks.asp` → `/team/tasks/`
- [ ] Improve team dashboard UI
- [ ] Task voting, assignment, subtasks

### 🎲 Games

- [ ] Migrate memory games (`games.mem.asp` → `/games/memory/`)
- [ ] Consider expanding games (quiz, fill-in-the-blank using sentences)

## Phase 4 — AI Content Features

**Goal:** Use AI to expand and improve dictionary content.

### 🔊 Audio

- [ ] **Task:** Inventory existing audio (~1000 words) and their sources (Clypit/YouTube).
- [ ] **Host audio files** ourselves (S3 / Cloudflare R2) — stop depending on Clypit
- [ ] **AI TTS for Palestinian dialect** — Evaluate options (e.g., ElevenLabs, Google TTS, Microsoft Azure Arabic TTS)
- [ ] **Bulk generate audio** for the ~9,000 existing words
- [ ] Add audio player component to word page (React component)
- [ ] Allow team to record and upload human audio (preferred over TTS where available)

### 📝 Sentences

- [ ] **AI-generate example sentences** per word (Palestinian dialect, Hebrew translation)
- [ ] **Bulk add new words** via an AI-assisted workflow, with all changes logged.
- [ ] Team reviews and approves AI-generated sentences before publishing
- [ ] Add sentences to word detail page

### 🧠 Linguistic Improvements

- [ ] Add **vowelization (tashkeel)** to Arabic words where missing
- [ ] Add **word root** field
- [ ] Add **part of speech** tagging
- [ ] Add **dialect tag** (Palestinian / MSA / other)
- [ ] AI-assisted content review — flag low-quality or missing content

## Phase 5 — Madrasa Ecosystem Integration

**Goal:** Connect the dictionary to WordPress and OpenEdX.

### 🔗 Integration Points

| Integration | How |
|---|---|
| **Madrasa WordPress** | Link from marketing site; share branding; maybe embed word widget |
| **OpenEdX LMS** | Teachers create word lists → assigned as LMS activities; SSO login |
| **Shared Auth** | Single sign-on across dictionary + LMS (OAuth2 / JWT) |
| **Shared Branding** | Consistent design language across all Madrasa products |

### 🌐 Public API

- [ ] Build a public REST API (`/api/v1/words/`, `/api/v1/search/`, etc.)
- [ ] Used internally by React components and future mobile app
- [ ] Could be opened to external developers / researchers

## ✅ Key Decisions & Next Steps

1.  **Architecture:** Finalize the backend choice before Phase 1: **Django** (for OpenEdX alignment) or **FastAPI** (for development speed).
2.  **Hosting:** Evaluate and select a hosting provider for the new stack (e.g., Render, Railway, Vercel).
3.  **Audio Hosting:** Proceed with **Cloudflare R2** for hosting audio files.
4.  **Registration:** Registration will reopen in Phase 3, after the core site is stable and team workflows are in place.
5.  **OpenEdX SSO:** This is a **long-term goal**. It will be planned after the core dictionary migration is complete.
