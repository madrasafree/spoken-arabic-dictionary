# Madrasa Spoken Arabic Dictionary — Migration & Development Plan

**Last updated:** 2026-02-21
**Status:** Active — Django confirmed, Phase 0 in progress.

---

## Strategic Vision

Transform the legacy ASP/Access dictionary into a modern, maintainable, SEO-strong Arabic learning platform — while keeping the site live and Google rankings intact throughout the process.

---

## Architecture Decisions (Finalized)

| Layer | Current | Target |
|---|---|---|
| Backend | Classic ASP (VBScript) | **Django (Python)** |
| Database | MS Access `.mdb` | **PostgreSQL** |
| Frontend | Server-rendered HTML | **Django templates + React/Vite components where needed** |
| Repo structure | Root-only ASP | **Monorepo: Django in `/v2/` subfolder** |
| Hosting | GoDaddy Windows/IIS | **TBD (Render / Railway / VPS — Phase 1 decision)** |
| Audio | Embedded (Clypit/YouTube) | **Cloudflare R2 (self-hosted files)** |
| Search | Custom Soundex | **Morphological + phonetic + relevance ranking** |
| Auth | Manual/closed | **Django auth, reopened in Phase 3** |
| CDN/Routing | Cloudflare (DNS only) | **Cloudflare as reverse proxy — route pages one by one** |

**Django over FastAPI:** Chosen for OpenEdX alignment and ecosystem fit. Decision is final.

**Monorepo over new repo:** Django code goes into `/v2/` in this repository. No separate repo needed for a small team.

---

## Migration Strategy: Strangler Fig

Build the new stack alongside the live ASP site. Route individual pages to the new stack via Cloudflare as they are ready. Zero downtime, no Google ranking loss.

```
User → Cloudflare → [old GoDaddy IIS]     (default, unchanged)
                  → [new Django hosting]   (per-URL rules added incrementally)
```

**Data sync during migration (Phases 2–3):** The ASP site continues to receive edits while the new stack is being built. A sync strategy must be defined before Phase 2 launch — options: read-only PostgreSQL during transition, dual-write, or final cutover window. This is a required Phase 1 deliverable (see P1-7).

---

## URL & SEO Strategy

The site ranks strongly on Google. URL continuity is critical.

| Current URL | Target URL | Method |
|---|---|---|
| `/word.asp?id=123` | `/word/123/` | 301 redirect |
| `/label.asp?id=5` | `/label/5/` | 301 redirect |
| `/lists.asp` | `/lists/` | 301 redirect |

All 301 redirects must be in place before the Cloudflare routing switch in Phase 2.

**Pre-migration SEO tasks (Phase 0):**
- Document all existing URL patterns
- Create and submit `sitemap.xml` to Google Search Console
- Establish Google Search Console baseline

> ⚠ **Warning on ASP file reorganization:** The old plan included reorganizing ASP files into feature folders (`/word/`, `/sentence/`, etc.). **Do not do this.** ASP URL paths map directly to file locations on IIS. Moving files breaks URLs, breaks SEO, and requires IIS redirect rules for every moved file. The old ASP code runs until it's replaced by Django — leave the file structure as-is.

---

## Phase 0 — Stabilize & Document

**Goal:** Prepare the ASP site for safe migration. No new features. Stop the bleeding, not fix everything.

| ID | Task | Status |
|---|---|---|
| P0-1 | Document all existing URL patterns before migration | |
| P0-2 | Create `sitemap.xml` and submit to Google Search Console | |
| P0-3 | Security audit: SQL injection vulnerabilities + admin auth protection | |
| P0-4 | Audit all files — identify dead/unused pages (candidates for deletion) | **DONE** (`cleanup-dead-code`) |
| P0-5 | Complete and reorganize `docs/` folder for new stack readiness | **DONE** (`cleanup-dead-code`) |

**Out of scope for Phase 0:**
- List creation parameter bug (`?LID=` vs `?id=`) (logged in issues)
- Media edit parameter bug (`?wordID=` vs `?id=`) (logged in issues)
- Login flow fix (same reason)
- ASP file folder reorganization (see SEO warning above)

---

## Phase 1 — New Stack Foundation

**Goal:** Get Django + PostgreSQL running privately with real data. Not yet public.

**Repo structure:** All new code lives in `/v2/` inside this monorepo.

| ID | Task |
|---|---|
| P1-1 | Decide hosting for new stack (Render / Railway / VPS) |
| P1-2 | Set up Django project in `/v2/` (PostgreSQL + Vite/React) |
| P1-3 | Design PostgreSQL schema — include linguistic fields from day one (see below) |
| P1-4 | Write MS Access → PostgreSQL data migration script |
| P1-5 | Validate migrated data (~9,000 words, integrity check) |
| P1-6 | Design Cloudflare routing strategy (per-page cutover plan) |
| P1-7 | Define data sync strategy: how ASP edits stay in sync during Phases 2–3 |
| P1-8 | Set up CI/CD pipeline (GitHub Actions: test + deploy) |
| P1-9 | Set up staging environment for new stack |
| P1-10 | Implement Django auth (levels: Anonymous / Registered / Team / Admin) |
| P1-X1 | Set up error monitoring (Sentry) for new stack |
| P1-X2 | Define RTL/multi-script frontend strategy (Arabic + Hebrew + Latin) |
| P1-X3 | Database backup strategy for PostgreSQL |

