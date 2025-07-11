data "aws_vpc" "default" {
  default = true
}
module "key" {
  source = "./modules/key"
}
module "security_group" {
  source   = "./modules/security_group"
  name     = "allow_ssh"
  vpc_id   = data.aws_vpc.default.id
  ssh_cidr = "0.0.0.0/0" # You can restrict this to your IP
}
module "ec2" {
  source                 = "./modules/ec2"
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.security_group.security_group_id]
  # tags = var.tags
}
module "dynamodb_pokemon" {
  source         = "./modules/dynamodb"
  table_name     = "Pokemon"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  hash_key_type  = "N"
  range_key      = "name"
  range_key_type = "S"

  tags = {
    Name        = "Pokemon"
    Environment = "dev"
  }
}

output "pokemon_table_name" {
  value = module.dynamodb_pokemon.table_name
}

output "ssh_command" {
  value = "cd to modules/ec2 and run : ssh -i MyKeyPair.pem ubuntu@${module.ec2.public_ip}"
}

