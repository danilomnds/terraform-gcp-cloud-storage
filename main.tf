resource "google_storage_bucket" "bucket" {
  name          = var.name
  location      = var.location
  force_destroy = var.force_destroy
  project       = var.project
  storage_class = var.storage_class
  dynamic "autoclass" {
    for_each = var.autoclass != null ? [var.autoclass] : []
    content {
      enabled                = autoclass.value.enabled
      terminal_storage_class = lookup(autoclass.value, "terminal_storage_class", null)
    }
  }
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule != [] ? var.lifecycle_rule : []
    content {
      dynamic "action" {
        for_each = lifecycle_rule.value.action != null ? [lifecycle_rule.value.action] : []
        content {
          type          = action.value.type
          storage_class = lookup(action.value, "storage_class", null)
        }
      }
      dynamic "condition" {
        for_each = lifecycle_rule.value.condition != null ? [lifecycle_rule.value.condition] : []
        content {
          age                                     = lookup(condition.value, "age", null)
          created_before                          = lookup(condition.value, "created_before", null)
          with_state                              = lookup(condition.value, "with_state", null)
          matches_storage_class                   = lookup(condition.value, "matches_storage_class", null)
          matches_prefix                          = lookup(condition.value, "matches_prefix", null)
          matches_suffix                          = lookup(condition.value, "matches_suffix", null)
          num_newer_versions                      = lookup(condition.value, "num_newer_versions", null)
          send_num_newer_versions_if_zero         = lookup(condition.value, "send_num_newer_versions_if_zero", null)
          custom_time_before                      = lookup(condition.value, "custom_time_before", null)
          days_since_custom_time                  = lookup(condition.value, "days_since_custom_time", null)
          send_age_if_zero                        = lookup(condition.value, "send_age_if_zero", null)
          send_days_since_custom_time_if_zero     = lookup(condition.value, "send_days_since_custom_time_if_zero", null)
          days_since_noncurrent_time              = lookup(condition.value, "days_since_noncurrent_time", null)
          send_days_since_noncurrent_time_if_zero = lookup(condition.value, "send_days_since_noncurrent_time_if_zero", null)
          noncurrent_time_before                  = lookup(condition.value, "noncurrent_time_before", null)
        }
      }
    }
  }
  dynamic "versioning" {
    for_each = var.versioning != null ? [var.versioning] : []
    content {
      enabled = versioning.value.enabled
    }
  }
  dynamic "website" {
    for_each = var.website != null ? [var.website] : []
    content {
      main_page_suffix = lookup(website.value, "main_page_suffix", null)
      not_found_page   = lookup(website.value, "not_found_page", null)
    }
  }
  dynamic "cors" {
    for_each = var.cors != null ? var.cors : []
    content {
      origin          = lookup(cors.value, "origin", null)
      method          = lookup(cors.value, "method", null)
      response_header = lookup(cors.value, "response_header", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }
  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : []
    content {
      is_locked        = lookup(retention_policy.value, "is_locked", null)
      retention_period = lookup(retention_policy.value, "retention_period", null)
    }
  }
  labels = var.labels
  dynamic "logging" {
    for_each = var.logging != null ? [var.logging] : []
    content {
      log_bucket        = lookup(logging.value, "log_bucket", null)
      log_object_prefix = lookup(logging.value, "log_object_prefix", null)
    }
  }
  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : []
    content {
      default_kms_key_name = lookup(encryption.value, "default_kms_key_name", null)
    }
  }
  enable_object_retention     = var.enable_object_retention
  requester_pays              = var.requester_pays
  rpo                         = var.rpo
  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention
  dynamic "custom_placement_config" {
    for_each = var.custom_placement_config != null ? [var.custom_placement_config] : []
    content {
      data_locations = custom_placement_config.value.data_locations
    }
  }
  dynamic "soft_delete_policy" {
    for_each = var.soft_delete_policy != null ? [var.soft_delete_policy] : []
    content {
      retention_duration_seconds = lookup(soft_delete_policy.value, "retention_duration_seconds", null)
      effective_time             = lookup(soft_delete_policy.value, "effective_time", null)
    }
  }
  dynamic "hierarchical_namespace" {
    for_each = var.hierarchical_namespace != null ? [var.hierarchical_namespace] : []
    content {
      enabled = hierarchical_namespace.value.enabled
    }
  }
  dynamic "ip_filter" {
    for_each = var.ip_filter != null ? [var.ip_filter] : []
    content {
      mode                           = ip_filter.value.mode
      allow_cross_org_vpcs           = lookup(ip_filter.value, "allow_cross_org_vpcs", null)
      allow_all_service_agent_access = lookup(ip_filter.value, "allow_all_service_agent_access", null)
      dynamic "public_network_source" {
        for_each = ip_filter.value.public_network_source != null ? [ip_filter.value.public_network_source] : []
        content {
          allowed_ip_cidr_ranges = public_network_source.value.allowed_ip_cidr_ranges
        }
      }
      dynamic "vpc_network_sources" {
        for_each = ip_filter.value.vpc_network_sources != null ? [ip_filter.value.vpc_network_sources] : []
        content {
          network                = vpc_network_sources.value.network
          allowed_ip_cidr_ranges = vpc_network_sources.value.allowed_ip_cidr_ranges
        }
      }
    }
  }
  lifecycle {
    ignore_changes = []
  }
}

resource "google_storage_bucket_iam_member" "bucketgetlist" {
  depends_on = [google_storage_bucket.bucket]
  for_each   = { for member in var.members : member => member }
  bucket     = google_storage_bucket.bucket.name
  role       = "organizations/225850268505/roles/bucketReaderorgtim"
  member     = each.value
}

resource "google_storage_bucket_iam_member" "StorageObjectAdmin" {
  depends_on = [google_storage_bucket.bucket]
  for_each   = { for member in var.members : member => member }
  bucket     = google_storage_bucket.bucket.name
  role       = "roles/storage.objectAdmin"
  member     = each.value
}