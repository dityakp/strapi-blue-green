resource "aws_lb" "strapi_alb" {
  name               = "strapi-alb-aditya"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.alb_subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "blue_tg" {
  name        = "blue-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200,204"
    path                = "/_health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "green_tg" {
  name        = "green-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200,204"
    path                = "/_health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }
}
