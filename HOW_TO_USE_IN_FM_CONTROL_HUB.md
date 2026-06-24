# How to Use This in FM Control Hub

```yaml
ai_metadata:
  repo: compliance-bible
  document_type: product_usage
  product: FM Control Hub
  rag_tags:
    - product:fm-control-hub
    - workflow:implementation
```

## Purpose

Use the Compliance Bible as the source content for FM Control Hub tasks, assets, evidence requirements, recurrence rules, audit checklists and AI assistant answers.

## Product Mapping

| Compliance Bible content | FM Control Hub feature |
|---|---|
| Legal pages | Compliance area records and AI reference source |
| Statutory compliance matrix | Recurring statutory task templates |
| FM operational templates | Digital forms and evidence capture |
| Audit checklist library | Audit module checklist definitions |
| Evidence retention policy | Retention category and legal hold logic |
| Database schema SQL | Supabase implementation baseline |
| Supabase seed data SQL | Initial product demo and test dataset |
| Tags taxonomy | RAG indexing and filter metadata |

## Implementation Steps

1. Import compliance areas from [Tags](TAGS.md) and [Statutory Compliance Matrix](18-system-mapping/statutory-compliance-matrix.md).
2. Apply [FM Control Hub database schema SQL](18-system-mapping/fm-control-hub-database-schema.sql).
3. Load [Supabase seed data SQL](18-system-mapping/supabase-seed-data.sql).
4. Convert the [FM Operational Template Library](16-templates/fm-operational-template-library.md) into form definitions.
5. Convert the [FM Audit Checklist Library](17-audit-checklists/fm-audit-checklist-library.md) into audit checklists.
6. Use [Evidence Retention Policy](18-system-mapping/evidence-retention-policy.md) for retention categories and legal hold.
7. Index key Markdown pages using the metadata and tag taxonomy.

## Minimum Product Readiness Rules

- A completed task must link to evidence.
- A service report with defects must create actions.
- Evidence upload should not automatically mean compliance.
- Contractor records must include expiry dates.
- Permits must have close-out states.
- Dashboards must show overdue tasks and open high-risk actions separately.

## Key Cross-Links

- [Master Index](MASTER_INDEX.md)
- [Quick Start](QUICK_START.md)
- [FM Control Hub compliance schema](18-system-mapping/fm-control-hub-compliance-schema.md)
- [FM Control Hub database schema SQL](18-system-mapping/fm-control-hub-database-schema.sql)
- [Supabase seed data SQL](18-system-mapping/supabase-seed-data.sql)
