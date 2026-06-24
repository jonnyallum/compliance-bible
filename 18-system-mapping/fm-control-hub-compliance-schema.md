# FM Control Hub Compliance Schema

## Plain English Summary

This schema describes how FM Control Hub should structure compliance data so that statutory tasks, assets, evidence, contractors, permits, actions, dashboards and AI retrieval all work from the same source of truth.

It is written for a Supabase-backed product, but the logic can be reused in any relational compliance system.

## Why It Matters in Facilities Management

Compliance systems fail when evidence is stored separately from assets, tasks, owners and defects. A fire alarm service report, for example, is only useful if the system knows the site, asset, due date, contractor, report status, defects and next escalation.

The schema below supports Compliance Hub evidence packs, FM Control Hub workflows and AI/RAG answers that can cite structured records rather than vague notes.

## Core Principles

- Use relational records instead of isolated documents.
- Link evidence to site, asset, task, contractor and compliance area.
- Separate recurring planned tasks from completed evidence.
- Separate inspection completion from defect close-out.
- Keep status values simple and consistent.
- Store source links and AI/RAG tags for retrieval.
- Track escalation as data, not only email.
- Design for audit export from day one.

## Step-by-Step Process

1. Create the site and building structure.
2. Add assets and compliance areas.
3. Define task templates and recurrence rules.
4. Generate scheduled compliance tasks.
5. Link contractors and competent persons.
6. Upload evidence against completed tasks.
7. Create actions for failures, defects or missing records.
8. Escalate overdue or high-risk records.
9. Feed dashboards from task and action status.
10. Index approved records with AI/RAG tags.

## Recommended Supabase Tables

| Table | Purpose | Key fields |
|---|---|---|
| `sites` | Estate, attraction, building or campus | `id`, `name`, `address`, `region`, `site_type`, `status` |
| `locations` | Areas within a site | `id`, `site_id`, `parent_location_id`, `name`, `location_type`, `public_access` |
| `assets` | Physical compliance assets | `id`, `site_id`, `location_id`, `asset_type`, `name`, `reference`, `criticality`, `status` |
| `compliance_areas` | Legal/control categories | `id`, `name`, `source_type`, `source_url`, `risk_category` |
| `compliance_requirements` | Specific duties or controls | `id`, `compliance_area_id`, `title`, `description`, `default_frequency`, `evidence_required`, `rag_tags` |
| `task_templates` | Recurring task definitions | `id`, `requirement_id`, `asset_type`, `frequency_rule`, `lead_time_days`, `requires_contractor`, `requires_permit` |
| `scheduled_tasks` | Generated task instances | `id`, `template_id`, `site_id`, `asset_id`, `due_date`, `owner_id`, `status`, `risk_rating` |
| `evidence_files` | Uploaded evidence metadata | `id`, `task_id`, `asset_id`, `file_url`, `file_type`, `uploaded_by`, `evidence_date`, `review_status` |
| `contractors` | Contractor organisations | `id`, `name`, `trade`, `approval_status`, `insurance_expiry`, `risk_rating` |
| `contractor_documents` | Contractor evidence | `id`, `contractor_id`, `document_type`, `expiry_date`, `review_status`, `file_url` |
| `permits` | Permit-to-work records | `id`, `site_id`, `contractor_id`, `permit_type`, `start_at`, `expires_at`, `status`, `close_out_status` |
| `risk_assessments` | FM and task risk assessments | `id`, `site_id`, `location_id`, `title`, `risk_rating`, `review_date`, `status` |
| `actions` | Defects, remedials and audit actions | `id`, `source_type`, `source_id`, `owner_id`, `priority`, `due_date`, `status`, `close_out_evidence_id` |
| `escalations` | Escalation events | `id`, `source_type`, `source_id`, `level`, `reason`, `escalated_to`, `created_at`, `resolved_at` |
| `audit_events` | Immutable history | `id`, `actor_id`, `entity_type`, `entity_id`, `event_type`, `created_at`, `metadata` |

