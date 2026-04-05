---
name: tf-mod-examples
description: >
  Generates Terraform module example configurations covering all meaningful
  combinations of input variables. Use this skill when the user asks to
  generate examples, scaffold example directories, create tfvars combinations,
  or produce a complete examples/ folder for a Terraform module. Trigger when
  the user says "generate all examples", "scaffold examples", "create example
  combinations", or "fill in the examples directory". Also trigger when the
  user shares a variables.tf and asks for example usage across all options.
---

# Terraform Module Examples — Generator Skill

This skill generates a complete `examples/` directory tree for a Terraform
module by reading `variables.tf` and producing one standalone example per
meaningful feature combination.

---

## How to Use This Skill

1. Read `variables.tf` (and `versions.tf` if present) from the current module root.
2. Identify every optional field and enumerate its allowed values from `validation` blocks or type annotations.
3. Derive the example matrix using the rules below.
4. Write each example as a self-contained directory under `examples/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

---

## Step 1 — Enumerate Axes

For each optional field in the root `gcs_config` object (or equivalent), record:

| Axis | Values |
|---|---|
| `storage_class` | `STANDARD`, `NEARLINE`, `COLDLINE`, `ARCHIVE`, `MULTI_REGIONAL`, `REGIONAL` |
| `location` | `US`, `US-CENTRAL1`, `US-EAST1`, `US-EAST4`, `NAM4` |
| `versioning.enabled` | `true`, `false` |
| `lifecycle_rule` | absent, delete-after-age, transition-to-nearline, transition-to-coldline, transition-to-archive, abort-incomplete-multipart |
| `cors` | absent, single-origin, multi-origin |
| `website` | absent, present |
| `autoclass` | absent, enabled-standard-terminal, enabled-nearline-terminal |
| `kms_key_name` | absent, present (placeholder value) |
| `force_destroy` | `true`, `false` |
| `labels` | absent, present |

---

## Step 2 — Example Matrix

Do **not** generate the full cartesian product. Instead produce these named
examples, each exercising a distinct capability or realistic deployment pattern:

| Directory | Purpose | Key axes exercised |
|---|---|---|
| `basic/` | Minimal required fields only | defaults everywhere |
| `storage-nearline/` | Nearline cold storage | `storage_class=NEARLINE`, lifecycle delete after 90d |
| `storage-coldline/` | Coldline archival | `storage_class=COLDLINE`, lifecycle delete after 365d |
| `storage-archive/` | Deep archive | `storage_class=ARCHIVE` |
| `with-versioning/` | Object versioning on | `versioning.enabled=true`, lifecycle abort-incomplete-multipart |
| `with-versioning-disabled/` | Versioning explicitly off | `versioning.enabled=false` |
| `with-lifecycle-transition/` | Auto-tier via lifecycle | STANDARD → NEARLINE → COLDLINE transitions |
| `with-cors/` | CORS for web use | `cors` single origin, `website` present |
| `with-website/` | Static website hosting | `website` main/404, `cors` multi-origin |
| `with-autoclass/` | Autoclass cost optimisation | `autoclass.enabled=true`, terminal=NEARLINE |
| `with-kms/` | CMEK encryption | `kms_key_name` placeholder |
| `with-labels/` | Resource labelling | `labels` map with env/team/cost-centre |
| `no-force-destroy/` | Deletion protection | `force_destroy=false` |
| `complete/` | All features on | versioning, lifecycle, cors, website, autoclass, kms, labels |

---

## Step 3 — File Structure per Example

Each example directory must contain exactly these four files:

```
examples/<name>/
├── main.tf            # module call block only — no provider block
├── variables.tf       # re-declare only the variables consumed in main.tf
├── terraform.tfvars   # concrete values for every variable in variables.tf
└── README.md          # one-paragraph description + usage snippet
```

### `main.tf` template

```hcl
module "<name>" {
  source = "../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  gcs_config = {
    base_name     = var.base_name
    # ... only include fields relevant to this example
  }
}
```

### `variables.tf` template

```hcl
variable "environment"  { type = string }
variable "project_code" { type = string }
variable "region"       { type = string  default = "us-central1" }
variable "base_name"    { type = string }
```

### `terraform.tfvars` template

```hcl
environment  = "devl"
project_code = "demo"
region       = "us-central1"
base_name    = "<example-slug>"
```

### `README.md` template

```markdown
# <Example Title>

One sentence describing what this example demonstrates.

## Usage

\`\`\`bash
terraform init -backend=false
terraform validate
\`\`\`
```

---

## Step 4 — Validation Rules

After writing all files:

1. Run `terraform fmt -recursive examples/` to format all generated files.
2. Run `terraform init -backend=false && terraform validate` inside each example directory and report any errors.
3. Fix any errors before returning.

---

## Step 5 — Output Summary

After all files are written and validated, print a table:

| Example | Files written | Validated |
|---|---|---|
| `basic/` | 4 | ✓ |
| ... | ... | ... |
