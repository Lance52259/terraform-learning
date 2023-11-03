# 课后练习

注意：Terraform版本不应低于`1.3.0`.

## 练习1

配置一个名为`student_age_input`的输入变量，并为其补充下列内容：
- **类型**：数值
- **描述**：Age of Terraform student
- **默认值**：24

## 练习2

在练习1的基础上添加一个自定义校验：
- 年龄的可填范围：`22`~`35`

## 练习3

将练习2的参数进行输出，输出的变量名称设为`student_age_ouput`

## 练习4

为`student_age_input`变量配置**sensitive=true**，并使用练习3中的输出变量进行打印，观察输出结果
