-- FM Control Hub database schema
-- Target: Supabase Postgres
-- Purpose: operational compliance, assets, evidence, contractors, permits, audits and escalations.

create extension if not exists "pgcrypto";

create table if not exists sites (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  address text,
  site_type text not null default 'estate',
  region text,
  status text not null default 'active',
  created_at timestamptz not null default now()
);

create table if not exists locations (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  parent_location_id uuid references locations(id),
  name text not null,
  location_type text not null,
  public_access boolean not null default false,
  criticality text not null default 'medium',
  created_at timestamptz not null default now()
);

create unique index if not exists idx_locations_site_name on locations(site_id, name);

create table if not exists contractors (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  trade text not null,
  approval_status text not null default 'pending',
  insurance_expiry date,
  risk_rating text not null default 'medium',
  primary_contact text,
  emergency_contact text,
  created_at timestamptz not null default now()
);

create table if not exists contractor_documents (
  id uuid primary key default gen_random_uuid(),
  contractor_id uuid not null references contractors(id) on delete cascade,
  document_type text not null,
  file_url text,
  expiry_date date,
  review_status text not null default 'pending_review',
  reviewed_by text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create unique index if not exists idx_assets_site_reference on assets(site_id, reference);

create table if not exists assets (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  location_id uuid references locations(id),
  asset_type text not null,
  name text not null,
  reference text,
  criticality text not null default 'medium',
  condition_rating text,
  status text not null default 'active',
  installed_date date,
  replacement_due date,
  created_at timestamptz not null default now()
);

create unique index if not exists idx_requirements_area_title on compliance_requirements(compliance_area_id, title);

create table if not exists compliance_areas (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  source_type text not null,
  source_url text,
  risk_category text not null default 'operational',
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create unique index if not exists idx_task_templates_requirement_name on task_templates(requirement_id, name);

create table if not exists compliance_requirements (
  id uuid primary key default gen_random_uuid(),
  compliance_area_id uuid not null references compliance_areas(id) on delete cascade,
  title text not null,
  description text not null,
  default_frequency text not null,
  evidence_required text[] not null,
  applies_to_asset_type text,
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists task_templates (
  id uuid primary key default gen_random_uuid(),
  requirement_id uuid not null references compliance_requirements(id) on delete cascade,
  name text not null unique,
  frequency_type text not null,
  frequency_interval integer,
  lead_time_days integer not null default 14,
  grace_period_days integer not null default 0,
  next_due_from text not null default 'due_date',
  requires_contractor boolean not null default false,
  requires_permit boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists scheduled_tasks (
  id uuid primary key default gen_random_uuid(),
  template_id uuid references task_templates(id),
  site_id uuid not null references sites(id) on delete cascade,
  location_id uuid references locations(id),
  asset_id uuid references assets(id),
  contractor_id uuid references contractors(id),
  title text not null,
  due_date date not null,
  owner_name text not null,
  status text not null default 'not_due',
  risk_rating text not null default 'medium',
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists permits (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  location_id uuid references locations(id),
  contractor_id uuid references contractors(id),
  permit_type text not null,
  task_description text not null,
  start_at timestamptz not null,
  expires_at timestamptz not null,
  issuer_name text not null,
  acceptor_name text,
  status text not null default 'requested',
  close_out_status text not null default 'not_closed',
  emergency_controls text,
  created_at timestamptz not null default now()
);

create table if not exists risk_assessments (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  location_id uuid references locations(id),
  title text not null,
  assessment_type text not null,
  risk_rating text not null,
  owner_name text not null,
  review_date date not null,
  status text not null default 'current',
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists evidence_files (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  task_id uuid references scheduled_tasks(id),
  asset_id uuid references assets(id),
  contractor_id uuid references contractors(id),
  permit_id uuid references permits(id),
  risk_assessment_id uuid references risk_assessments(id),
  evidence_type text not null,
  file_url text not null,
  evidence_date date not null,
  retention_category text not null default 'standard_6_years',
  review_status text not null default 'pending_review',
  uploaded_by text not null,
  reviewed_by text,
  reviewed_at timestamptz,
  legal_hold boolean not null default false,
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists actions (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  source_type text not null,
  source_id uuid,
  title text not null,
  description text not null,
  priority text not null default 'medium',
  owner_name text not null,
  due_date date not null,
  status text not null default 'open',
  close_out_evidence_id uuid references evidence_files(id),
  created_at timestamptz not null default now(),
  closed_at timestamptz
);

create table if not exists escalations (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  source_type text not null,
  source_id uuid,
  level text not null,
  reason text not null,
  escalated_to text not null,
  status text not null default 'open',
  created_at timestamptz not null default now(),
  resolved_at timestamptz
);

create table if not exists audit_checklists (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  scope text not null,
  frequency text not null,
  owner_role text not null,
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists audit_findings (
  id uuid primary key default gen_random_uuid(),
  site_id uuid not null references sites(id) on delete cascade,
  audit_checklist_id uuid references audit_checklists(id),
  finding text not null,
  severity text not null,
  owner_name text not null,
  due_date date not null,
  status text not null default 'open',
  evidence_id uuid references evidence_files(id),
  created_at timestamptz not null default now()
);

create table if not exists interview_questions (
  id uuid primary key default gen_random_uuid(),
  category text not null,
  question text not null,
  expected_points text[] not null,
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists scenario_bank (
  id uuid primary key default gen_random_uuid(),
  scenario_type text not null,
  title text not null,
  prompt text not null,
  expected_actions text[] not null,
  rag_tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists audit_events (
  id uuid primary key default gen_random_uuid(),
  actor_name text not null,
  entity_type text not null,
  entity_id uuid not null,
  event_type text not null,
  metadata jsonb not null default '{}',
  created_at timestamptz not null default now()
);

create index if not exists idx_assets_site_type on assets(site_id, asset_type);
create index if not exists idx_tasks_due_status on scheduled_tasks(due_date, status);
create index if not exists idx_evidence_review on evidence_files(review_status, evidence_date);
create index if not exists idx_actions_status_priority on actions(status, priority, due_date);
create index if not exists idx_escalations_open on escalations(status, level);
create index if not exists idx_compliance_rag on compliance_areas using gin(rag_tags);
create index if not exists idx_evidence_rag on evidence_files using gin(rag_tags);
