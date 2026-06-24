-- FM Control Hub Supabase seed data
-- Assumes fm-control-hub-database-schema.sql has been applied.

insert into sites (name, address, site_type, region, status)
values
  ('Longleat Estate', 'Longleat, Warminster, Wiltshire', 'visitor_attraction', 'South West England', 'active')
on conflict do nothing;

insert into locations (site_id, name, location_type, public_access, criticality)
select id, 'Main House', 'heritage_building', true, 'high' from sites where name = 'Longleat Estate'
union all
select id, 'Safari Drive-Through', 'visitor_route', true, 'critical' from sites where name = 'Longleat Estate'
union all
select id, 'Animal Enclosure Infrastructure', 'animal_operation', false, 'critical' from sites where name = 'Longleat Estate'
union all
select id, 'Central Plant Room', 'plant_room', false, 'critical' from sites where name = 'Longleat Estate'
union all
select id, 'Visitor Arrival Zone', 'public_area', true, 'high' from sites where name = 'Longleat Estate'
on conflict do nothing;

insert into compliance_areas (name, source_type, source_url, risk_category, rag_tags)
values
  ('Fire Safety', 'GOV.UK / legislation', 'https://www.gov.uk/workplace-fire-safety-your-responsibilities', 'life_safety', array['law:fire-safety-order','audience:longleat-interview']),
  ('Water Hygiene', 'HSE guidance', 'https://www.hse.gov.uk/legionnaires/', 'health', array['law:coshh','asset:water-system']),
  ('Asbestos Management', 'HSE guidance', 'https://www.hse.gov.uk/asbestos/duty/index.htm', 'health', array['law:control-of-asbestos','process:contractor-management']),
  ('Electrical Safety', 'HSE guidance', 'https://www.hse.gov.uk/electricity/', 'life_safety', array['law:electricity-at-work','asset:electrical']),
  ('LOLER', 'HSE guidance', 'https://www.hse.gov.uk/work-equipment-machinery/loler-overview.htm', 'statutory', array['law:loler','asset:lift']),
  ('PUWER', 'HSE guidance', 'https://www.hse.gov.uk/work-equipment-machinery/puwer-overview.htm', 'statutory', array['law:puwer','asset:work-equipment']),
  ('Work at Height', 'HSE guidance', 'https://www.hse.gov.uk/work-at-height/', 'life_safety', array['law:work-at-height','process:permit-to-work']),
  ('COSHH', 'HSE guidance', 'https://www.hse.gov.uk/coshh/', 'health', array['law:coshh','asset:hazardous-substance']),
  ('Waste Duty of Care', 'GOV.UK guidance', 'https://www.gov.uk/dispose-business-commercial-waste', 'environmental', array['law:waste-duty-of-care']),
  ('Contractor Management', 'HSE guidance', 'https://www.hse.gov.uk/pubns/books/hsg159.htm', 'operational', array['process:contractor-management','process:rams'])
on conflict (name) do nothing;

insert into assets (site_id, location_id, asset_type, name, reference, criticality, condition_rating, status)
select s.id, l.id, 'fire_alarm_panel', 'Main fire alarm panel', 'FAP-001', 'critical', 'good', 'active'
from sites s join locations l on l.site_id = s.id and l.name = 'Main House'
where s.name = 'Longleat Estate'
union all
select s.id, l.id, 'emergency_lighting', 'Main House emergency lighting circuit', 'EL-001', 'critical', 'fair', 'active'
from sites s join locations l on l.site_id = s.id and l.name = 'Main House'
where s.name = 'Longleat Estate'
union all
select s.id, l.id, 'water_system', 'Main House domestic water system', 'WAT-001', 'high', 'fair', 'active'
from sites s join locations l on l.site_id = s.id and l.name = 'Main House'
where s.name = 'Longleat Estate'
union all
select s.id, l.id, 'lift', 'Visitor passenger lift', 'LIFT-001', 'high', 'fair', 'active'
from sites s join locations l on l.site_id = s.id and l.name = 'Visitor Arrival Zone'
where s.name = 'Longleat Estate'
union all
select s.id, l.id, 'animal_infrastructure', 'Primary enclosure gate set', 'ENC-GATE-001', 'critical', 'fair', 'active'
from sites s join locations l on l.site_id = s.id and l.name = 'Animal Enclosure Infrastructure'
where s.name = 'Longleat Estate'
union all
select s.id, l.id, 'generator', 'Emergency generator', 'GEN-001', 'critical', 'good', 'active'
from sites s join locations l on l.site_id = s.id and l.name = 'Central Plant Room'
where s.name = 'Longleat Estate'
on conflict do nothing;

insert into contractors (name, trade, approval_status, insurance_expiry, risk_rating, primary_contact, emergency_contact)
values
  ('Example Fire Systems Ltd', 'fire safety systems', 'approved', current_date + 300, 'high', 'service@example-fire.test', '0800 000 0001'),
  ('Example Water Hygiene Ltd', 'water hygiene', 'approved', current_date + 240, 'high', 'service@example-water.test', '0800 000 0002'),
  ('Example Electrical Ltd', 'electrical', 'approved', current_date + 330, 'high', 'service@example-electrical.test', '0800 000 0003'),
  ('Example Lift Services Ltd', 'lifting equipment', 'approved', current_date + 270, 'high', 'service@example-lift.test', '0800 000 0004'),
  ('Example Asbestos Consultancy Ltd', 'asbestos consultancy', 'approved', current_date + 210, 'high', 'service@example-asbestos.test', '0800 000 0005')
