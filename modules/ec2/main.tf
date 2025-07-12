resource "aws_instance" "pokemon_game" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = "LabInstanceProfile" # Attach existing profile here

  # user_data = <<-EOF
  #   #!/bin/bash
  #   cd /home/ubuntu
  #   git clone https://github.com/WhiskersStack/PokemonWithDynamoDB.git
  #   chown -R ubuntu:ubuntu /home/ubuntu/PokemonWithDynamoDB
  #   echo 'if [ -n "$SSH_CONNECTION" ]; then cd ~/PokemonWithDynamoDB && python3 main.py; fi' >> /home/ubuntu/.bashrc
  # EOF

  # This allows Terraform to SSH into your instance
  connection {
    type        = "ssh"
    user        = "ubuntu"                             # or "ec2-user" for Amazon Linux
    private_key = file("${path.module}/MyKeyPair.pem") # Reads the private SSH key file
    host        = self.public_ip                       # The EC2 public IP
  }

  # Copies your script from local to remote instance
  provisioner "file" {
    source      = "${path.module}/init.sh"
    destination = "/tmp/init.sh"
  }

  # Add MyKeyPair.pem to the instance
  provisioner "file" {
    source      = "${path.module}/MyKeyPair.pem"
    destination = "/home/ubuntu/MyKeyPair.pem"
  }

  # Runs the script remotely via SSH
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "sudo /tmp/init.sh"
    ]
  }

  tags = {
    Name = "PokemonGame"
  }
}

resource "aws_instance" "pokemon_db" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids_db

  tags = {
    Name = "Database"
  }
}