### Linguistic Fields — In Schema from Day One

These fields belong in the initial PostgreSQL schema design, not a later migration:

| Field | Reason |
|---|---|
| `tashkeel` (vowelization) | Affects display and audio; wrong to retrofit |
| `word_root` | Core Arabic linguistic feature |
| `part_of_speech` | Affects search, display, games |
| `dialect` | Palestinian / MSA / other — already implicit, make explicit |

---

## Phase 2 — Core Pages, First Public Launch

**Goal:** Launch new stack for read-only pages. Switch Cloudflare routing. First public milestone.

| ID | Task |
|---|---|
| P2-1 | Implement 301 redirects for all legacy URLs |
| P2-2 | Overhaul search: morphological + phonetic + fuzzy + relevance ranking |
| P2-3 | Build core read-only pages: home, word, label, labels, about, stats |
| P2-4 | Design modern word card UI (RTL, mobile-first, Madrasa design system) |
| P2-5 | Deploy to hosting + switch Cloudflare routing |
| P2-6 | SEO verification post-launch (Search Console + Core Web Vitals) |
| P2-X4 | Performance baseline: measure current site, set Core Web Vitals targets |

---

## Phase 3 — Users, Team & Content

**Goal:** Enable login, content contribution, team workflow.

| ID | Task |
|---|---|
| P3-1 | Reopen public registration |
| P3-2 | User profiles page |
| P3-3 | Implement user roles: Anonymous / Registered / Team / Admin |
| P3-4 | Word submission, edit, and history pages |
| P3-5 | Team review queue — streamline word approval workflow |
| P3-6 | Word lists feature (fix broken ASP flow + migrate) |
| P3-7 | Migrate memory games |

---

## Phase 4 — Audio Infrastructure

**Goal:** Own the audio stack. Stop depending on Clypit/YouTube.

| ID | Task |
|---|---|
| P4-1 | Inventory existing audio files and coverage (Clypit + YouTube) |
| P4-2 | Migrate audio hosting to Cloudflare R2 |
| P4-3 | Build audio player component for word page (React) |

**AI content tasks (not tracked in GitHub Issues):**
These can run in parallel on the old ASP site or as standalone projects, independently of the migration phases:
- AI TTS evaluation for Palestinian dialect (ElevenLabs / Azure / Google)
- Bulk audio generation for ~9,000 words
- AI-generated example sentences (with team review workflow)
- Bulk word addition via AI-assisted workflow

---

## Phase 5 — API & Ecosystem

**Goal:** Open the dictionary to external use and connect to Madrasa ecosystem.

| ID | Task |
|---|---|
| P5-1 | Build public REST API: `/api/v1/words/`, `/api/v1/search/`, `/api/v1/labels/` |
| P5-2 | OpenEdX SSO integration (long-term goal, plan after core migration) |

**Madrasa WordPress integration:** Link from marketing site, share branding — no engineering work needed in this phase.

**OpenEdX LMS word lists connection:** Deferred — too early. Plan after SSO is in place.

---

## Search Improvements (Phase 2 detail)

The current Soundex-based search produces wrong results and wrong ordering. Replace with:

- **Morphological analysis** — Arabic root/pattern matching (`camel-tools` Python library)
- **Phonetic matching** — Hebrew transliteration → Arabic phonetics
- **Fuzzy matching** — Handle typos in Hebrew and Arabic script
- **Relevance ranking** — Exact match > starts with > contains > phonetic > morphological
- **Full-text search index** — PostgreSQL `tsvector`
- **Multi-script search** — Hebrew, Arabic script, Hebrew transliteration of Arabic
- **Search analytics** — Keep existing search logging

---

## Key Decisions Reference

| Decision | Chosen |
|---|---|
| Backend | **Django** |
| Database | **PostgreSQL** |
| Frontend | **React + Vite** (Django templates where sufficient) |
| Repo | **Monorepo** (`/v2/` subfolder) |
| Audio hosting | **Cloudflare R2** |
| Hosting provider | **TBD** (Phase 1 task P1-1) |
| Migration pattern | **Strangler Fig** via Cloudflare routing |
| Registration reopen | **Phase 3** |
| OpenEdX SSO | **Phase 5 / long-term** |
| AI content tasks | **Outside GitHub Issues** — run independently |
| Linguistic fields | **Phase 1 schema** (not Phase 4) |
