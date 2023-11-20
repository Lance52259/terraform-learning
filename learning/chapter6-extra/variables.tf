variable "vpc_name" {
  description = "The name of the VPC"
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
}

variable "subnets_configuration" {
  description = "The configuration of the VPC subnets"
}

variable "security_group_name" {
  description = "The name of the security group"
}

variable "security_group_rules_configuration" {
  description = "The name of the security group"
}

variable "instance_flavor_performance" {
  description = "The performance type of the ECS instance flavor"
}

variable "instance_flavor_cpu" {
  description = "The CPU number of the ECS instance flavor"
}

variable "instance_flavor_memory" {
  description = "The memory number of the ECS instance flavor"
}

variable "instance_image_name" {
  description = "The name of the IMS image that ECS instance used"
}

variable "instance_name" {
  description = "The name of the ECS instance"
}

variable "system_disk_type" {
  description = "The type of the system volume"
}

variable "system_disk_size" {
  description = "The size of the system volume, in GB"
}

variable "admin_password" {
  description = "The login password of the administrator"
}

variable "data_disks_configuration" {
  description = "The configuration of data volume of the ECS instance"
}
