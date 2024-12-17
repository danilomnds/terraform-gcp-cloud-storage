# Module - Google Cloud Storage
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

Module developed to standardize the creation of Google Cloud Storage.

## Compatibility Matrix

| Module Version | Terraform Version | Google Version     |
|----------------|-------------------| ------------------ |
| v1.0.0         | v1.10.2           | 6.13.0             |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Default use case
```hcl
module "gcs" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-cloud-storage?ref=v1.0.0"
  project = "project_id"
  name = "gcsname"
  location = "<southamerica-east1>"
  storage_class = "STANDARD"
  # if you have more that one bucket on the same project, please specify the members only one time!
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]
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

## Use case Static Website
```hcl
module "gcs" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-cloud-storage?ref=v1.0.0"
  project = "project_id"
  name = "gcs"
  location = "<southamerica-east1>"
  storage_class = "STANDARD"
  # if you have more that one bucket on the same project, please specify the members only one time!
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]
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
  value = module.gcs.id
}
```

## Use case Life Cycle Rules
```hcl
module "gcs" {    
  source = "git::https://timbrasil@dev.azure.com/timbrasil/Projeto_IaC/_git/gcp-module-storage-bucket?ref=v1.0.0"
  project = "project_id"
  name = "gcsid"
  location = "<southamerica-east1>"
  storage_class = "STANDARD"
  # if you have more that one bucket on the same project, please specify the members only one time!
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]
  lifecycle_rule = [
    {
      condition  = {
        age = 3
      }
      action  = {
        type = "Delete"
      }
    },
    {
      condition = {
        age = 1
      }
      action = {
        type = "AbortIncompleteMultipartUpload"
      }
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
  value = module.gcs.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the bucket | `string` | n/a | `Yes` |
| location | The GCS location | `string` | n/a | `Yes` |
| force_destroy | The GCS location | `bool` | `false` | No |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | No |
| storage_class | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | `STANDARD` | No |
| autoclass | The bucket's Autoclass configuration. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| lifecycle_rule | The bucket's Lifecycle Rules configuration. Multiple blocks of this type are permitted. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| versioning | The bucket's Versioning configuration. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| website | Configuration if the bucket acts as a website. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| cors | The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| default_event_based_hold | Whether or not to automatically apply an eventBasedHold to new objects added to the bucket | `bool` | n/a | No |
| retention_policy | Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| labels | Labels with user-defined metadata | `map(string)` | n/a | No |
| logging | The bucket's Access & Storage Logs configuration. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| encryption | The bucket's encryption configuration. Check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| enable_object_retention | Enables object retention on a storage bucket | `bool` | `false` | No |
| requester_pays | Enables Requester Pays on a storage bucket | `bool` | `false` | No |
| rpo | The recovery point objective for cross-region replication of the bucket. | `string` | n/a | No |
| uniform_bucket_level_access | Enables Uniform bucket-level access access to a bucket | `bool` | `true` | No |
| public_access_prevention | Prevents public access to a bucket. | `string` | `inherited` | No |
| custom_placement_config | The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. Structure is documented [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| soft_delete_policy | The bucket's soft delete policy, which defines the period of time that soft-deleted objects will be retained, and cannot be permanently deleted. Structure is documented [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | `object({})` | n/a | No |
| hierarchical_namespace | The bucket's hierarchical namespace policy, which defines the bucket capability to handle folders in logical structure | `bool` | n/a | No |
| members | list of azure AD groups that will use the resource | `list(string)` | n/a | No |

# Object variables for blocks

Please check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)

## Output variables

| Name | Description |
|------|-------------|
| id   | bucket id   |

## Documentation
Google Cloud Storage: <br>
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)