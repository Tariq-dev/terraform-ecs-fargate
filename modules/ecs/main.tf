# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = var.myapp-cluster
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "myapp" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    awslogs-group-path = var.awslogs-group-path
    app_image      = var.node-zero-image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
data "template_file" "myapp1" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    awslogs-group-path = var.awslogs-group-path
    app_image      = var.node-one-image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
data "template_file" "myapp2" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    awslogs-group-path = var.awslogs-group-path
    app_image      = var.node-two-image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
data "template_file" "myapp3" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    awslogs-group-path = var.awslogs-group-path
    app_image      = var.node-three-image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
data "template_file" "myapp4" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    awslogs-group-path = var.awslogs-group-path
    app_image      = var.node-four-image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
data "template_file" "myapp5" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    awslogs-group-path = var.awslogs-group-path
    app_image      = var.node-five-image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
resource "aws_ecs_task_definition" "app" {
  family                   = var.ml-node-zero
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp.rendered
}

resource "aws_ecs_task_definition" "app1" {
  family                   = var.ml-node-one
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp1.rendered
}
resource "aws_ecs_task_definition" "app2" {
  family                   = var.ml-node-two
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp2.rendered
}

resource "aws_ecs_task_definition" "app3" {
  family                   = var.ml-node-three
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp3.rendered
}
resource "aws_ecs_task_definition" "app4" {
  family                   = var.ml-node-four
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp4.rendered
}

resource "aws_ecs_task_definition" "app5" {
  family                   = var.ml-node-five
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp5.rendered
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn
}
resource "aws_ecs_service" "main" {
  name            = var.ml-node-zero
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.lb.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  #load_balancer {
  #  target_group_arn = aws_alb_target_group.app.id
  #  container_name   = "myapp"
  #  container_port   = var.app_port
  #}

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role] #[aws_alb_listener.front_end, 
}
resource "aws_ecs_service" "node1" {
  name            = var.ml-node-one
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app1.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.lb.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
resource "aws_ecs_service" "node2" {
  name            = var.ml-node-two
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app2.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.lb.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
resource "aws_ecs_service" "node3" {
  name            = var.ml-node-three
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app3.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.lb.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
resource "aws_ecs_service" "node4" {
  name            = var.ml-node-four
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app4.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.lb.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
resource "aws_ecs_service" "node5" {
  name            = var.ml-node-five
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app5.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.lb.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
