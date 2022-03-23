terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_vpc" "vpc" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"
}

resource "aws_internet_gateway" "igw" {
    vpc_id =  aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_1" {
    vpc_id =  aws_vpc.vpc.id
    cidr_block = element(var.subnet_cidr, 1)
    availability_zone = element(var.subnet_az, 1)
    map_public_ip_on_launch = true
}

 resource "aws_subnet" "subnet_2" {
    vpc_id =  aws_vpc.vpc.id
    cidr_block = element(var.subnet_cidr, 2)
    availability_zone = element(var.subnet_az, 2)
    map_public_ip_on_launch = true
 }

 resource "aws_subnet" "subnet_3" {
    vpc_id =  aws_vpc.vpc.id
    cidr_block = element(var.subnet_cidr, 3)
    availability_zone = element(var.subnet_az, 3)
    map_public_ip_on_launch = true
 }

 resource "aws_route_table" "route_table" {
   vpc_id = aws_vpc.vpc.id
   route {
   cidr_block = var.cidr_block 
    gateway_id = aws_internet_gateway.igw.id
   }
 }

 resource "aws_route_table_association" "rt_association_1" {
    subnet_id = aws_subnet.subnet_1.id
    route_table_id = aws_route_table.route_table.id
 }

 resource "aws_route_table_association" "rt_association_2" {
    subnet_id = aws_subnet.subnet_2.id
    route_table_id = aws_route_table.route_table.id
 }

 resource "aws_route_table_association" "rt_association_3" {
    subnet_id = aws_subnet.subnet_3.id
    route_table_id = aws_route_table.route_table.id
 }

 resource "aws_iam_role" "eks_demo_role" {
  name = var.eks_demo_role_name
  managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "eks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_demo_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]
  }

  depends_on = [
    aws_iam_role.eks_demo_role
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_demo_role.arn
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]

  scaling_config {
    desired_size = 3
    max_size = 3
    min_size = 3
  }

  depends_on = [
    aws_iam_role.eks_demo_role
  ]
}