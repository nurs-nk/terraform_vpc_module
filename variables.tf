variable "vpc_cidr_block" {
  description = "cidr_block for vpc"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnets_cidr_blocks" {
  description = "list of cidr_block for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/26", "10.0.0.64/26"]
}

variable "private_subnets_cidr_blocks" {
  description = "list of cidr_block for private subnets"
  type        = list(string)
  default     = ["10.0.0.128/26", "10.0.0.192/26"]
}
