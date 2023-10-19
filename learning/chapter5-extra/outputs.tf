output "instance_ids" {
  description = "The ID list of the ECS instances"

  value = module.ecs_service.instance_ids
}

output "instance_id" {
  description = "The ID of the first ECS instance"

  value = module.ecs_service.instance_id
}
