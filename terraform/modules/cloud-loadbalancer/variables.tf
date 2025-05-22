variable "name" {
  description = "Name of the load balancer"
  type        = string
  default     = "load-balancer"
}

variable "region" {}

variable "project_id" {}

variable "domain" {
  description = "Domain name for the load balancer"
  type        = string
  default     = "www.example.com"
}

variable "cloud_run_name" {
  type = string
}

