# 如何配置用户鉴权信息

terraform提供了两种provider鉴权的方式，其中一种方式是通过provider模块将鉴权所需的必要参数配置到脚本中，另一种方式是通过本机环境变量向provider的鉴权参数赋值（需按照文档的环境变量名称映射关系进行配置）。

## 如何通过脚本配置鉴权信息

根据[provider文档](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs)的鉴权部分的参数定义，我们在脚本中可以定义provider模块用于指定待创建资源（待查询数据源）所使用的IAM用户。

```hcl
provider "huaweicloud" {
  region     = "cn-north-4"
  access_key = "****************"
  secret_key = "****************"
}
```

上述的provider块定义制定了用于创建资源（查询数据源）所使用的IAM用户相关信息以及资源和数据源的作用局点。
同样的，provider块定义也可以通过JSON格式的脚本进行表达：

```json
{
  ...

  "provider": {
    "huaweicloud": {
      "region": "cn-north-4",
      "access_key": "****************",
      "secret_key": "****************"
    }
  }
}
```

## 如何通过环境变量配置鉴权信息

根据provider文档的鉴权参数相关描述，在本地执行机配置对应环境变量，如：
+ `region`参数对应`HW_REGION_NAME`环境变量
+ `access_key`参数对应`HW_ACCESS_KEY`环境变量
+ `secret_key`参数对应`HW_SECRET_KEY`环境变量

通过此方法配置鉴权信息时，可缺省provider模块。
