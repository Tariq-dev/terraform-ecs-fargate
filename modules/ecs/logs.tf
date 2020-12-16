# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "myapp_log_group" {
  name              = var.awslogs-group-path
  retention_in_days = 30

  tags = {
    Name = "cb-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "my-log-stream1"
  log_group_name = aws_cloudwatch_log_group.myapp_log_group.name
}

#variable "path" {
#  default = "/ecs/myapp"
#}