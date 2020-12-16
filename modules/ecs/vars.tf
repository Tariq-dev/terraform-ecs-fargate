# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}
variable "awslogs-group-path" {
  default = "/ecs/myapp"
}
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "myapp-load-balancer" {
  description = "myapp-load-balancer name"
  default = "myapp-load-balancer"
}

variable "myapp-cluster" {
  default = "myapp-cluster"
}

variable "ml-node-zero" {
  default = "myapp-task"
}
variable "ml-node-one" {
  default = "myapp-task"
}
variable "ml-node-two" {
  default = "myapp-task"
}
variable "ml-node-three" {
  default = "myapp-task"
}
variable "ml-node-four" {
  default = "myapp-task"
}
variable "ml-node-five" {
  default = "myapp-task"
}
variable "myapp-service" {
   default = "myapp-service"
  
}

variable "myapp-target-group" {
  description = "myapp-target-group name"
  default = "myapp-target-group"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "node-zero-image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}
variable "node-one-image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}
variable "node-two-image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}
variable "node-three-image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}
variable "node-four-image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}
variable "node-five-image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}
variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "min_capacity" {
  default = 3
}
variable "max_capacity" {
  default = 6
}


variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}
#variable "security_group" {
#  default = ["aws_security_group.lb.id"]
#}