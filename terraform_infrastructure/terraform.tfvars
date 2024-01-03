region    = "eu-west-2"
cidr_block_range = "10.0.0.0/16"
hostnames_enabled = true
dns_allowed = true
public_subnets_cidr = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]
private_subnets_cidr = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
vpc_name = "project-grp6"
availability_zones = ["eu-west-2a","eu-west-2b","eu-west-2c"]
environment = "dev"
connectivity_type = "private"



db_subnet_grp_name = "rds-subnet-project-group"
db_username =  "hopefornewbies"
rds_instance_name = "RDS_project_db_instance"
db_password = "group6"
allocated_storage = 10
instance_class = "db.t3.micro"
engine_version = "14.7"
engine = "postgres"
secrets_list = ["POSTGRES_USERNAME","POSTGRES_PASSWORD"]
use_secrets_manager = true


cluster_name = "eks-team-project-cluster"
min_size = 2
max_size = 3
desired_size = 2

ecr_name = "team_project_ecr"
