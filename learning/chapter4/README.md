# 类型定义

同其他代码脚本的编写，terraform脚本中对于每个值都有一个与其对应的类型定义，而这又分为基本类型、复杂类型和特殊类型三种。
- 基本类型有：**number**、**string**和**bool**。
- 复杂类型有：**list（tuple）**、**set**和**map（object）**。
- 特殊类型有：**null**、**any**。

## Numbers

number类型也称数值类型，是常用基本类型的一种，其既支持整型（例如：`15`）也支持浮点型（例如：`15.136724`），在variable中的定义为：
```hcl
type = number
```
其赋值的脚本格式为：`= 15`或`= 15.136724`
其对应的函数见[文档](https://developer.hashicorp.com/terraform/language/functions/abs)。

## Strings

string类型也称字符类型，由一个或多个被一组英文双引号包围的字符组成，是脚本中最常用的一种类型，其在variable中的定义为：
```hcl
type = string
```
其赋值的脚本格式为：`= "This is a test description"`

同样的，其对应的函数也是最多的，详见[文档](https://developer.hashicorp.com/terraform/language/functions/chomp)

### 字符串格式化/拼接

字符串类型的变量不仅可以使用某特定值，也可以组合一个至多个任意类型的值，后者组合的方式被称为字符串格式化，其方式有以下两种：

- **${}**: 字符串格式化最直接的写法就是用美元符加一组花括号引用其他参数变量，将其插入字符串中的指定位置，其使用方法如下：
  `name = "${var.name_prefix}-test-${huaweicloud_vpc.test.name}-${count.index}"`
  这一方式在JSON格式的脚本中被广泛使用（其原因是JSON的value只能是字符串，不能直接使用函数）。

- **format()**: 通过函数对字符串进行格式化是HCL格式的脚本对字符串处理的常用手段，其优势是格式化内容简洁直观，其使用方法如下：
  `name = format("%s-test-%s-%d", var.name_prefix, huaweicloud_vpc.test.name, count.index)`

### 特殊字符

| 字符串 | 含义（等价字符） |
| ---- | ---- |
| \n | 换行符 |
| \r | 回车符 |
| \t | 制表符 |
| \\\" | 转义双引号（在字符串中输出双引号的必要写法） |
| \\\\ | 转义反斜杠（在字符串中输出反斜杠的必要写法） |
| \uNNNN | 输出对应四位十六进制ASCII码字符 |
| $${ | 在字符串中输出${，而不是被解析成字符串格式化的标识符 |
| %%{ | 在字符串中输出%{，而不是被解析成if表达式的标识符 |

### 多行字符

terraform允许HCL格式的脚本声明多行文本，以双左箭头符和一组大写标识字符组成，其格式如下：

```hcl
description = <<EOT
  Hello
    World
EOT
```

其输出是：

```bash
Hello
    World
```

样例中以EOT作为标识符（任何英文文本标识符都是允许的），代表“文本结束”。
其中文本以第一行的缩进会被忽略（认定为首行顶格缩进，后续行缩进布标）。
若使用双左箭头和横杠作为标识符前缀则会根据首行字符的缩进对所有行进行剪枝，保持缩进基线一致，如：

```hcl
description = <<-EOT
  Hello
    World
  EOT
```

其输出是：

```bash
Hello
  World
```

### 逻辑表达式

terrafrom允许用户在字符串中使用逻辑表达式，以一个表达式适应多场景的字符串输出。

If表达式

```hcl
description = "Hello, %{ if var.resource_type != "" }${var.resource_name}%{ else }unnamed%{ endif }!"
```

For表达式

```hcl
description = <<EOT
%{ for private_ip in var.private_ips }
Server ${private_ip}
%{ endfor }
EOT
```

通过上述样例输出的结果为：

```
Server 192.168.0.68

Server 172.16.0.1

Server 172.16.0.73
```

不难注意到，各行`Server private_ip`前后留有空行，为提升代码的可读性，可向表达式序列中添加`~`字符去除序列字符串之前或之后的所有空格和换行，如：

```hcl
description = <<EOT
%{ for private_ip in var.private_ips ~}
Server ${private_ip}
%{ endfor ~}
EOT
```

通过上述样例输出的结果为：

```
Server 192.168.0.68
Server 172.16.0.1
Server 172.16.0.73
```

## Bools

bool类型也称布尔类型，是常用的基本类型的一种，其值仅`true`和`false`两种，除了为资源或数据源的参数赋值外，它还被广泛用于三目运算符中。
bool类型在脚本中存在与string类型的隐式转换，如：
- 对于bool类型的参数："true"会被转换为true，而"false"会被自动转换为false。
- 对于string类型的参数：true会被转换为"true"，而false会被自动转换为"false"。

## List/Tuples

list（列表）类型和tuple（元组）类型是一个由一个或多个具有有序整型（由0开始，间隔1）下标的同类型元素组成的列表。

## Sets

类似于list类型，set类型也是一个由一个或多个同类型元素组成的列表，区别在于，set类型的各下标是特定规则计算（默认由所有元素共同计算，部分资源参数或属性的计算规则有所不同）的hash数值。
set和list之间可通过list()方法和set()方法进行转换。

## Maps/Objects

map（字典）类型和object（对象）类型是具有多个成员（字段，参数）组合而成的结构型数据，每个成员都公用一样的结构体参数。

## Null

null作为一个特殊的缺省类型，用于控制一个通用资源定义中的某一个或某几个参数的值不进行设置。

## Any

any是一个代表任意类型的通用类型声明，可用于module之间参数传递时复杂的定义声明简写。
