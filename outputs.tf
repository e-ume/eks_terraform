output "eks_endpoint" {
    value = module.eks.eks_endpoint
    description = "EKS Cluster Endpoint"
}