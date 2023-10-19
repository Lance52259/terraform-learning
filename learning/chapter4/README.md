# 如何建立资源间的依赖

terraform的资源间依赖分为显式依赖和隐式依赖两种，用于控制资源创建的先后顺序。

## 参数和属性的特性

学习依赖之前我们需要先了解资源的参数和属性都具有哪些特性。

+ **Required**: 必选参数，开创建之前必须得赋予其确切值。
+ **Optional**: 可选参数，开创建之前不是必须得赋予其确切值。
+ **Computed**: \<know after apply\>，对于没有**Optional**特性的字段，其表示为属性，仅在创建或更新完成后才能得知其具体的值，广泛用于资源间依赖的构建（高版本terraform取消了这一特殊性）。对于具有**Optional**特性的字段，其表示值可能会在创建完成后发生变更，具有不确定的特性，也必须待创建或更新完成后才能得知其具体的值（高版本terraform也可用于构建资源间的依赖）。

## 如何建立显式依赖

```hcl
resource "huaweicloud_vpc_eip_associate" "test" {
  ...
}

resource "huaweicloud_compute_instance" "test" {
  depends_on = [huaweicloud_vpc_eip_associate.test]

  ...
}
```

通过在资源（数据源）中声明`depends_on`来为某个特定资源指定依赖，使其创建时间点位于被依赖资源之后。

## 如何建立隐式依赖

### 资源之间的隐式依赖

```hcl
resource "huaweicloud_vpc" "test" {
  ...
}

resource "huaweicloud_compute_instance" "test" {
  vpc_id = huaweicloud_vpc.test.id

  ...
}
```

在创建ECS实例时，由于其依赖了VPC资源的ID属性，且属性具有\<know after apply\>特性，故会先等创建完VPC后再获取其ID值并用于ECS实例的创建（创建ECS实例前必会先等VPC创建完毕，其他被隐式依赖的资源同理）。

### 资源与数据源之间的依赖

```hcl
resource "huaweicloud_vpc" "test" {
  ...
}

data "huaweicloud_vpcs" "test" {
  name = huaweicloud_vpc.test.name
}
```

由于VPC的name参数是一个Required字段，其不具备\<know after apply\>特性，在创建资源就能得知其值，根据上一节的结论，只有引用\<know after apply\>特性的字段时，才能建立隐式依赖。这里似乎只能通过第一节的显式依赖让数据源的执行顺序在资源之后。

```hcl
resource "huaweicloud_vpc" "test" {
  ...
}

data "huaweicloud_vpcs" "test" {
  depends_on = [huaweicloud_vpc.test]

  name = huaweicloud_vpc.test.name
}
```

但是，1.x.0+版本的terraform解决这个隐式依赖的问题，使得Required参数不再需要通过depends_on就能被其他资源用于隐式依赖的构建。

```
# data.huaweicloud_vpcs.test will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "huaweicloud_vpcs" "test" {
      + id     = (known after apply)
      + name   = "learning-demo-vpc"
      + region = (known after apply)
      + vpcs   = (known after apply)
    }
```

例外：Required参数无法被module中的资源用于隐式依赖的建立。
