module "my_ecs" {
  source = ".././modules/ecs"
  aws_region = "us-east-2"
  ecs_task_execution_role_name = "myEcsTaskExecutionRole1"
  #myapp-load-balancer = "myapp-load-balancer1"
  #myapp-target-group = "myapp-target-group1"
  myapp-cluster = "ML-new-cluster"
  ml-node-zero = "ml-node-zero"
  ml-node-one = "ml-node-one"
  ml-node-two = "ml-node-two"
  ml-node-three = "ml-node-three"
  ml-node-four = "ml-node-four"
  ml-node-five = "ml-node-five"
  #myapp-service = "myapp-service1"
  awslogs-group-path = "/ecs/myapp1"
  node-zero-image = "921602416417.dkr.ecr.us-east-2.amazonaws.com/zero-node:latest"
  node-one-image = "921602416417.dkr.ecr.us-east-2.amazonaws.com/first-node:latest"
  node-two-image = "921602416417.dkr.ecr.us-east-2.amazonaws.com/second-node:latest"
  node-three-image = "921602416417.dkr.ecr.us-east-2.amazonaws.com/third-node:latest"
  node-four-image = "921602416417.dkr.ecr.us-east-2.amazonaws.com/fourth-node:latest"
  node-five-image = "921602416417.dkr.ecr.us-east-2.amazonaws.com/fifth-node:latest"
  app_port = 5672
  app_count = 1
  min_capacity = 1
  max_capacity = 6
  fargate_cpu = "2048"
  fargate_memory = "4096"
  #security_group = "sg-0e417c9dc974cce22"
}

#output "my_alb_hostname" {
#    value = "${module.my_ecs.alb_hostname}"
#  }