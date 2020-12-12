provider "aws" {
    region = "ca-central-1"
}


#module "vpc" {
#   source = "../vpc"
#}


variable "bastioningressrules" {
    type = list(number)
    default = [22]
}


variable "bastionegressrules" {
    type = list(number)
    default = [22]
}

#variable "webingressrules" {
#    type = tuple ([string, number])
#    default = ["aws_security_group.bastionsg.id", 80]
#}

#variable "webegressrules" {
#    type = tuple ([string, number])
#    default = ["aws_security_group.bastionsg.id", 80]
#}


resource "aws_security_group" "bastionsg" {
    name = "bastionsg"
    description = "Security group for bastion server"
    vpc_id = aws_vpc.terraformvpc.id

    dynamic "ingress" {
      iterator = port
      for_each = var.bastioningressrules
      content {
       from_port = port.value
       to_port = port.value
       protocol = "TCP"
       cidr_blocks = ["66.222.146.176/32"]
      }
    }
      dynamic "egress" {
      iterator = port
      for_each = var.bastionegressrules
      content {
       to_port = port.value
       from_port = port.value
       protocol = "TCP"
       cidr_blocks = ["66.222.146.176/32"]
      }
    }

  tags = {
    Name = "kapil_bastion_sg"
  }

}      
        

resource "aws_security_group" "websg" {
    name = "websg"
    description = "security group for web servers"
    vpc_id = aws_vpc.vpc.VPC_ID

    ingress {
      description = "Allow SSH connection from bastion server only"
      from_port = 22
      to_port = 22
      protocol = "TCP"
      security_groups = [aws_security_group.bastionsg.id]
    }

    ingress {
      description = "Allow HTTP traffic from application LB only"
      from_port = 80
      to_port = 80
      protocol = "TCP"
      security_groups = [aws_security_group.albsg.id]
    }

    tags = {
      Name = "kapil_websg"
    }
}


resource "aws_security_group" "dbsg" {
    name = "dbsg"
    description = "security group for database servers"
    vpc_id = aws_vpc.vpc.VPC_ID

    ingress {
      description = "Allow SSH connection from bastion server only"
      from_port = 22
      to_port = 22
      protocol = "TCP"
      security_groups = [aws_security_group.bastionsg.id]
    }

    ingress {
      description = "Allow HTTP traffic from web servers only"
      from_port = 80
      to_port = 80
      protocol = "TCP"
      security_groups = [aws_security_group.websg.id]
    }

    tags = {
      Name = "kapil_dbsg"
    }
}


resource "aws_security_group" "albsg" {
    name = "albsg"
    description = "security group for application load balancer"
    vpc_id = aws_vpc.vpc.VPC_ID

    ingress {
      description = "Allow HTTP traffic from internet"
      from_port = 80
      to_port = 80
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "kapil_albsg"
    }
}






output "BASTION_SG_ID" {
     value = aws_security_group.bastionsg.id
}

output "WEB_SG_ID" {
     value = aws_security_group.websg.id
}


output "DB_SG_ID" {
     value = aws_security_group.dbsg.id
}

output "ALB_SG_ID" {
     value = aws_security_group.albsg.id
}



