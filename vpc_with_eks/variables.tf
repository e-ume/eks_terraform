variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "node_group_name" {
  type        = string
  description = "Node Group Name"
}

variable "eks_demo_role_name" {
  type        = string
  description = "Node Group Name"
}

variable "cidr_block" {
  type        = string
  description = "CIDR Block"
}

variable "subnet_cidr" {
  type        = list
  description = "List of Subnet CIDRs"
}

variable "subnet_az" {
  type        = list
  description = "List of AZs"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}