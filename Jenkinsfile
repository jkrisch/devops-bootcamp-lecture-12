#!/usr/bin/env groovy

pipeline {   
    agent any
    
    environment {
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage("provision eks cluster"){
            environment{
                TF_VAR_cluster_name = "my-cluster"
                TF_VAR_env_prefix = "dev"
                TF_VAR_region = "eu-central-1"
                TF_VAR_kubernetes_version = "1.30"
            }
            steps{
                script{
                    //tf provision
                    sh """
                        echo 'creating EKS cluster ${TF_VAR_cluster_name}'
                        terraform init -migrate-state
                        terraform destroy --auto-approve
                        #terraform apply --auto-approve
                    """
                    
                    //update kubeconfig
                    sh "aws eks update-kubeconfig --name ${TF_VAR_cluster_name} --region ${TF_VAR_region}"
                }
            }
        }
    }
}
