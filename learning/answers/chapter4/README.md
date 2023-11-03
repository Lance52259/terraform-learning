# 课后练习答案

## 练习1

```hcl
resource "huaweicloud_vpc" "test" {
  name = "relationship_test"
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet" "test" {
  vpc_id = huaweicloud_vpc.test.id

  name       = "relationship_test"
  cidr       = "192.168.0.0/20"
  gateway_ip = "192.168.0.1"
}

resource "huaweicloud_networking_vip" "test" {
  network_id = huaweicloud_vpc_subnet.test.id
}
```

## 练习2

```hcl
variable "vpc_name" {
  default = "relationship_test"
}

resource "huaweicloud_vpc" "test" {
  name = var.vpc_name
  cidr = "192.168.0.0/16"
}

data "huaweicloud_vpcs" "test" {
  name = var.vpc_name
}
```

## 练习3

```hcl
resource "huaweicloud_vpc" "test" {
  name = "relationship_test"
  cidr = "192.168.0.0/16"
}

data "huaweicloud_vpcs" "test" {
  name = huaweicloud_vpc.test.name
}
```
