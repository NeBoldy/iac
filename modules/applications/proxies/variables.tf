# General environment information
variable "stage" {
  type        = string
  description = "The stage to deploy to."
}

variable "environment" {
  type        = string
  description = "The environment to deploy to."
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to."
}

variable "aws_account_id" {
  type        = string
  description = "The AWS account to deploy to."
}