# 课后练习答案

## 练习1

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "= 1.56.0"
    }
  }
}
```

## 练习2

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.56.0"
    }
  }
}
```

## 练习3

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.56.0"
    }
  }
}
```

