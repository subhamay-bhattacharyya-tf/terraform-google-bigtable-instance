---
name: scaffold-terraform
description: Generate complete Terraform Google Module for provisioning a Bigtable instance with the given specifications
disable-model-invocation: true
argument-hint: "[region] [project]"
---

Generate a complete Terraform Google Module for provisioning a Bigtable instance with the given specifications:

Use $ARGUMENTS for optional overrides:
- $0 = GCP region (default: us-central1)
- $1 = GCP Project name (default: portfolio-site)

## What to Generate

Read `template-spec.md` in this skill folder for the full Terraform module specification.

Generate all files in the `/` directory following the template spec, delegating to the individual skills below for each configuration file:

## Delegation Map

| File / Section | Skill to invoke |
|---|---|
| `variables.tf` | **`tf-mod-vars`** — follow its variable authoring patterns, validation rules, and GCP provider reference for the `bigtable_config` object |
| `main.tf` | **`tf-mod-main`** — follow its core authoring patterns and GCP provider reference for the `google_bigtable_instance` resource |
| `examples/` | **`tf-mod-examples`** — follow its example matrix and file-structure rules to scaffold all example directories |
| `README.md` | **`tf-mod-readme`** — follow its template exactly, auto-resolve the repository name, and ensure the gist badge file exists |

Generate all other files (`outputs.tf`, `versions.tf`, `locals.tf`, `test/`, `CONTRIBUTING.md`, `.github/workflows/ci.yaml`) directly from `template-spec.md`.

## Workflow

1. Resolve all values from `$ARGUMENTS`, falling back to defaults where specified.
   Prompt the user for any required argument (`$0`, `$1`) not supplied.
2. Read `template-spec.md` in this skill folder for file templates and rules.
3. Generate `versions.tf` directly from `template-spec.md`, establishing provider and
   Terraform version constraints first.
   Do NOT skip this step — versions.tf is always part of the scaffold.
4. Generate `variables.tf` using the **tf-mod-vars** skill, passing `$0` (region) and
   `$1` (project). The skill will apply GCP provider validation patterns for the
   `bigtable_config` object.
   Do NOT skip this step — variables.tf is always part of the scaffold.
5. Generate `main.tf` using the **tf-mod-main** skill, passing `$0` (region) and
   `$1` (project). The skill will follow core authoring patterns for the
   `google_bigtable_instance` resource.
   Do NOT skip this step — main.tf is always part of the scaffold.
6. Generate `outputs.tf` directly from `template-spec.md`, exposing all standard
   Bigtable instance attributes (id, name, project, instance_type, deletion_protection).
   Do NOT skip this step — outputs.tf is always part of the scaffold.
7. Invoke the **tf-mod-readme** skill to generate `README.md`.
   The skill will auto-resolve the repository name and populate all badge URLs.
   Do NOT skip, defer, or summarise this step — README.md MUST be written.
8. Generate or update `package.json` in the repository root. Infer the
   repository name from the current repo. Write the file with the following
   rules — do NOT skip or defer:
   - `name`: repository name (e.g. `terraform-google-bigtable-instance`)
   - `version`: `"1.0.0"`
   - `description`: `"Terraform module for provisioning a Bigtable instance on GCP."`
   - `scripts`:
     - `"lint": "pre-commit run --all-files"`
     - `"tf:fmt": "terraform fmt -recursive"`
     - `"tf:validate": "terraform init -backend=false && terraform validate"`
   - `repository`:
     - `"type": "git"`
     - `"url": "https://github.com/subhamay-bhattacharyya-tf/<repository_name>"` — always use `subhamay-bhattacharyya-tf` org
   - `keywords`: `["terraform", "gcp", "bigtable", "google-cloud-bigtable", "iac"]`
   - `license`: `"MIT"`
9. Run `npm install` in the repository root to generate `package-lock.json`.
   Do NOT skip this step — package-lock.json MUST be present after scaffolding.

## After Generation

- [ ] List all files created
- [ ] Show a summary of resources that will be provisioned
- [ ] Remind the engineer to review the files and run `/tf-plan` when ready
