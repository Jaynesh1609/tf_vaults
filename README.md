# tf_vaults
Tried to integrate with vaults and aws with terraform


you have to create s3 bucket and add them to you code


be sure while assigning iam role to you vaults

before going to run terraform

Installtion of vault...
   @https://learn.hashicorp.com/tutorials/vault/getting-started-install

vault server -dev -dev-root-token-id="name_ur"

# LINUX / MAC
export VAULT_ADDR='ur_vault_ip'
export VAULT_TOKEN="ur_vault_id_name"

# Windows
 set VAULT_ADDR='ur_vault_ip'
 set VAULT_TOKEN="ur_vault_id_name"

RUN first vault-setup file

then aws-setup file


# terraform init

# terraform plan

# terraform apply
