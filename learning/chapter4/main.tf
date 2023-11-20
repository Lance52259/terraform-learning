terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

variable "private_ips" {
  default = ["192.168.0.68", "172.16.0.1", "172.16.0.73"]
}

output "server_configuration" {
  value = <<EOT
%{ for private_ip in var.private_ips }Server ${private_ip}%{ endfor }
EOT
}

output "multi_text" {
  value = <<-EOT
  HELLO
    WORLD
EOT
}