## Relationships

- One `site` has many `locations`, `assets`, `scheduled_tasks`, `permits` and `risk_assessments`.
- One `asset` belongs to one `site` and may belong to one `location`.
- One `compliance_area` has many `compliance_requirements`.
- One `compliance_requirement` has many `task_templates`.
- One `task_template` generates many `scheduled_tasks`.
- One `scheduled_task` can have many `evidence_files` and many `actions`.
- One `contractor` can have many `contractor_documents`, `permits` and task assignments.
- One `permit` can link to contractor, asset, RAMS evidence and close-out evidence.
- One `action` can originate from a task, permit, risk assessment, contractor review or audit.
- One `escalation` can attach to overdue tasks, high-risk actions, failed evidence reviews or expired contractor documents.

## Example Status Values

Use controlled values so dashboards and AI retrieval stay reliable.

Task status:

- `not_due`
- `due_soon`
- `in_progress`
- `evidence_uploaded`
- `complete`
- `complete_with_actions`
- `overdue`
- `failed`
- `cancelled`

Evidence review status:

- `pending_review`
- `accepted`
- `rejected`
- `needs_clarification`
- `superseded`

Action status:

- `open`
- `in_progress`
- `blocked`
- `awaiting_contractor`
- `awaiting_budget`
- `complete`
- `closed_no_action_with_reason`

Escalation level:

- `site_owner`
- `fm_manager`
- `head_of_estates`
- `director`
- `board`

## Evidence Upload Logic

Evidence should not simply mark a task complete.

Recommended logic:

1. User uploads file against a task, asset and compliance area.
2. System records evidence date, uploader and document type.
3. Task moves to `evidence_uploaded`.
4. Reviewer checks whether the evidence matches the requirement.
5. If accepted with no defects, task becomes `complete`.
6. If accepted with defects, task becomes `complete_with_actions` and action records are created.
7. If rejected, task returns to `in_progress` or `overdue` depending on due date.
8. Evidence remains immutable; corrections require a new upload linked as a superseding record.

## Task Recurrence Logic

Recurring tasks should be generated from `task_templates`.

Recommended recurrence fields:

- `frequency_type`: daily, weekly, monthly, quarterly, six_monthly, annual, risk_based, custom.
- `frequency_interval`: number value for custom cycles.
- `due_day_rule`: fixed day, weekday, last day, anniversary.
- `lead_time_days`: when task appears as due soon.
- `grace_period_days`: limited tolerance before escalation.
- `next_due_from`: due date or completion date.
- `seasonal_rule`: used for visitor peaks, winter checks or closed seasons.

Example:

- Weekly fire alarm test: generates every 7 days from due date.
- Annual emergency lighting duration test: generates from previous due date.
- Risk-based PAT: generates from asset risk profile and last test date.

## Escalation Logic

Escalation should be automatic for high-risk missed tasks and failed evidence.

Recommended rules:

- Life-safety task overdue by 1 day: escalate to FM manager.
- Critical defect logged: escalate immediately to site owner and FM manager.
- Statutory inspection overdue beyond grace period: escalate to head of estates.
- Evidence rejected twice: escalate to contract owner.
- Contractor insurance expired: suspend approval status and block new work orders.
- Permit expired while still open: escalate immediately and require close-out review.
- High-risk action blocked by budget: escalate to director with risk acceptance record.

## Dashboard Widgets

Recommended widgets:

- Statutory compliance percentage by site.
- Overdue life-safety tasks.
- Critical open actions.
- Compliance by area: fire, water, asbestos, electrical, lifting, equipment, COSHH, waste.
- Evidence awaiting review.
- Contractor documents expiring in 30 days.
- Live permits and expired open permits.
- Repeated defects by asset.
- High-risk actions awaiting budget.
- Board summary: green, amber, red, blocked.

