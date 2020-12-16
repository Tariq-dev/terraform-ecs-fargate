# auto_scaling.tf

resource "aws_appautoscaling_target" "target3" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.node3.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up3" {
  name               = "node3_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.node3.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target3]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down3" {
  name               = "node3_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.node3.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target3]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high3" {
  alarm_name          = "node3_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.node3.name
  }

  alarm_actions = [aws_appautoscaling_policy.up3.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low3" {
  alarm_name          = "node3_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.node3.name
  }

  alarm_actions = [aws_appautoscaling_policy.down3.arn]
}