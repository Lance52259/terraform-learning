# 常用表达式

除前几章介绍的资源用法和module结构用法外，有一些常见语法表达式需要我们熟记，它们可以帮助我们应对复杂场景下的脚本编写。

## Format String

字符串格式化在脚本中是一个最常见的用法，我们有两种方式用于字符串格式化：
+ **format()函数**
+ **${}操作符**

format()函数一般只用于hcl文件中，而${}操作符则被hcl文件和json文件广泛使用，这也是我们推荐的一种对于非复杂字符串格式化用法。

```hcl
resource "huaweicloud_vpc" "format" {
  count = 3

  name = format("vpc-%s-%d", var.name_suffix, count.index)
}

resource "huaweicloud_vpc" "dollar" {
  count = 3

  name = "vpc-${var.name_suffix}-${count.index}"
}
```

## For

For表达式通过转换一个复杂类型值创建另一个复杂类型值。输入值中的每个元素对应于结果中的一个值（结果可以是空值），并且可以使用任意表达式将每个输入元素进行转换。
例如，通过For表达式，我们可以将一个字符串列表的全部元素转换成大写并另存为一个结果值：

```hcl
[for s in var.list : upper(s)]
```

输入值可以是以下类型：
+ **list**
+ **set**
+ **tuple**
+ **map**
+ **object**

元素转换不仅限于函数的使用，也可以使用表达式或字符串拼接：

```hcl
# 用于元素转换的表达式不仅限于加减乘除，也可以是三目运算符等
[for k, v in var.map : length(k) + length(v)]

# 对元素进行字符串格式化
[for i, v in var.list : "${i} is ${v}"]
```

上述这些For表达式结果都是列表类型（list），如果需要输出map类型，则参考以下表达：

```hcl
{for s in var.list : s => upper(s)}
# 输入: ["foo", "bar", "baz"]
# 输出: {
          foo = "FOO"
          bar = "BAR"
          baz = "BAZ"
        }
```

For表达式也广泛用于对列表等结构的过滤，如过滤所有以`tf`字符串开头的元素并将其转换为全大写字符串：

```hcl
[for s in var.list : upper(s) if startswith(s, "tf")]
```

## Splat

Splat表达式是For语法遍历元素的简写表达，用于提取某一结构体列表元素的属性，如获取结构体列表元素的ID属性有以下表达：

```hcl
# For表达式
[for o in var.list : o.id]

# Splat表达式
var.list[*].id
```

Splat表达式同样适用于资源或数据源的属性返回：

```hcl
# 输出所有查询到的VPC的ID列表
output "resource_ids" {
  value = data.huaweicloud_vpcs.test[*].id
}
```

## Dynamic

某些资源类型在其参数中包含可重复的嵌套块，这些块通常包含对象相关（或嵌入其中）的对象引用，For表达式和Splat表达式无法应对这一复杂场景。
Dynamic表达式为这一特殊场景的表达式提供了有效的且可嵌套的解决方案：

不使用Dynamic表达式时，结构体列表需要的脚本代码量与列表长度挂钩：

```hcl
resource "huaweicloud_apig_channel" "test" {
  ...

  member {
    id   = huaweicloud_compute_instance.test[0].id
    name = huaweicloud_compute_instance.test[0].name
  }
  member {
    id   = huaweicloud_compute_instance.test[1].id
    name = huaweicloud_compute_instance.test[1].name
  }
  member {
    id   = huaweicloud_compute_instance.test[2].id
    name = huaweicloud_compute_instance.test[2].name
  }
  ...
}
```

而使用Dynamic语法可以极大简化结构体的定义书写：

```hcl
resource "huaweicloud_apig_channel" "test" {
  ...

  dynamic "member" {
    for_each = huaweicloud_compute_instance.test[*]

    content {
      id   = member.value.id
      name = member.value.name
    }
  }
}
```
