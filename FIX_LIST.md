# Fix List

```yaml
ai_metadata:
  repo: compliance-bible
  document_type: fix_list
  version: 0.1.0
  rag_tags:
    - process:quality-audit
    - process:release-readiness
```

## Fixed in 0.1.0

- Fixed Supabase schema index ordering so indexes are declared after their target tables.
- Added missing AI/RAG metadata to compliance content and operational framework pages.
- Corrected README repository map naming for `12-permit-to-work`.
- Added `QUALITY_AUDIT.md`, `FIX_LIST.md`, `RELEASE_NOTES.md` and `VERSION`.

## Remaining Fixes

| Priority | Item | Reason |
|---|---|---|
| High | Execute `fm-control-hub-database-schema.sql` and `supabase-seed-data.sql` against a Supabase test database | Current pass reviewed structure but did not run a live database migration. |
| Medium | Split large libraries into mobile-first files | `fm-operational-template-library.md` and audit library are useful but long for phone reading. |
| Medium | Add dedicated visitor attraction compliance profile pages | Longleat relevance exists, but TODO profile pages remain incomplete. |
| Medium | Add remaining legal pages | First Aid, Fire Safety Act, Fire Safety England Regulations, Manual Handling, PPE, Waste Duty of Care and Environmental Protection Act remain open. |
| Low | Add automated link/source/metadata check script | Current audit used manual PowerShell checks. |

## Intentionally Not Fixed in This Pass

- Large files were not split because the user requested not to rewrite everything.
- Future TODO items were not marked complete without production files.
- Official source URLs were not replaced where they were already authoritative and working as content references.
