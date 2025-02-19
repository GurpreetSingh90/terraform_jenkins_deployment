
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "Jenkins"
  }
  user_data = file("jenkins.sh")
  key_name = "ap-south"
}
