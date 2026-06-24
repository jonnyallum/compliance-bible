# Quality Audit

```yaml
ai_metadata:
  repo: compliance-bible
  document_type: quality_audit
  version: 0.1.0
  audit_date: 2026-06-24
  rag_tags:
    - process:quality-audit
    - release:0.1.0
```

## Audit Scope

This audit checked the repository for:

- duplicate content;
- weak generic sections;
- missing official sources;
- broken internal links;
- inconsistent naming;
- TODO items marked complete without matching files;
- schema/table mismatches;
- missing AI/RAG metadata;
- files that are too long for mobile reading;
- Longleat content that is too generic.

## Summary

The repo is suitable for a `0.1.0` content release after this fix pass. The major clear defect was in the Supabase schema: unique indexes for several tables were declared before the tables existed. That has been fixed.

## Findings

| Area | Result | Notes |
|---|---|---|
| Duplicate content | Pass | No material duplicate pages found. Repeated section structures are intentional templates. |
| Weak generic sections | Pass with watch | Operational framework sections are practical and FM-specific. Some library entries are concise by design. |
| Missing official sources | Pass | Compliance and framework documents in legal/system areas include official or authoritative sources. |
| Broken internal links | Pass | Link check found no broken internal Markdown links. |
| Inconsistent naming | Fixed | README map corrected from `12-waste-environment` to `12-permit-to-work`. |
| TODO completion evidence | Pass with note | Completed template tasks are contained in `16-templates/fm-operational-template-library.md`, not separate files. |
| Schema/table mismatches | Fixed | Index creation order fixed in `fm-control-hub-database-schema.sql`. |
| Missing AI/RAG metadata | Fixed | Metadata blocks added to content documents that were missing them. |
| Mobile reading length | Risk accepted | Large library files remain long and should be split in a later mobile-polish pass. |
| Longleat relevance | Pass with watch | Longleat relevance exists in frameworks and product mapping; dedicated visitor-attraction profile pages remain on TODO. |

## Long Files

These files are intentionally comprehensive but not ideal for phone reading:

- `16-templates/fm-operational-template-library.md`
- `18-system-mapping/fm-control-hub-compliance-schema.md`
- `17-audit-checklists/fm-audit-checklist-library.md`

## Fixes Applied

- Fixed schema index ordering in `18-system-mapping/fm-control-hub-database-schema.sql`.
- Added missing AI/RAG metadata blocks to core compliance and framework documents.
- Corrected README repository map naming for the permit-to-work folder.
- Added release and audit artefacts.

## Residual Risks

- Long template and checklist libraries should eventually be split into smaller mobile-first files.
- TODO includes future legal pages and visitor-attraction profile pages that are correctly still incomplete.
- Supabase SQL has been structurally reviewed, but not executed against a live Supabase database in this pass.
