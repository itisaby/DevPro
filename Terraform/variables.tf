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
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
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