on conflict do nothing;

insert into compliance_requirements (compliance_area_id, title, description, default_frequency, evidence_required, applies_to_asset_type, rag_tags)
select id, 'Weekly fire alarm test', 'Test fire alarm call points on a rotating basis and record faults.', 'weekly', array['logbook_entry','fault_record'], 'fire_alarm_panel', array['asset:fire-alarm','task:weekly-test'] from compliance_areas where name = 'Fire Safety'
union all
select id, 'Fire alarm service', 'Competent contractor service and defect report.', 'six_monthly', array['contractor_report','defect_tracker'], 'fire_alarm_panel', array['asset:fire-alarm','task:service'] from compliance_areas where name = 'Fire Safety'
union all
select id, 'Emergency lighting functional test', 'Monthly functional test of emergency lighting.', 'monthly', array['test_log','defect_record'], 'emergency_lighting', array['asset:emergency-lighting'] from compliance_areas where name = 'Fire Safety'
union all
select id, 'Legionella temperature monitoring', 'Monitor hot and cold water outlets under written scheme.', 'monthly', array['temperature_log','out_of_range_action'], 'water_system', array['asset:water-system'] from compliance_areas where name = 'Water Hygiene'
union all
select id, 'LOLER thorough examination', 'Thorough examination by competent person.', 'six_monthly_or_annual', array['thorough_examination_report','defect_close_out'], 'lift', array['law:loler','asset:lift'] from compliance_areas where name = 'LOLER'
union all
select id, 'Contractor RAMS review', 'Review task-specific contractor RAMS before work.', 'per_task', array['rams','review_record','competence'], null, array['process:rams','process:contractor-management'] from compliance_areas where name = 'Contractor Management'
on conflict do nothing;

insert into task_templates (requirement_id, name, frequency_type, lead_time_days, grace_period_days, requires_contractor, requires_permit)
select id, title, 'weekly', 2, 0, false, false from compliance_requirements where title = 'Weekly fire alarm test'
union all
select id, title, 'six_monthly', 30, 0, true, false from compliance_requirements where title = 'Fire alarm service'
union all
select id, title, 'monthly', 7, 0, false, false from compliance_requirements where title = 'Emergency lighting functional test'
union all
select id, title, 'monthly', 7, 0, true, false from compliance_requirements where title = 'Legionella temperature monitoring'
union all
select id, title, 'six_monthly', 30, 0, true, false from compliance_requirements where title = 'LOLER thorough examination'
union all
select id, title, 'per_task', 0, 0, true, true from compliance_requirements where title = 'Contractor RAMS review'
on conflict do nothing;

insert into audit_checklists (name, scope, frequency, owner_role, rag_tags)
values
  ('Fire Safety Audit', 'Fire alarm, emergency lighting, doors, escape routes and FRA actions', 'quarterly', 'FM Manager', array['audit:fire','law:fire-safety-order']),
  ('Water Hygiene Audit', 'Risk assessment, written scheme, logs, out-of-range action and contractor reports', 'quarterly', 'Responsible Person', array['audit:water','asset:water-system']),
  ('Contractor Management Audit', 'Approval, insurance, competence, RAMS, induction, permits and monitoring', 'quarterly', 'Contract Manager', array['audit:contractors','process:contractor-management']),
  ('Visitor Attraction FM Audit', 'Visitor routes, events, animal infrastructure interfaces, emergency access and public segregation', 'monthly_peak_season', 'FM Manager', array['audit:visitor-attraction','audience:longleat-interview'])
on conflict do nothing;

insert into interview_questions (category, question, expected_points, rag_tags)
values
  ('Longleat boardroom', 'How would you brief the board during a power outage with 5,000 visitors onsite?', array['life safety','visitor control','critical systems','animal welfare','clear update rhythm'], array['audience:longleat-interview','incident:power-outage']),
  ('Contractor control', 'What would you do if a contractor found suspected asbestos during works?', array['stop work','isolate area','check register','competent advice','incident log'], array['law:control-of-asbestos','process:contractor-management']),
  ('Water hygiene', 'How would you respond to missing water hygiene records?', array['scope gap','current control checks','Responsible Person','contractor review','remedial evidence plan'], array['asset:water-system','law:coshh']);

insert into scenario_bank (scenario_type, title, prompt, expected_actions, rag_tags)
values
  ('incident', 'Fire panel fault during opening', 'The fire alarm panel shows a fault during visitor opening hours.', array['call contractor','assess impairment','temporary measures','notify Responsible Person','record decisions'], array['asset:fire-alarm','incident:fire-panel']),
  ('contractor', 'Generic RAMS for roof repair', 'A roofing contractor submits RAMS that do not mention visitor segregation or fragile surfaces.', array['reject RAMS','request site-specific controls','check competence','permit review','monitor work'], array['process:rams','law:work-at-height']),
  ('asset', 'Animal enclosure gate defect', 'A defect is reported on a primary animal enclosure gate.', array['notify animal team','restrict access','assess public and animal risk','competent repair','board escalation if critical'], array['asset:animal-infrastructure','audience:longleat-interview']);
