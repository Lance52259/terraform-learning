# 课后练习答案

## 练习1

```hcl
variable "student_age_input" {
  type        = number
  description = "Age of Terraform student"
  default     = 24
}
```

## 练习2

```hcl
variable "student_age_input" {
  type        = number
  description = "Age of Terraform student"
  default     = 24

  validation {
    condition     = var.student_age_input >= 22 && var.student_age_input <= 35
    error_message = "Invalid student age, the valid value ranges from 22 to 35."
  }
}
```

## 练习3

```hcl
variable "student_age_input" {
  type        = number
  description = "Age of Terraform student"
  default     = 24

  validation {
    condition     = var.student_age_input >= 22 && var.student_age_input <= 35
    error_message = "Invalid student age, the valid value ranges from 22 to 35."
  }
}

output "student_age_ouput" {
  value = var.student_age_input
}
```

## 练习4

```hcl
variable "student_age_input" {
  type        = number
  description = "Age of Terraform student"
  default     = 24
  sensitive   = true

  validation {
    condition     = var.student_age_input >= 22 && var.student_age_input <= 35
    error_message = "Invalid student age, the valid value ranges from 22 to 35."
  }
}

output "student_age_ouput" {
  value = var.student_age_input
}
```
