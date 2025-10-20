# Module - Google Cloud Storage
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

This module standardizes the creation and configuration of Google Cloud Storage buckets using Terraform.

## Compatibility Matrix

| Module Version | Terraform Version    | Google Provider Version |
|----------------|---------------------:|------------------------:|
| v1.0.0         | 1.10.2 - 1.12.2      | 6.13.0 - 6.49.2         |
| v1.1.0         | 1.13.0               | 6.49.2                  |

## Release Notes

| Module Version | Note                                      |
|----------------|-------------------------------------------|
| v1.0.0         | Initial version                           |
| v1.1.0         | Provider upgrade and RBAC on bucket level |

## Specifying a version

To avoid using the latest module version automatically, pin the module source using `?ref=<tag>` in the source URL (where `<tag>` is a git tag).

## Default use case

```hcl
module "gcs" {
  source        = "git::https://github.com/danilomnds/terraform-gcp-cloud-storage?ref=v1.1.0"
  project       = "project_id"
  name          = "gcsname"
  location      = "southamerica-east1"
  storage_class = "STANDARD"
  members       = ["group:GRP_GCP-SYSTEM-PRD@domain.com"]
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.gcs.id
}
```

## Static website use case

```hcl
module "gcs_website" {
  source        = "git::https://github.com/danilomnds/terraform-gcp-cloud-storage?ref=v1.1.0"
  project       = "project_id"
  name          = "gcs-website"
  location      = "southamerica-east1"
  storage_class = "STANDARD"
  members       = ["group:GRP_GCP-SYSTEM-PRD@domain.com"]
  website = {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors = [{
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.gcs_website.id
}
```

## Lifecycle rules use case

```hcl
module "gcs_lifecycle" {
  source        = "git::https://github.com/danilomnds/terraform-gcp-cloud-storage?ref=v1.1.0"
  project       = "project_id"
  name          = "gcs-lifecycle"
  location      = "southamerica-east1"
  storage_class = "STANDARD"
  members       = ["group:GRP_GCP-SYSTEM-PRD@domain.com"]
  lifecycle_rule = [
    {
      condition = { age = 3 }
      action    = { type = "Delete" }
    },
    {
      condition = { age = 1 }
      action    = { type = "AbortIncompleteMultipartUpload" }
    }
  ]
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.gcs_lifecycle.id
}
```

## Input variables

| Name                          | Description                                                                                                                                                         | Type              | Default   | Required |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|-----------|:--------:|
| name                          | The name of the bucket.                                                                                                                                             | `string`          | n/a       | Yes      |
| location                      | The GCS location/region for the bucket (e.g., `southamerica-east1`).                                                                                               | `string`          | n/a       | Yes      |
| force_destroy                 | Whether to delete the bucket even if it contains objects.                                                                                                           | `bool`            | `false`   | No       |
| project                       | The ID of the project in which the bucket will be created. If not provided, the provider project is used.                                                            | `string`          | n/a       | No       |
| storage_class                 | Storage class for the bucket (e.g., `STANDARD`, `NEARLINE`).                                                                                                         | `string`          | `STANDARD`| No       |
| autoclass                     | Autoclass configuration for the bucket. See the provider docs for the full structure.                                                                                | `object({})`      | n/a       | No       |
| lifecycle_rule                | List of lifecycle rules for the bucket. Each item must follow the provider's lifecycle block structure.                                                              | `list(object)`    | `[]`      | No       |
| versioning                    | Versioning configuration for the bucket.                                                                                                                             | `object({})`      | n/a       | No       |
| website                       | Website configuration (main page, not found page).                                                                                                                  | `object({})`      | n/a       | No       |
| cors                          | CORS configuration (list of blocks).                                                                                                                                | `list(object)`    | n/a       | No       |
| default_event_based_hold      | Apply an event-based hold to new objects by default.                                                                                                                | `bool`            | n/a       | No       |
| retention_policy              | Data retention policy configuration. See provider docs.                                                                                                              | `object({})`      | n/a       | No       |
| labels                        | User-defined labels for the bucket.                                                                                                                                  | `map(string)`     | n/a       | No       |
| logging                       | Access and storage logging configuration.                                                                                                                            | `object({})`      | n/a       | No       |
| encryption                    | Encryption configuration (e.g., KMS key).                                                                                                                            | `object({})`      | n/a       | No       |
| enable_object_retention       | Enable object retention on the bucket.                                                                                                                               | `bool`            | `false`   | No       |
| requester_pays                | Enable Requester Pays on the bucket.                                                                                                                                | `bool`            | `false`   | No       |
| rpo                           | Recovery point objective for cross-region replication (if applicable).                                                                                              | `string`          | n/a       | No       |
| uniform_bucket_level_access   | Enable uniform bucket-level access.                                                                                                                                  | `bool`            | `true`    | No       |
| public_access_prevention      | Prevent public access to a bucket (e.g., `inherited`, `enforced`).                                                                                                   | `string`          | `inherited`| No      |
| custom_placement_config       | Custom placement config for dual-region buckets. See provider docs.                                                                                                  | `object({})`      | n/a       | No       |
| soft_delete_policy            | Soft delete policy for retained-but-soft-deleted objects.                                                                                                            | `object({})`      | n/a       | No       |
| hierarchical_namespace        | Enable hierarchical namespace behavior (logical folders).                                                                                                            | `bool`            | n/a       | No       |
| ip_filter                     | IP filter/network source configuration.                                                                                                                             | `object({})`      | n/a       | No       |
| members                       | List of IAM members (users, groups, service accounts) to grant RBAC on the bucket.                                                                                   | `list(string)`    | n/a       | No       |

## Object variables for blocks

Refer to the provider documentation for exact block/object structures:  
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

## Output variables

| Name | Description |
|------|-------------|
| id   | Bucket ID   |

## Documentation

Google Cloud Storage resource reference:  
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket