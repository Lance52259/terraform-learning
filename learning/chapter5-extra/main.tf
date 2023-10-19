terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

data "huaweicloud_availability_zones" "test" {}

module "vpc_service" {
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc"

  vpc_name                           = var.vpc_name
  vpc_cidr_block                     = var.vpc_cidr
  subnets_configuration              = var.subnets_configuration
  security_group_name                = var.security_group_name
  security_group_rules_configuration = var.security_group_rules_configuration
}

module "ecs_service" {
  source = "./modules/ecs"

  subnet_id          = module.vpc_service.subnet_ids[0]
  security_group_ids = [module.vpc_service.security_group_id]
  availability_zone  = data.huaweicloud_availability_zones.test.names[0]

  instance_name               = var.instance_name
  instance_flavor_performance = var.instance_flavor_performance
  instance_flavor_cpu         = var.instance_flavor_cpu
  instance_flavor_memory      = var.instance_flavor_memory
  instance_image_name         = var.instance_image_name
  system_disk_type            = var.system_disk_type
  system_disk_size            = var.system_disk_size
  admin_password              = var.admin_password
  data_disks_configuration    = var.data_disks_configuration
}
