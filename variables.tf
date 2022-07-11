variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

resource "random_id" "snapshot_identifier" {
  # keepers = {
  #   id = var.name
  # }

  byte_length = 4
}

variable "db_creation_from_snapshot" {
  type    = bool
  default = false
}

# variable "name" {
#   default = "staging-cluster"
# }

# variable "snapshot_identifier" {
#   description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot"
#   type        = string
#   default     = null  
# }

variable "db_parameter_group_name" {
  description = "The name of a DB parameter group to use"
  type        = string
  default     = null
}

variable "cluster_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type        = map(string)
  default     = {}
}
