# Devops Bootcamp Lecture 12 - Infrastructure as Code with Terraform

## Exercise 1 - Create Terraform project to spin up EKS cluster
for [mysql_release.tf](mysql_release.tf) to work properly I had to add the line
```tf
depends_on = [module.eks]
```
and deploy the storage class:
```tf
resource "kubernetes_storage_class" "example" {
  metadata {
    name = "terraform-example"
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
```

After creating all the respective files we can the run
```bash
terraform init
terraform apply --auto-approve
```

## Exercise 2 - Configure remote state
To add the remote state we first have to create a s3 bucket on aws using the aws console
**_Note_**
s3 bucket names need to be unique.

After the bucket has been created we can reference it in the backen section of terraform:
```tf
terraform{
    required_version = ">= 0.12"
    backend "s3" {
        bucket = "myapp-tf-s3-bucket-jk"
        key = "myapp/state.tfstate"
        region = "eu-central-1"
    }
    
}
```

