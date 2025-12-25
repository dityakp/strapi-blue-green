# ============================================================
# RDS (POSTGRES)
# ============================================================

resource "aws_db_subnet_group" "strapi_db_subnet_group" {
  name       = "strapi-db-subnet-group-aditya"
  subnet_ids = data.aws_subnets.default_subnets.ids
}

resource "aws_db_instance" "strapi_rds" {
  identifier             = "strapi-db-aditya"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.strapi_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.strapi_db_subnet_group.name
}


# ============================================================
# SECURITY GROUPS
# ============================================================

resource "aws_security_group" "strapi_sg" {
  name   = "strapi-ecs-sg-aditya"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "strapi_rds_sg" {
  name   = "strapi-rds-sg-aditya"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.strapi_rds_sg.id
  source_security_group_id = aws_security_group.strapi_sg.id
}
