---
name: Migration task
about: Migrate one ASP page to Django
labels: migration
---

## ASP file
`<!-- e.g. label.asp -->`

## Analysis (from analyze_asp.py)
- **Complexity:** HIGH / MEDIUM / LOW
- **Lines:**
- **Databases:**
- **SQL ops:** SELECT / INSERT / UPDATE / DELETE
- **Auth required:** public / user / team / admin
- **Injection risk:** yes / no

## Django target
- **View type:** TemplateView / CreateView / UpdateView / DetailView
- **App:** dictionary / accounts / search / manager

## Assigned to
- [ ] Claude Code
- [ ] Gemini / Antigravity

## Branch
`claude/migrate-label` or `gemini/migrate-label`

## Done when
- [ ] Django view written
- [ ] Template written
- [ ] ORM queries replace raw SQL
- [ ] Auth mixin replaces `session("role")` check
- [ ] PR opened + checklist passed
