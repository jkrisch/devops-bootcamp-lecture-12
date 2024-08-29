#!/usr/bin/env groovy

pipeline {   
    agent any
    
    environment {
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stage("provision eks cluster"){
        environment{
            TV_VAR_cluster_name = "my-cluster"
            TV_VAR_env_prefix = "dev"
            TV_VAR_region = "eu-central-1"
            TV_VAR_kubernetes_version = "1.30"
        }
        steps{
            script{
                //tf provision
                sh """
                    echo 'creating EKS cluster ${TV_VAR_cluster_name}'
                    terraform init -migrate-state
                    #terraform apply --auto-approve
                """
                
                //update kubeconfig
                sh "aws eks update-kubeconfig --name TF_VAR_cluster_name --region TF_VAR_region"
            }
        }
    }
  }
}
