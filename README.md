# Compliance Bible

```yaml
ai_metadata:
  repo: compliance-bible
  document_type: repository_readme
  rag_tags:
    - repo:compliance-bible
    - product:fm-control-hub
    - product:compliance-hub
    - audience:longleat-interview
```

Production-grade UK Facilities Management compliance knowledge base for FM Control Hub, Compliance Hub, AI retrieval, audits, training and operational reference.

## Navigation

- [Master Index](MASTER_INDEX.md)
- [Quick Start](QUICK_START.md)
- [Roadmap](ROADMAP.md)
- [Glossary](GLOSSARY.md)
- [Tags](TAGS.md)
- [How to use this in FM Control Hub](HOW_TO_USE_IN_FM_CONTROL_HUB.md)
- [How to use this for Longleat interview prep](HOW_TO_USE_FOR_LONGLEAT_INTERVIEW_PREP.md)

## Mission

This repo is the source-of-truth compliance library for facilities, estates, health and safety, fire safety, water hygiene, contractor control and building operations.

It is not a notes dump. Every page must help a real Facilities Manager decide what to do, what evidence to keep and how to prove compliance.

## Production Rules

- No placeholder pages.
- No empty folders committed just to look busy.
- No uncited legal claims where official guidance exists.
- Use official sources first: HSE, GOV.UK, legislation.gov.uk, Home Office, Environment Agency, CQC where relevant.
- Every legal page must explain practical FM duties, evidence, inspection cadence and system mapping.
- Every completed task must update `TODO.md` and `CHANGELOG.md` in the same commit or immediately after.
- Every commit must be pushed once the task is complete.

## Standard Page Format

Each compliance page must use this structure:

```md
# Regulation / Standard Name

## Plain English Summary

## Why It Matters in Facilities Management

## Who Has Duties

## What the Law Requires

## FM Actions

## Evidence to Keep

## Inspection / Review Frequency

## Red Flags

## Interview Talking Points

## FM Control Hub Mapping

## Compliance Hub Mapping

## Official Sources
```

## Repository Map

```text
compliance-bible/
├── README.md
├── TODO.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── COMMIT_GUIDE.md
├── 01-core-legislation/
├── 02-fire-safety/
├── 03-water-hygiene/
├── 04-asbestos/
├── 05-coshh/
├── 06-electrical-safety/
├── 07-work-equipment-puwer/
├── 08-lifting-equipment-loler/
├── 09-work-at-height/
├── 10-risk-assessments/
├── 11-contractor-management/
├── 12-waste-environment/
├── 13-building-estate-management/
├── 14-care-home-relevance/
├── 15-safari-visitor-attraction-relevance/
├── 16-templates/
├── 17-audit-checklists/
├── 18-system-mapping/
├── 19-interview-prep/
└── 20-case-studies/
```

Folders should only be created when they contain completed production material.

## Phase 1 Scope

The first production release must cover:

1. Health and Safety at Work etc. Act 1974
2. Management of Health and Safety at Work Regulations 1999
3. Workplace Health, Safety and Welfare Regulations 1992
4. Regulatory Reform Fire Safety Order 2005
5. Fire Safety Act 2021 and Fire Safety England Regulations 2022
6. Control of Asbestos Regulations 2012
7. COSHH Regulations 2002
8. Electricity at Work Regulations 1989
9. PUWER 1998
10. LOLER 1998
11. Work at Height Regulations 2005
12. Manual Handling Operations Regulations 1992
13. PPE at Work Regulations
14. RIDDOR 2013
15. ACOP L8 and HSG274 Legionella guidance
16. Waste Duty of Care and Environmental Protection Act 1990
17. Contractor management and permit-to-work framework

## Product Integration Vision

### FM Control Hub

This repo should power:

- asset compliance tasks
- PPM schedules
- statutory inspection calendars
- contractor evidence checks
- incident workflows
- audit dashboards
- AI compliance assistant answers

### Compliance Hub

This repo should power:

- legislation library
- audit templates
- evidence requirements
- governance checklists
- policy generation
- compliance status reporting

## Done Means Done

A task is not finished until:

- the content is complete
- source links are included
- practical FM actions are included
- evidence requirements are defined
- TODO.md is marked off
- CHANGELOG.md is updated
- changes are committed and pushed
