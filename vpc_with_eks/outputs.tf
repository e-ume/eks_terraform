output "eks_endpoint" {
    value = aws_eks_cluster.eks_cluster.endpoint
    description = "EKS Cluster Endpoint"
}