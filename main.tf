provider "aws" {
    region = "us-east-1"
    access_key = "******"
    secret_key = "******"
} 

resource "aws_vpc" "vpc" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
}

resource "aws_internet_gateway" "igw" {
    vpc_id =  aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_1" {
    vpc_id =  aws_vpc.vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

 resource "aws_subnet" "subnet_2" {
    vpc_id =  aws_vpc.vpc.id
    cidr_block = "10.0.2.0/28"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
 }

 resource "aws_subnet" "subnet_3" {
    vpc_id =  aws_vpc.vpc.id
    cidr_block = "10.0.4.0/28"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
 }

 resource "aws_route_table" "route_table" {
   vpc_id = aws_vpc.vpc.id
   route {
   cidr_block = "0.0.0.0/0" 
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
  name = "eks_demo_role"
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


resource "aws_eks_cluster" "cluster123" {
  name     = "cluster123"
  role_arn = aws_iam_role.eks_demo_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]
  }

  depends_on = [
    aws_iam_role.eks_demo_role
  ]
}


resource "aws_eks_node_group" "group123" {
  cluster_name    = aws_eks_cluster.cluster123.name
  node_group_name = "group123"
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

