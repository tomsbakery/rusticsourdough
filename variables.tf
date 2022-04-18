# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile for all resources."

  type    = string
  default = "default"
}

variable "gh_org_name" {
  description = "GitHub organization name."

  type = string
}

variable "gh_user_name" {
  description = "GitHub user name."

  type = string
}
variable "gh_access_token" {
  description = "GitHub personal access token."

  type = string
}