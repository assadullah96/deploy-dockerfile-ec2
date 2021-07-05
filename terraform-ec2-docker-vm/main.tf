variable "access_key" {
	default = "<your_access_key>"
}
variable "secret_key" {
	default = "<your_private_key>"
}
variable "region" {
    default = "us-west-2"
}

/* Setup our aws provider */
provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

/*Creating Security Group, allow ssh and http */

resource "aws_security_group" "myInstance-ssh-http" {
        name = "ssh-http-security-group"
        description = "Allowing ssh and http traffic"


        ingress {
                from_port = 22
                to_port   = 22
                protocol  = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
      }

        ingress {
                from_port = 80
                to_port   = 80
                protocol  = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
                from_port   = "0"
                to_port     = "0"
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                self        = true
    }

/*Security gorup ends here */

}

/*Creating aws ec2 instance */
resource "aws_instance" "myInstance" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.myInstance-ssh-http.name}"]
  key_name = "demo-key-terraform-us-east-2"
  /*user_data     = <<-EOF
                  #!/bin/bash
                  sudo apt-get update
                  sudo apt-get -y install docker.io
                  sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
                  sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io                   
                  EOF
    */

  tags = {
    Name = "dockervm"
  }
}

output "DNS" {
  value = aws_instance.myInstance.public_dns
}
