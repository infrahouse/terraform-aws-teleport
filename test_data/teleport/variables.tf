variable "region" {}
variable "role_arn" {
  default = null
}

variable "environment" {
  default = "development"
}

variable "backend_subnet_ids" {
  type = list(string)
}

variable "frontend_subnet_ids" {
  type = list(string)
}

variable "zone_name" {
  description = "Route53 zone Name to use for the Teleport server"
  type        = string
}
