variable "project_name" {
  type        = string
  description = "General project prefix"
}

variable "source_domains" {
  type        = map
  description = "Domain which to redirect"
}

variable "target_domain" {
  type        = string
  description = "Domain to redirect request to"
}

variable "certificate_region" {
  type    = string
  default = "us-east-1"
}

variable "stage" {
  type = string
  default = "stage"
  description = "the name of your stage"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}


variable "aws_account_id" {
  type = string
  description = "the aws account id of your stage"
}

