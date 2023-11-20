instance_flavor_performance = "normal"

instance_flavor_cpu = 2

instance_flavor_memory = 4

instance_image_name = "Ubuntu 18.04 server 64bit"

instance_name = "learning-demo-ecs-instance"

system_disk_type = "SSD"

system_disk_size = 60

admin_password = "TerrformTest@123"

data_disks_configuration = [
  {
    type = "SSD"
    size = 100
  }
]
