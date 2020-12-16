module "my_ecs" {
  source = "./modules/ecs"
  #aws_region = "us-west-2"
  ecs_task_execution_role_name = "myEcsTaskExecutionRole"
  app_image = "httpd:latest"
  app_port = 80
  app_count = 1
  fargate_cpu = "1024"
  fargate_memory = "2048"

  

  #depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

output "my_alb_hostname" {
    value = "${module.my_ecs.alb_hostname}"
  }