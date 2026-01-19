variable "project" {
  type        = string
  description = "Project tag/name prefix."
  default     = "facilities-mvp"
}

variable "aws_region" {
  type        = string
  description = "AWS region for this environment."
  default     = "us-east-1"
}
