# variable "region" {
#   type = string
# }
# variable "ami" {
#   type = string
# }
# variable "instance_type" {
#   type = string
# }
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "public_key" {
  type = string
}
variable "private_key" {
  type = string
}
# variable "key_name" {
#   type = string
# }
