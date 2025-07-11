resource "aws_instance" "pokemon_game" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = "LabInstanceProfile" # Attach existing profile here

  user_data = <<-EOF
    #!/bin/bash
    cd /home/ubuntu
    git clone https://github.com/WhiskersStack/PokemonWithDynamoDB.git
    chown -R ubuntu:ubuntu /home/ubuntu/PokemonWithDynamoDB
    echo 'if [ -n "$SSH_CONNECTION" ]; then cd ~/PokemonWithDynamoDB && python3 main.py; fi' >> /home/ubuntu/.bashrc
  EOF

  tags = {
    Name = "final"
  }
}
