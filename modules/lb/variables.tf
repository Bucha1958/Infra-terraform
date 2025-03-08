variable "lb_name" {
  description = "Load Balancer Name"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type        = list(string)
}
