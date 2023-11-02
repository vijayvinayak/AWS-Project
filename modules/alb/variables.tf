variable "tg_name" {
  default = "ALBTarget"
}

variable "tg_port" {
  default = "80"
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "vpc_id" {}

variable "alb_name" {
  default = "ALB"
}
variable "internal" {
  default = "false"
}
variable "subnet_ids" {
}

variable "alb_ingress_rules" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}
variable "instance_ids" {
  type    = list(string)
  default = []
}
variable "alb_port" {
    default = 80
}

variable "alb_protocol" {
    default = "HTTP"
}