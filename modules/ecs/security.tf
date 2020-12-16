# security.tf

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "Socialpie-security-group"
  description = "Socialpie-main"
  vpc_id      = aws_vpc.main.id
  tags = {
    "Name" = "socialpie-auto"
  }
  ingress {
    description = "TLS from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    self = true
    security_groups = ["sg-0e417c9dc974cce22"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    self = true
    security_groups = [aws_security_group.default.id, "sg-0e417c9dc974cce22"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 6379
    to_port         = 6379
    self = true
    security_groups = ["sg-0e417c9dc974cce22"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks = ["111.88.193.15/32","119.160.117.113/32"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 2975
    to_port     = 2975
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 5601
    to_port         = 5601
    cidr_blocks = ["118.103.238.136/32","119.160.69.62/32","39.57.177.244/32"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 5672
    to_port         = 5672
    self = true
    security_groups = ["sg-0e417c9dc974cce22"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 27017
    to_port     = 27017
    self = true
    security_groups = [aws_security_group.default.id, "sg-0e417c9dc974cce22"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 15672
    to_port         = 15672
    cidr_blocks = ["118.103.238.136/32"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 9200
    to_port         = 9200
    self = true
    security_groups = ["sg-0e417c9dc974cce22"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "myapp-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "default" {
  name        = "default-security-group"
  description = "allow inbound access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 8162
    to_port     = 8162
    cidr_blocks = ["118.103.238.136/32"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 27017
    to_port     = 27017
    cidr_blocks = ["118.103.238.136/32","0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5439
    to_port     = 5439
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks     = ["::/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "example" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "-1"
  security_group_id        = "sg-0e417c9dc974cce22"
  source_security_group_id = aws_security_group.lb.id #"sg-067b869ec4a94cd9c"
  depends_on = [aws_vpc_peering_connection.main_to_socialpie]
}
