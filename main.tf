provider "aws" {
  region = "us-east-2"
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}


resource "aws_instance" "firstTerrInstance" {
   ami = "ami-097834fcb3081f51a"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.instance.id]
   key_name = "terraform_linux"
  
  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum install httpd -y
              service httpd start
             /* echo "Hello from $(hostname)" | sudo tee  /var/www/html/index.html */
             echo -n  "Hello From " >> /var/www/html/index.html && curl ipinfo.io/ip >> /var/www/html/index.html
              chkconfig httpd on
              EOF

tags = {

Name = "Terrserver"

     }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks =["0.0.0.0/0"]
  }
egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

output "public_ip"{
   value = "${aws_instance.firstTerrInstance.public_ip}"
}

/*variable "print_ip"{
public_ip = http://${aws_instance.firstTerrInstance.public_ip}
}*/


/*locals {
print_ip ="http://${aws_instance.firstTerrInstance.public_ip}"

}*/

