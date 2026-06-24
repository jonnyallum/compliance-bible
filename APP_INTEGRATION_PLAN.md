# App Integration Plan

```yaml
ai_metadata:
  repo: compliance-bible
  document_type: app_integration_plan
  next_target_version: 0.2.0
  rag_tags:
    - product:fm-control-hub
    - product:compliance-hub
    - product:integration-plan
    - release:0.2.0-target
```

## Plain English Summary

This plan defines how the Compliance Bible should feed FM Control Hub, Compliance Hub, Supabase and AI/RAG retrieval for the v0.2.0 integration target.

The aim is not to build every product feature at once. The aim is to move from a content library to a usable app-ready knowledge and evidence layer.

## Content Types to FM Control Hub Modules

| Content type | Source examples | FM Control Hub module |
|---|---|---|
| Legal compliance pages | HSWA, COSHH, asbestos, electrical, LOLER, PUWER, work at height | Compliance area library |
| Operational frameworks | Risk assessment, contractor management, permit-to-work | Workflow templates |
| Statutory compliance matrix | Fire, water, asbestos, electrical, lifting, equipment, COSHH, waste | Statutory compliance calendar |
| Template library | 50 FM operational templates | Digital forms and evidence capture |
| Audit checklist library | Fire, water, contractor, permit, evidence audits | Audit module |
| Evidence retention policy | Retention schedule and legal hold rules | Evidence library and retention workflow |
| FM Control Hub schema | Supabase schema and relationships | Database implementation baseline |
| Supabase seed data | Longleat-style demo data | Demo/test tenant setup |
| Tags taxonomy | Legal, process, asset, product, audience tags | Search filters and AI/RAG metadata |
| Quality audit and release notes | Audit findings and known limitations | Release governance and admin dashboard |

## Content Types to Compliance Hub Modules

| Content type | Compliance Hub module |
|---|---|
| Legal compliance pages | Legislation library |
| Official source links | Source attribution panel |
| FM actions and evidence sections | Evidence requirement library |
| Review frequency sections | Inspection frequency library |
| Red flags | Audit risk prompts |
| Interview talking points | Training and briefing snippets |
| Operational frameworks | Policy and procedure generator |
| Statutory compliance matrix | Compliance status dashboard |
| Audit checklist library | Audit checklist builder |
| Evidence retention policy | Retention and legal hold policy |
| Tags taxonomy | RAG indexing and retrieval filters |
| Release notes | Content version history |

## Supabase Import Order

Use this order so foreign keys and product workflows resolve cleanly:

1. `sites`
2. `locations`
3. `contractors`
4. `contractor_documents`
5. `assets`
6. `compliance_areas`
7. `compliance_requirements`
8. `task_templates`
9. `scheduled_tasks`
10. `permits`
11. `risk_assessments`
12. `evidence_files`
13. `actions`
14. `escalations`
15. `audit_checklists`
16. `audit_findings`
17. `interview_questions`
18. `scenario_bank`
19. `audit_events`

For v0.2.0, import only core site, location, asset, compliance area, requirement, task template, audit checklist and demo scenario records. Live customer evidence should not be seeded.

## RAG Chunking Strategy

Chunk by semantic section, not arbitrary token size.

Recommended chunk units:

- one `Plain English Summary` chunk per page;
- one duty/legal requirement chunk per compliance page;
- one `FM Actions` chunk;
- one `Evidence to Keep` chunk;
- one `Review Frequency` chunk;
- one `Red Flags` chunk;
- one product mapping chunk;
- one official sources chunk;
- one template per chunk in the template library;
- one audit checklist per chunk in the audit library;
- one matrix row group per compliance area in the statutory matrix;
- one schema table or relationship group per schema chunk.

Recommended metadata:

- `repo`
- `file_path`
- `document_type`
- `heading`
- `compliance_area`
- `asset_type`
- `process_tag`
- `product_tag`
- `audience_tag`
- `official_source_present`
- `version`

Retrieval rules:

- Prefer exact legal and process tags before semantic similarity.
- Boost chunks with official source links for legal answers.
- Boost `FM Actions`, `Evidence to Keep` and `Red Flags` for operational questions.
- For Longleat questions, boost `audience:longleat-interview` and visitor-attraction chunks.

## AI Assistant Prompts

### FM Control Hub Compliance Assistant

System behaviour:

> You are an FM compliance assistant for UK Facilities Management. Answer in plain English. Ground answers in retrieved Compliance Bible content. Prioritise legal duties, practical FM actions, evidence, review frequency and escalation. Do not invent statutory frequencies where the source says risk-based. If evidence is missing or a competent person is required, say so clearly.

User prompt pattern:

> Using the Compliance Bible, explain what an FM should do about: [issue]. Include immediate action, evidence to keep, owner, escalation trigger and relevant source section.

### Evidence Review Assistant

System behaviour:

> Review uploaded evidence against the required compliance task. Do not mark compliance complete just because a file exists. Identify whether the evidence is dated, relevant, complete, linked to the right site or asset, and whether defects require actions.

### Audit Assistant

System behaviour:

> Generate audit questions from the relevant Compliance Bible checklist and statutory matrix. Convert failed answers into findings with severity, owner, due date and evidence requirement.

### Longleat Interview Prep Assistant

System behaviour:

> Help the user prepare for a Longleat-style FM interview. Use visitor attraction context, public safety, animal welfare, estate infrastructure, contractors, board communication and evidence-led FM language.

## Dashboard Widgets

Minimum dashboard widgets for v0.2.0:

- Statutory compliance status by site.
- Overdue life-safety tasks.
- Evidence awaiting review.
- Critical open actions.
- Contractor documents expiring in 30 days.
- Live permits and expired open permits.
- Compliance by area: fire, water, asbestos, electrical, lifting, equipment, COSHH, work at height and waste.
- High-risk defects awaiting budget or board decision.
- Audit findings by severity.
- Longleat visitor-attraction risk snapshot for demo tenant.

## Minimum Viable Integration for v0.2.0

The v0.2.0 integration should deliver:

- Supabase schema applied successfully in a test project.
- Seed data loaded for one Longleat-style demo estate.
- Compliance area library populated from current content.
- Statutory task templates created from the matrix.
- Evidence upload records linked to task, asset and compliance area.
- Basic audit checklist module using current checklist library.
- RAG index built from Markdown chunks with metadata.
- AI assistant answers grounded in retrieved chunks with source file references.
- Dashboard showing overdue tasks, evidence review, actions and contractor expiry.
- Release note showing known limits and remaining TODOs.

## Out of Scope for v0.2.0

- Full customer multi-tenant permissions model.
- Complete mobile UI for all templates.
- Automated legal update monitoring.
- Full incident management workflow.
- Live production migration without a test Supabase run.
