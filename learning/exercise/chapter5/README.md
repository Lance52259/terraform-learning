# 课后练习

## 练习1

创建以下资源，思考这几个资源之间的依赖关系和创建顺序的联系：

- VPC资源
  + 名称：**relationship_test**
  + CIDR：**192.168.0.0/16**
- 子网资源
  + 名称：**relationship_test**
  + CIDR：**192.168.0.0/20**
  + 网关：**192.168.0.1**
- [两个](https://developer.hashicorp.com/terraform/language/meta-arguments/count)虚拟IP资源
  + 所属子网为**relationship_test**

## 练习2

根据第三章所学内容创建一个名为`vpc_name`的输入变量，根据该输入变量创建下列资源（数据源）观察其行为：

- VPC资源
  + 名称：引用输入变量的值
- VPC数据源（huaweicloud_vpcs）
  + 名称：引用输入变量的值

## 练习3

根据第三章所学内容创建一个名为`vpc_name`的输入变量，根据该输入变量创建下列资源（数据源）观察其行为：

- VPC资源
  + 名称：**relationship_test**
- VPC数据源
  + 名称：引用VPC资源的`name`参数值
