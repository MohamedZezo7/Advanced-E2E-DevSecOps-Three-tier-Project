resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = "t2.large"
  key_name               = var.key-name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.security-group.id]
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  root_block_device {
    volume_size = 30
  }
  user_data = templatefile("./script.sh", {})

  tags = {
    Name = var.instance-name
  }
}