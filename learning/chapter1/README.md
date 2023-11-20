# 如何声明terraform和provider配置

## 如何配置terraform模块

作为编排脚本的必备配置，terraform模块声明了编排脚本所使用的工具的必要信息。

```hcl
## HCL格式的模块声明（文件名为main.tf）
terraform {
  required_version = ">=1.3.0"

  required_providers {
    provider_name = {
      ...
    }
  }
}
```

terraform模块提供了两个可配置部分：
+ **required_version**: （非必选）编排所需的terraform版本。
+ **required_providers**: （必选）编排所需的provider加载配置。

required_providers是每一个编排脚本所必须配置的部分。以华为云为例，我们的资源名称前缀为**huaweicloud**，故这里的provider_name应填**huaweicloud**。其他provider同理：G42云为**g42cloud**，法电为**flexibleengine**...

required_providers中配置了我们需要用远端或本地加载的provider包，其中的两个参数标识了我们需要选择远端仓库路径（本地路径）和远端版本（本地版本）。

+ **source**: 待加载仓库的远端或本地路径
+ **version**: 版本信息

除了HCL格式的定义外，terraform还支持JSON格式的定义，如：

```json
// JSON格式的模块声明（文件名为main.tf.json）
{
  "terraform": {
    "required_providers": {
      "provider_name": {
        ...
      }
    }
  }
}
```

### 如何加载远端provider

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}
```

对于远端provider的加载，

+ **source**: 远端仓库的名称，其由两部分组成，分别是**组织**和**仓库**，通过斜杠进行组合，格式为**组织**/**仓库**。
+ **version**: 待加载provider版本号，可通过`=`，`>=`，`~>`等标识符指定需要加载的provider版本优先加载最新版本。
  - `=`：下载指定版本的provider，如不存在该版本号对应的provider时则报错。
  - `>=`：下载不低于指定版本的最新的provider，如不存在大于等于该版本号对应的provider时则报错，如指定`>=1.50.0`且远端有`1.50.0`，`1.50.1`，`1.50.2`和`1.51.0`版本，下载`1.51.0`。
  - `~>`：下载不低于指定版本的最新补丁版本的provider，如不存在该版本号或对应补丁版本的provider时则报错，如指定`~>1.50.0`且远端有`1.50.0`，`1.50.1`，`1.50.2`和`1.51.0`版本，下载`1.50.2`。

  三种方式执行的版本信息均可以通过`terraform init -upgrade`命令进行升级，注意：`=`和`~>`（跨版本时）需要在升级前修改指定的版本信息。

通过JSON格式脚本加载远端provider的写法如下：

```json
// JSON格式的模块声明（文件名为main.tf.json）
{
  "terraform": {
    "required_providers": {
      "huaweicloud": {
        "source": "huaweicloud/huaweicloud",
        "version": "~> 1.56.0"
      }
    }
  }
}
```

### 如何加载本地provider

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.1"
    }
  }
}
```

+ **source**: 本地路径，其查找的上层目录为`~/.terraform.d/plugins`。用户需要根据本机的操作系统版本在source目录下创建正确的版本文件存放目录，格式为：`<provider_version>/<os_type>`，如：我们WSL所使用的Ubuntu所需的目录为`1.56.0/linux_amd64` (以1.56.0版本为例)。
+ **version**: 待加载provider版本号，可通过`=`，`>=`，`~>`等标识符指定需要加载的provider版本优先加载最新版本。
  - `=`：下载指定版本的provider，如不存在该版本号对应的provider时则报错。
  - `>=`：下载不低于指定版本的最新的provider，如不存在大于等于该版本号对应的provider时则报错，如指定`>=1.50.0`且远端有`1.50.0`，`1.50.1`，`1.50.2`和`1.51.0`版本，下载`1.51.0`。
  - `~>`：下载不低于指定版本的最新补丁版本的provider，如不存在该版本号或对应补丁版本的provider时则报错，如指定`~>1.50.0`且远端有`1.50.0`，`1.50.1`，`1.50.2`和`1.51.0`版本，下载`1.50.2`。

  三种方式执行的版本信息均可以通过`terraform init -upgrade`命令进行升级，注意：`=`和`~>`（跨版本时）需要在升级前修改指定的版本信息。

同理，通过JSON格式脚本加载本地provider的写法如下：

```json
// JSON格式的模块声明（文件名为main.tf.json）
{
  "terraform": {
    "required_providers": {
      "huaweicloud": {
        "source": "local-registry/huaweicloud/huaweicloud",
        "version": ">=1.56.1"
      }
    }
  }
}
```
