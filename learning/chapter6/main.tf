terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.40.0"
    }
  }
}

module "network_service" {
  # 使用远端仓库作为子模块的引用源
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc"
#   source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc?ref=v1.1.0"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}
