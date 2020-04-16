variable "name" {
  type        = string
  description = "Name of the AWS IAM Role."
  default     = "api-gateway-cloudwatch-role"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the AWS IAM Role."
  default     = {}
}
