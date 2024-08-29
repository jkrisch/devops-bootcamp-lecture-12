data "aws_eks_cluster_auth" "myapp_eks_cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.myapp_eks_cluster.token
  }
}

provider "kubernetes"{
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.myapp_eks_cluster.token
}

resource "kubernetes_storage_class" "tf-storage-class" {
  metadata {
    name = "tf-storage-class"
    annotations = {
        "storageclass.kubernetes.io/is-default-class" =  "true"
    }
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Delete"
  allow_volume_expansion = true
  parameters = {
    type = "gp2"
  }
}

resource "helm_release" "mysql-jk" {
  depends_on = [
    module.eks,
    kubernetes_storage_class.tf-storage-class
    ]
  name       = "mysql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  timeout    = "1000"

  values = [
    "${file("mysql-values.yaml")}"
  ]

  set {
    name  = "volumePeromissions.enabled"
    value = "true"
  }
}