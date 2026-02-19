# Known Issues

Dead code and dormant code found in the codebase.

---

## `admin.log.duration.asp`

### Dead sections referencing non-existent databases

`admin.log.duration.asp` opens `arabicSchools` and `arabicSandbox` and queries
their `log` tables. Both MDB files do not exist on the server — loading this admin
page will fail when it hits these sections.

- `admin.log.duration.asp:210-239` — `arabicSchools` section
- `admin.log.duration.asp:259-288` — `arabicSandbox` section

**Action:** delete both sections from the file.
