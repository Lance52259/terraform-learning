terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

variable "availability_zone" {
  default = null
}

variable "instance_flavor_performance" {
  default = "normal"
}

variable "instance_flavor_cpu" {
  default = 8
}

variable "instance_flavor_memory" {
  default = 32
}

variable "is_instance_create" {
  default = true
}

data "huaweicloud_availability_zones" "test" {
  count = var.availability_zone != null ? 0 : 1
}

data "huaweicloud_compute_flavors" "test" {
  count = var.is_instance_create ? (var.availability_zone != null ? 1 : length(data.huaweicloud_availability_zones.test[0].names)) : 0

  availability_zone = var.availability_zone != null ? var.availability_zone : data.huaweicloud_availability_zones.test[0].names[count.index]
  performance_type  = var.instance_flavor_performance
  cpu_core_count    = var.instance_flavor_cpu
  memory_size       = var.instance_flavor_memory
}

output "available_flavor_ids" {
  value = {for i, flavor_ids in data.huaweicloud_compute_flavors.test[*].ids : data.huaweicloud_availability_zones.test[0].names[i] => flavor_ids[0] if length(flavor_ids) > 0}
}
