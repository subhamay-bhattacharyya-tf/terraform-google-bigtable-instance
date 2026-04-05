# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:** _(delegate to `tf-mod-main` skill)_

- Bigtable instance using the `terraform-google-module-template` module (source: `github.com/subhamay-bhattacharyya-tf/terraform-google-module-template`)
- Follow the GCP provider reference and core authoring patterns from the `tf-mod-main` skill

**locals.tf:**

A map type variable must be created from the input variable and the bigtable instance name must be in the following format:

```text
<project_code>-<base_name>-<location>-<environment>
```

**variables.tf:** _(delegate to `tf-mod-vars` skill)_

Use the `tf-mod-vars` skill to author this file. Apply the GCP provider reference and validation patterns. The variable schema is:

| Variable | Type | Required | Notes |
| --- | --- | --- | --- |
| `environment` | `string` | Yes | One of: `dev`, `test`, `prod` |
| `project_code` | `string` | Yes | Short identifier for naming standardization |
| `region` | `string` | No | Default: `us-central1` |
| `bigtable_config` | `object` | Yes | See attribute table below |

`bigtable_config` attributes:

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length ≤ 30 |
| `instance_type` | `string` | No | `PRODUCTION` | One of: `PRODUCTION`, `DEVELOPMENT` |
| `deletion_protection` | `boolean` | No | `true` | — |
| `cluster` | `object` | Yes | — | Must include `cluster_id`, `zone`, `num_nodes`, `storage_type` |
| `autoscaling_config` | `object` | No | `null` | Should include `min_nodes`, `max_nodes`, `cpu_target` |
| `labels` | `map(string)` | No | `{}` | Key-value pairs for governance |

**outputs.tf:**

- Outputs for all standard Bigtable instance attributes:
  - `instance_id`
  - `instance_name`
  - `instance_project`
  - `instance_type`
  - `instance_deletion_protection`

**versions.tf:**

- Versions.tf should be in the following format

```hcl

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.23.0"
    }
  }
}

provider "google" {
  region = var.region
}
```

**examples/:** _(delegate to `tf-mod-examples` skill)_

Use the `tf-mod-examples` skill to scaffold the full example matrix. Each example must be a self-contained, independently validatable Terraform configuration under `examples/<name>/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

**test/:**

- `test/bigtable_basic_test.go`: This Terratest tests the basic Bigtable instance configuration.
- `test/bigtable_autoscaling_test.go`: This Terratest tests the Bigtable instance with autoscaling configuration.
- `test/bigtable_multi_cluster_test.go`: This Terratest tests the Bigtable instance with multiple cluster configuration.
- `test/bigtable_deletion_protection_test.go`: This Terratest tests the Bigtable instance with deletion protection configuration.

**package.json:**

- `github/workflows/ci.yaml`: This is the CI Pipeline. Add all the tests in the terratest job.

Ensure the name is always the repository name.

**package-lock.json:**

Ensure the name is always the repository name.

**CONTRIBUTING.md:**

Ensure in the CONTRIBUTING.md, Reporting Issues must always links to the current repository.

**README.md:** _(delegate to `tf-mod-readme` skill)_

Use the `tf-mod-readme` skill to generate this file. The skill will:

- Auto-resolve the repository name from the current git root
- Check and create the gist badge file if missing
- Populate all badge URLs pointing to the current repository
- Produce terraform-docs-compatible inputs/outputs tables
- Follow markdownlint rules (MD060 table column style)
