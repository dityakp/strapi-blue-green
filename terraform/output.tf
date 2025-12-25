output "ecs_cluster_name" {
  value = aws_ecs_cluster.strapi.name
}

output "ecs_service_name" {
  value = aws_ecs_service.strapi.name
}

output "rds_endpoint" {
  value = aws_db_instance.strapi_rds.address
}

output "deployed_image" {
  value = var.image_uri
}

output "application_url" {
  value = "http://${aws_lb.strapi_alb.dns_name}"
}

output "load_balancer_dns" {
  value = aws_lb.strapi_alb.dns_name
}

output "ecs_service_info" {
  value = "ECS service deployed with Application Load Balancer"
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.strapi.arn
}
