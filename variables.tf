variable "cluster_name" {
  default     = "cluster123"
  type        = string
  description = "EKS Cluster Name"
}

variable "node_group_name" {
  default     = "Node_123"
  type        = string
  description = "Node Group Name"
}

variable "eks_demo_role_name" {
  default     = "eks_demo_role"
  type        = string
  description = "Node Group Name"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC CIDR"
}

variable "cidr_block" {
  default     = "0.0.0.0/0"
  type        = string
  description = "CIDR Block"
}

variable "subnet_cidr" {
  default     = [ "10.0.0.0/28", "10.0.2.0/28", "10.0.4.0/28" ]
  type        = list
  description = "List of Subnet CIDRs"
}

variable "subnet_az" {
  default     = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  type        = list
  description = "List of AZs"
}