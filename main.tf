provider "aws" {
    region = "us-east-1"
    access_key = "*****"
    secret_key = "*****"
}

module "eks" {
    source = "./vpc_with_eks"

    subnet_az = var.subnet_az
    subnet_cidr = var.subnet_cidr
    cidr_block = var.cidr_block
    node_group_name = var.node_group_name
    cluster_name = var.cluster_name
    eks_demo_role_name = var.eks_demo_role_name
    vpc_cidr = var.vpc_cidr
}