data "aws_ami" "amazon-ami" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "ec2_instance" {
  ami                    = aws_ami.amazon-ami.id
  subnet_id              = aws_subnet.public_subnet_1.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_server_security_group.id]
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo su
                            yum update -y
                            yum install -y httpd
                            mkdir sajath-dir
                            cd sajath-dir
                            wget https://www.free-css.com/assets/files/free-css-templates/download/page296/browny.zip
                            unzip browny.zip
                            cd browny-html-template
                            mv * /var/www/html/
                            cd /var/www/html/
                            systemctl enable httpd
                            systemctl start httpd
                            EOF

  tags = {
    Name = "My-server-instance"
  }
}
