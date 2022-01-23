terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}



// this is our tfstate config about ec2.tf to save it for local what if you want to save it in s3 do coment out

/*
    
  terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

    

// this is about vault tfstate file and you have saved that vault-setup file in s3


data "terraform_remote_state" "vaultest" {
  backend = "local"
  config = {
    path = var.path
  }
}

 */
    
  
// this is about vault tfstate file and ec2.tf will contact with @vault-setup state file whose tfsate file is saved in s3 bucket

data "terraform_remote_state" "vaultest" {
  backend = "s3"
  config = {
    bucket = "your_bucket_name"
    key = "state1/terraform.tfstate"
    region = "ap-south-1"
  }
}


//this will contact with you vault an trying to give you key in accordance with


data "vault_aws_access_credentials" "vaultcred" {
  backend = data.terraform_remote_state.vaultest.outputs.backend
  role    = data.terraform_remote_state.vaultest.outputs.role
}

provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.vaultcred.access_key
  secret_key = data.vault_aws_access_credentials.vaultcred.secret_key
}


# Create AWS EC2 Instance
resource "aws_instance" "test" {
  ami           = "ami-0af25d0df86db00c1"
  instance_type = "t2.micro"

  tags = {
    Name = var.name
  }
}
