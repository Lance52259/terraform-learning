# 如何构建modules

modules是一个树型编排脚本分类管理的结构框架，该结构可以清楚地展示所使用各个服务之间的层级关系、依赖关系，也可以使得一个模块被复数模块使用，降低脚本的代码量。

大多数module由一个根模块和若干个子模块构成，其组成部分与根模块相似，包含资源、数据源以
及变量声明（输入变量及输出变量，如果有的话）定义的`.tf`文件。

首先以一个ECS的module为例了解module的大概组成：

```shell
huaweicloud-provider-example
|- main.tf
|- variables.tf
|- outputs.tf (Optional)
|- README.md (Optional)
|- modules
   |- network
   |  |- main.tf
   |  |- variables.tf
   |  |- outputs.tf
   |- ecs
      |- main.tf
      |- variables.tf
      |- outputs.tf (Optional)
```

+ **main.tf**: provider和各模块声明。
+ **variables.tf**: 各模块资源所使用的参数声明。
+ **outputs.tf**: 各模块资源或表达式关系值的输出声明。
+ **README.md**: 此模块的详细描述（推荐每个开发者在每个模块都提供对应的描述）。
+ **network**: 网络子模块，其包含**main.tf**、**variables.tf**和**outputs.tf**。
+ **ecs**: ECS子模块，其包含**main.tf**、**variables.tf**和**outputs.tf**（如果有的话）。

## 根模块

在上一节介绍的ECS module样例中，除了modules文件夹外的其他`.tf`文件共同构成了该module的根模块:

```shell
huaweicloud-provider-example
|- main.tf
|- variables.tf
|- outputs.tf (Optional)
```

每个文件的作用如下：
+ **main.tf**: 包含provider和资源声明。
+ **variables.tf**: 包含所有资源使用的参数。
+ **outputs.tf**: 包含所有资源导出的参数。

### main.tf

部分同前四章介绍的脚本配置，module的main.tf包含了terraform和provider版本引用声明、用户鉴权（可选）以及子模块和根模块资源的声明：

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.38.0"
    }
  }
}

# 可缺省
provider "huaweicloud" {
  region      = var.region
  access_key  = var.access_key
  secret_key  = var.secret_key
  project_id  = var.project_id
}

module "network" {
  source = "./modules/network"

  vpc_name = var.vpc_name
}

...
```

其中，`main.tf`的子模块声明揭示了其功能涉及的服务以及使用说明，由一个或多个module块构成，例如：

```hcl
# 包含所有用于创建ECS实例的相关网络资源的子模块声明
module "network_service" {
  source = "./modules/network"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}
```

其中，**source**声明了子模块所在的路径，`./modules/network`表示了网络模块的所在位置在当前目录下的`modules/network`文件夹中。
当然，**source**也可以指定远端的module仓库或其发布的版本包作为子模块引用的源，例如：

```hcl
# 包含所有用于创建ECS实例的相关网络资源的子模块声明
module "network_service" {
  # 使用远端仓库作为子模块的引用源
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}
```

或

```hcl
module "network_service" {
  # 使用远端仓库作为子模块的引用源
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc?ref=v1.1.0"

  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block
}
```

module块中`source = "./modules/network"`声明了子模块的引用路径，`name_prefix`和`vpc_cidr`为网络子模块创建VPC、子网及安全组资源
所需的参数，通过输入变量的方式从根模块向子模块传递。

## variables.tf

同第三章介绍的输入变量的配置，除根目录额外支持CLI输入外，模块中支持通过父模块传递或缺省值为脚本提供输入值:

```
variable "vpc_name" {
  description = "The name used to create the VPC resource"
  default     = "vpc-example"
}

...
```

module中同样支持variable的所有配置，如：加入自定义校验规则优化人机交互

```
variable "vpc_name" {
  description = "The name used to create the VPC resource"

  validation {
    condition = length(regexall("^[\\w-.]{1,64}$", var.vpc_name)) > 0
    error_message = "The name can contain of 1 to 64 characters, only letters, digits, underscores (_), hyphens (-) and dots (.) are allowed."
  }
}

...
```

注意：父模块向子模块传值时可能由于子模块的参数泛用性设计，会出现复杂类型的变量夹带null值的传递。因此了解nullable和type的默认类型是设计复杂module的必修课。

```hcl
variable "subnets_configuration" {
  description = "The configuration for the subnet resources to which the VPC belongs"

  type = list(object({
    name         = string
    description  = optional(string, null)
    cidr         = string
    ipv6_enabled = optional(bool, true)
    dhcp_enabled = optional(bool, true)
    dns_list     = optional(list(string), null)
    tags         = optional(map(string), {})
    delete_timeout = optional(string, null)
  }))

  default = [
    {
      name = "module-default-subnet"
      cidr = "192.168.16.0/20"
    }
  ]
}
```

optional方法是`1.3.0+`版本引入的缺省值定义，允许用户在传递复杂类型变量（object）时可以只传部分成员参数的值。
而在`main.tf`中可以根据null来控制不同场景下的参数填写规则，如：

```hcl
resource "huaweicloud_compute_instance" "this" {
  name = var.name_suffix != null ? format("%s-%s", var.instance_name, var.name_suffix) : var.instance_name

  ...
}
```

注意：null不能在输入变量的`nullable=false`的情况下连续向下传递两层。

### outputs.tf

根模块的**outputs.tf**可缺省，该文件表示脚本应用和刷新后打印在终端上的信息，而子模块中的output定义则表示向上一级模块回传值，其定义方法同第三章所述：

```
output "network_id" {
  description = "The ID of the subnet resource within HUAWEI Cloud"
  value       = huaweicloud_vpc_subnet.test.id
}

...
```

例如：当网络子模块中的子网资源完成创建后需要将其网络ID向其父模块传递，则需要定义输出变量。

```
# 包含所有用于创建ECS实例的数据源以及ECS实例资源本身的子模块声明
module "ecs_service" {
  source = "./modules/ecs"

  network_id = module.network_service.network_id
  ...
}
```

根模块接收网络子模块的网络ID，传入ECS模块中用于创建ECS实例，其中引用方式为`module.{module_name}.{output_name}`。

## 子模块main.tf

子模块的`main.tf`与根模块的`main.tf`类似，需要声明provider的引用版本以及资源的定义，而鉴权部分可以从根模块继承而无需重复声明（如
果使用的是同一套鉴权信息的话）。

```
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}
```

## 关联关系

上述三个.tf文件定义了一个完整的Terraform可执行脚本，其执行顺序在Terraform中是：

+ 执行`terraform init`，根据版本和云厂商信息将provider下载到本地（**main.tf**文件中对应的terraform块和provider块的配置信息）。
+ 执行`terraform apply`，根据**variables.tf**文件定义的参数列表一一要求用户输入（如果有的话），将这些参数分别传递给**main.tf**文件中的各子模块（如果有的话），生成对应的执行计划，然后将部分参数回传给父模块，不断递归，直至所有模块完成执行计划的生成。
+ 确认执行`terraform apply`，根据执行计划创建资源。
+ 创建完成后根据outputs.tf文件中的出参定义，从各资源中取值并输出到终端。
