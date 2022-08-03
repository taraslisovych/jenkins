provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "amazon_ubuntu_2004" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["*ubuntu-focal-20.04-amd64-server-*"]
  }
}

variable "env" {
  default = "Jenkins"
}

module "my_vpc" {
  source                = "git::https://git@github.com/taraslisovych/terraform-modules.git//aws_network"
  private_network_count = 1
  public_network_count  = 1
  env                   = var.env
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_ubuntu_2004.id
  instance_type          = "t2.micro"
  subnet_id              = module.my_vpc.ter_public_net_ids[0]
  vpc_security_group_ids = [module.my_vpc.ter_def_sg]
  key_name               = module.my_vpc.ter_rsa_key_name

  tags = {
    "Name" = "${var.env} from Pipeline"
  }
}
