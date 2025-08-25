variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "project" {
  type    = string
  default = null
}

variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "autoclass" {
  type = object({
    enabled                = bool
    terminal_storage_class = optional(string)
  })
  default = null
}

variable "lifecycle_rule" {
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                                     = optional(number)
      created_before                          = optional(string)
      with_state                              = optional(string)
      matches_storage_class                   = optional(list(string))
      matches_prefix                          = optional(list(string))
      matches_suffix                          = optional(list(string))
      num_newer_versions                      = optional(number)
      send_num_newer_versions_if_zero         = optional(bool)
      custom_time_before                      = optional(number)
      days_since_custom_time                  = optional(number)
      send_age_if_zero                        = optional(bool)
      send_days_since_custom_time_if_zero     = optional(bool)
      days_since_noncurrent_time              = optional(number)
      send_days_since_noncurrent_time_if_zero = optional(bool)
      noncurrent_time_before                  = optional(string)
    })
  }))
  default = null
}

variable "versioning" {
  type = object({
    enabled = bool
  })
  default = null
}

variable "website" {
  type = object({
    main_page_suffix = optional(string)
    not_found_page   = optional(string)
  })
  default = null
}

variable "cors" {
  type = list(object({
    origin          = optional(list(string))
    method          = optional(list(string))
    response_header = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = null
}

# duvida variable type
variable "default_event_based_hold" {
  type    = bool
  default = null
}

variable "retention_policy" {
  type = object({
    is_locked        = optional(bool)
    retention_period = number
  })
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "logging" {
  type = object({
    log_bucket        = string
    log_object_prefix = optional(string)
  })
  default = null
}

variable "encryption" {
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "enable_object_retention" {
  type    = bool
  default = false
}

variable "requester_pays" {
  type    = bool
  default = false
}

variable "rpo" {
  type    = string
  default = null
}

variable "uniform_bucket_level_access" {
  type    = bool
  default = true
}

variable "public_access_prevention" {
  type    = string
  default = "inherited"
}

variable "custom_placement_config" {
  type = object({
    data_locations = string
  })
  default = null
}

variable "soft_delete_policy" {
  type = object({
    retention_duration_seconds = optional(number)
    effective_time             = optional(string)
  })
  default = null
}

variable "hierarchical_namespace" {
  type = object({
    enabled = bool
  })
  default = null
}

variable "ip_filter" {
  type = object({
    mode                           = string
    allow_cross_org_vpcs           = optional(bool)
    allow_all_service_agent_access = optional(bool)
    public_network_source = optional(object({
      allowed_ip_cidr_ranges = list(string)
    }))
    vpc_network_sources = optional(object({
      network                = string
      allowed_ip_cidr_ranges = list(string)
    }))
  })
  default = null
}

variable "members" {
  type    = list(string)
  default = []
}