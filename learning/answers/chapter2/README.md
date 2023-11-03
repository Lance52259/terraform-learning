# 课后练习答案

## 练习1

```hcl
provider "huaweicloud" {
  region     = "cn-north-4"
  access_key = "********"
  secret_key = "********"
}

data "huaweicloud_availability_zones" "test" {}
```

## 练习2

在执行终端上配置以下几个环境变量：

```shell
export HW_REGION_NAME="cn-north-4"
export HW_ACCESS_KEY="********"
export HW_SECRET_KEY="********"
```

随后配置以下脚本并执行：

```hcl
data "huaweicloud_availability_zones" "test" {}
```
