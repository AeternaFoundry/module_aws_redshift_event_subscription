variable "redshift_event_subscriptions" {
  description = <<EOT
Map of redshift_event_subscriptions, attributes below
Required:
    - name
    - sns_topic_arn
Optional:
    - enabled
    - event_categories
    - region
    - severity
    - source_ids
    - source_type
    - tags
    - tags_all
EOT

  type = map(object({
    name             = string
    sns_topic_arn    = string
    enabled          = optional(bool)
    event_categories = optional(set(string))
    region           = optional(string)
    severity         = optional(string)
    source_ids       = optional(set(string))
    source_type      = optional(string)
    tags             = optional(map(string))
    tags_all         = optional(map(string))
  }))
  validation {
    condition = alltrue([
      for k, v in var.redshift_event_subscriptions : (
        v.severity == null || (contains(["ERROR", "INFO"], v.severity))
      )
    ])
    error_message = "must be one of: ERROR, INFO"
  }
  # Note: 3 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

