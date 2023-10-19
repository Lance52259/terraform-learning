######################################################################
# Attributes of the CBC payment
######################################################################

variable "charging_mode" {
  description = "The charging mode of the ECS resources"

  type    = string
  default = null
}

variable "period_unit" {
  description = "The period unit of the pre-paid purchase"

  type    = string
  default = null
}

variable "period" {
  description = "The period number of the pre-paid purchase"

  type    = number
  default = null
}

variable "is_auto_renew" {
  description = "Whether to automatically renew after expiration for ECS resources"

  type    = bool
  default = null
}

######################################################################
# Public configurations
######################################################################

# Specifies the suffix name for ECS resources, if omitted, using instance_name to create the ECS resource
variable "name_suffix" {
  description = "The suffix string of name for all ECS resources"

  type    = string
  default = ""
}

######################################################################
# Attributes of the VPC resources
######################################################################

variable "subnet_id" {
  description = "The ID of the VPC subnet to which the ECS instance belongs"

  type    = string
  default = null
}

variable "security_group_ids" {
  description = "The ID list of the security groups to which the ECS instance belongs"

  type    = list(string)
  default = []
}

variable "availability_zone" {
  description = "The specified availability zone where the ECS instance is located"

  type    = string
  default = null
}

variable "availability_zones" {
  description = "The list of availability zones where the ECS resources are located"

  type    = list(string)
  default = []
}

######################################################################
# Configuration of ECS instance and related resources
######################################################################

variable "is_instance_create" {
  description = "Controls whether a ECS instance should be created (it affects all ECS related resources under this module)"

  type    = bool
  default = true
}

variable "instance_count" {
  description = "The total number of the ECS instances"

  type    = number
  default = 0
}

variable "instance_name" {
  description = "The name of the ECS instance"

  type    = string
  default = null
}

variable "flavor_id" {
  description = "The ID of the ECS instance flavor"

  type    = string
  default = null
}

variable "instance_flavor_performance" {
  description = "The performance type of the ECS instance flavor"

  type    = string
  default = null
}

variable "instance_flavor_cpu" {
  description = "The CPU number of the ECS instance flavor"

  type    = number
  default = null
}

variable "instance_flavor_memory" {
  description = "The memory number of the ECS instance flavor"

  type    = number
  default = null
}

variable "image_id" {
  description = "The ID of the IMS image that ECS instance used"

  type    = string
  default = null
}

variable "instance_image_name" {
  description = "The name of the IMS image that ECS instance used"

  type    = string
  default = null
}

variable "system_disk_type" {
  description = "The type of the system volume"

  type    = string
  default = "SSD"
}

variable "system_disk_size" {
  description = "The size of the system volume, in GB"

  type    = number
  default = 40
}

variable "eip_id" {
  description = "The ID of the EIP assigned to the ECS instance"

  type    = string
  default = null
}

variable "admin_password" {
  description = "The login password of the administrator"

  type    = string
  default = null
}

variable "user_data" {
  description = "The user data to be injected during the ECS instance creation"

  type    = string
  default = null
}

variable "scheduler_hints_configuration" {
  description = "The scheduler with hints on how instance should be launched"

  type    = list(object({
    group   = optional(string, null)
    tenancy = optional(string, null)
    deh_id  = optional(string, null)
  }))
  default = []
}

variable "stop_before_destroy" {
  description = "Whether to try stop instance gracefully before destroying it, thus giving chance for guest OS daemons to stop correctly"

  type    = bool
  default = true
}

variable "delete_disks_on_termination" {
  description = "Whether to delete the data disks when the instance is terminated"

  type    = bool
  default = true
}

variable "delete_eip_on_termination" {
  description = "Whether to release the EIP when the instance is terminated"

  type    = bool
  default = true
}

variable "fixed_ip_v4" {
  description = "The fixed IP address that ECS instance have"

  type    = string
  default = null
}

variable "ipv6_enable" {
  description = "Whether to enable the IPv6 network"

  type    = bool
  default = false
}

variable "source_dest_check" {
  description = "Whether the ECS processes only traffic that is destined specifically for it"

  type    = bool
  default = false
}

variable "access_network" {
  description = "Whether network should be used for provisioning access"

  type    = bool
  default = false
}

variable "data_disks_configuration" {
  description = "The configuration of data volume of the ECS instance"

  type = list(object({
    type        = optional(string, "SSD")
    size        = optional(number, 100)
    snapshot_id = optional(string, null)
  }))

  default = [{
    type = "SSD"
    size = 200
  }]
}

variable "instance_tags" {
  description = "The tags configuration of the ECS instance"

  type    = map(string)
  default = {}
}

######################################################################
# DEW input parameters for ECS instance
######################################################################

variable "keypair_name" {
  description = "The name of the key-pair for encryption and login ECS instance"

  type    = string
  default = null
}
