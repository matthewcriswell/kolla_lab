variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-2"
}
variable "preferred_az" {
  description = "Preferred Availability Zone for deploying resources"
  default     = "us-east-2a"
}

variable "home_ip" {
  description = "Home IP address for whitelisting"
  type        = string
  default     = "136.62.35.189/32"
  #default = "98.156.162.42/32"
}

