module "ssm_instance_profile" {
  source  = "bayupw/ssm-instance-profile/aws"
  version = "1.1.0"
}

data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
resource "aws_instance" "ec2_instance" {
  key_name                    = "use1"
  iam_instance_profile        = module.ssm_instance_profile.aws_iam_instance_profile
  ami                         = data.aws_ami.ubuntu_server.id
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-044dfba335b22ce90"
  associate_public_ip_address = true

  tags = {
    Name = "Docker test"
  }
}
# resource "aws_instance" "jump_host" {
#   provider = aws.region_2

#   key_name                    = aws_key_pair.ec2_key_region_2.key_name
#   ami                         = data.aws_ami.ubuntu_server.id
#   instance_type               = "t3.micro"
#   subnet_id                   = data.aviatrix_vpc.jump_host_vpc.public_subnets[0].subnet_id
#   vpc_security_group_ids      = [sort(data.aws_security_groups.jump_host_sg.ids)[0]]
#   associate_public_ip_address = true
#   user_data                   = data.template_file.ubuntu_server.template

#   tags = {
#     Name = "jump host"
#   }
# }