## AI/RAG Tags

Use tags that combine legal area, FM process, asset type and interview relevance.

Recommended tag groups:

- `law:fire-safety-order`
- `law:coshh`
- `law:control-of-asbestos`
- `law:electricity-at-work`
- `law:loler`
- `law:puwer`
- `law:work-at-height`
- `law:waste-duty-of-care`
- `process:risk-assessment`
- `process:permit-to-work`
- `process:contractor-management`
- `process:evidence-review`
- `asset:fire-alarm`
- `asset:emergency-lighting`
- `asset:lift`
- `asset:water-system`
- `asset:asbestos-register`
- `audience:fm-control-hub`
- `audience:compliance-hub`
- `audience:longleat-interview`

## FM Actions

A Facilities Manager should:

- agree the compliance areas and task templates before data import;
- avoid creating duplicate asset records;
- define evidence acceptance rules;
- appoint reviewers for high-risk evidence;
- keep contractor documents linked to work orders and permits;
- use action records for every failed inspection or service defect;
- review dashboards weekly;
- use board-level reports for blocked or high-risk compliance decisions.

## Evidence to Keep

- Schema version history.
- Compliance requirement definitions.
- Task template configuration.
- Evidence acceptance rules.
- User role and permission records.
- Audit event logs.
- Dashboard exports.
- Escalation records.
- Data migration/import records.
- AI/RAG indexing rules.

## Review Frequency

- Schema review: quarterly during product build, then at least annually.
- Task template review: after legal changes, contractor advice, incidents or operational changes.
- Dashboard review: weekly by FM, monthly by senior leadership.
- AI/RAG tag review: after new compliance pages, new modules or retrieval errors.
- Access permission review: quarterly and after role changes.

## Red Flags

- Evidence files uploaded without review status.
- Defects hidden inside PDF reports and not converted into actions.
- Tasks close automatically when a file is uploaded.
- Contractor expiry dates are not linked to approval status.
- No immutable audit trail.
- AI answers can retrieve documents but not current compliance status.
- Recurrence dates reset incorrectly after late completion.
- Dashboard is green while high-risk actions remain open.

## Longleat / Visitor Attraction Relevance

A visitor attraction needs compliance data that supports real-time operational decisions. During a power outage, fire panel fault or animal enclosure defect, the system should show critical assets, current actions, competent contractors, permits, emergency contacts and evidence history quickly.

Longleat-style reporting should also separate public-facing risk, animal welfare infrastructure, heritage assets and backstage operations.

## FM Control Hub Mapping

This document is the FM Control Hub schema baseline. It maps directly to:

- compliance calendar;
- asset register;
- contractor control;
- permit-to-work;
- evidence library;
- remedial action tracker;
- escalation dashboard;
- AI compliance assistant.

## Compliance Hub Mapping

Compliance Hub should consume the same records for:

- legal evidence packs;
- audit dashboards;
- compliance status reports;
- policy and procedure generation;
- RAG-grounded answers;
- board-level compliance summaries.

## Example Scenario

A LOLER thorough examination report is uploaded for a passenger lift. The report identifies a defect but says the lift can remain in service subject to remedial action.

The upload moves the task to `evidence_uploaded`. The reviewer accepts the report, the task becomes `complete_with_actions`, a remedial action is created, the lift asset shows amber status and the dashboard tracks the action until evidence of repair is uploaded.

## Official / Authoritative Sources

- Supabase documentation: https://supabase.com/docs
- HSE managing risks and risk assessment at work: https://www.hse.gov.uk/risk/
- HSE managing contractors HSG159: https://www.hse.gov.uk/pubns/books/hsg159.htm
- HSE permit-to-work systems: https://www.hse.gov.uk/humanfactors/topics/ptw.htm
- GOV.UK waste duty of care code of practice: https://www.gov.uk/government/publications/waste-duty-of-care-code-of-practice
