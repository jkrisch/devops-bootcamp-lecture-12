module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name = var.cluster_name
  #k8s version
  cluster_version = var.kubernetes_version

  #list of subnets of which we want the worker nodes started in 
  #our workloads should be scheduled in the private subnets
  #the public subnets are for external resources like loadbalancer
  #to reference these we use the outputs of the vpc module
  subnet_ids = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  #for kubectl to able to connect we need the public access
  cluster_endpoint_public_access  = true

  tags = {
    environment = var.env_prefix
  } 

  #to be able to see the resources add this line
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    dev = {
        min_size = 1
        max_size = 3
        desired_size = 3

        instance_types = ["t2.small"]
        iam_role_additional_policies = {
          AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
    }
  }

  fargate_profiles = {
    my_farget_profile = {
      name = "myapp-fargate-profile-jk"
      selectors = [{namespace = "my-java-app-ns"}]
      tags = {
        env = var.env_prefix
      }
    }
  }


  cluster_addons = {
    aws-ebs-csi-driver = { } 
  }

}