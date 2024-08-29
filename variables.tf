variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}
variable env_prefix{default = "dev"}
variable region {default="eu-centra-1"}
variable cluster_name{}
variable kubernetes_version{default="1.30"}