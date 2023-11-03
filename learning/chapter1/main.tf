terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
    #   source  = "local-registry/huaweicloud/huaweicloud"
      version = "~> 1.56.0"
    }
  }
}
