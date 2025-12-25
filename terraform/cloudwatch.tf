# ============================================================
# CLOUDWATCH LOGS
# ============================================================

resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/ecs/strapi-aditya"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "aditya-strapi-high-cpu"
  comparison_operator = "GreaterThanThreshold" #when the alarm should trigger.
  evaluation_periods  = 2                      #Number of consecutive periods the condition must be met.
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 80 # 80% CPU
  alarm_description   = "This metric monitors ECS CPU utilization"


  dimensions = {
    ClusterName = aws_ecs_cluster.strapi.name
    ServiceName = aws_ecs_service.strapi.name
  }

  tags = {
    Name = "aditya-strapi-high-cpu-alarm"

  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "aditya-strapi-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 85 # 85% Memory
  alarm_description   = "This metric monitors ECS memory utilization"


  dimensions = {
    ClusterName = aws_ecs_cluster.strapi.name
    ServiceName = aws_ecs_service.strapi.name
  }

  tags = {
    Name = "aditya-strapi-high-memory-alarm"

  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_task_count_low" {
  alarm_name          = "aditya-strapi-no-running-tasks"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = 60 # 1 minute
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alert when no tasks are running"

  treat_missing_data = "breaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi.name
    ServiceName = aws_ecs_service.strapi.name
  }

  tags = {
    Name = "aditya-strapi-task-count-alarm"

  }
}

