variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cidr_block" {
  description = "Subnet CIDR block"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}

variable "map_public_ip" {
  description = "Enable public IP on launch"
  type        = bool
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}
