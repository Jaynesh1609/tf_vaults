terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.17.0"
    }
  }
}

provider "vault" {}

// just for time how much it is going to create

resource "vault_aws_secret_backend" "aws" {

  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "3600"
}

// this is vault is using and trying to give access for this only

resource "vault_aws_secret_backend_role" "vaultest" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "playwithtf-vault-role"
  credential_type = "iam_user"

//allow iam:* in the policy so it may read the infrastructure

  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": "iam:*",        
          "Effect": "Allow",                    
          "Resource": "*"
        },
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}

/*
  policy_arns = [
"arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]

}
*/


output "backend" {
  value = vault_aws_secret_backend.aws.path
}

output "role" {
  value = vault_aws_secret_backend_role.vaultest.name
}


