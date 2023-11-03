# 如何使用变量

## 如何定义输入变量

```hcl
variable "image_name" {
  type        = string
  default     = "Windows Server 2013"
  description = "This is an available image name of the ECS instance"
  sensitive   = true
  nullable    = false

  validation {
    condition     = length(var.image_name) > 7 && substr(var.input_variable_name, 0, 7) == "Windows"
    error_message = "Invalid format of the IMS image name"
  }
}
```

输入变量用于向资源或模块传递值，同代码中的变量的作用。
其定义由几个部分组成：
+ **type**: （非必选）变量类型，基本类型有：`string`、`number`和`bool`，复杂类型有list(\<TYPE\>)、set(\<TYPE\>)、map<(\<TYPE\>)、object({\<ATTR_NAME\> = \<TYPE\>, ...})和tuple([\<TYPE\>, ...])。
+ **default**: （非必选）输入变量的默认值。
+ **description**: （非必选）输入变量的描述。
+ **validation**: （非必选）输入变量的自定义校验配置，由condition（布尔表达式）和error_message组成。
+ **sensitive**: （非必选）（布尔类型）敏感变量标记，用于限制output的输出，默认值false。
+ **nullable**: （非必选）（布尔类型）是否允许输入变量在module中赋空值，默认值false。

在上一章节中，密钥对就是通过两个环境变量向provider模块赋值，且通过一个`.auto.tfvars`文件为这两个变量赋值。
这是为变量赋值的三种方式之一。
+ 其一是缺省并使用脚本中预设的default值。
+ 其二是通过CLI命令中的-var操作符向各变量赋值以替代各变量的default内容。
  `terraform apply -var region_name=cn-north-4`
+ 其三是使用`.tfvars`文件中预设的key-value替代各变量的default内容。

注意: 输入变量不可用于terraform模块的定义中。

## 如何定义输出变量

```hcl
output "output_variable_name" {
  depend_on = [
    data.huaweicloud_xxx_xxx.test.xxx,
    huaweicloud_xxx_xxx.test.xxx,
  ]

  value       = "xxx"
  description = "This is an output variable"
}
```

输入变量用于向UI或module的父级模块传递结果。
其定义由几个部分组成：
+ **depends_on**: （非必选）变量对其他资源或数据源的依赖，用于控制输出执行的时间点。
+ **value**: （非必选）输出变量的值。
+ **description**: （非必选）输出变量的描述。
+ **sensitive**: （非必选）（布尔类型）敏感变量标记，用于限制output的输出，默认值false。
+ **precondition**: （非必选）执行输出前的校验，内容同输入变量的condition变量的自定义校验，由condition（布尔表达式）和error_message组成。
