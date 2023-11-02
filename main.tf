module "Tf_vpc" {
  source = "./modules/networking"
  vpc_tags = {
   Name = "Tag Test"
   Location = "HYD"  
             }
} 


module "ec2_instance" {
  # Name = "EC2-$[count.index + 1]"
  source = "./modules/ec2"
  vpc_id = module.Tf_vpc.vpc_id
  ami = "ami-0c147c2e2b026f094"
  key_name = "sharath"
  subnet_ids = module.Tf_vpc.pub_sub_ids
  web_ingress_rules={
        "22"={
            port=22
            protocol="tcp"
            #generally we provide the ip address/security group of the server which connects to this 
            cidr_blocks=["0.0.0.0/0"]
            description="allow ssh"

         }
         "80"={
             port=80
             protocol="tcp"
            #generally we provide the ip address/security group of the server which connects to this 
            cidr_blocks=["0.0.0.0/0"]
            description="allow 80 everywhere"
        }
    }
    
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.Tf_vpc.vpc_id
  subnet_ids = module.Tf_vpc.pub_sub_ids
  alb_ingress_rules = {
    "80" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow 80 everywhere"
    }
  }
  instance_ids = module.ec2_instance.instance_ids
}

# Create RDS
module "jhc_rds" {
  source  = "./modules/rds"
  sub_ids = module.Tf_vpc.pri_sub_ids
  vpc_id  = module.Tf_vpc.vpc_id
  rds_ingress_rules = {
    "app1" = {
      port            = 5432
      protocol        = "tcp"
      cidr_blocks     = []
      description     = "allow ssh within organization"
      security_groups = [module.ec2_instance.security_group_id]
    }
  }
}
module "s3bucket" {
  source = "./modules/s3"
}