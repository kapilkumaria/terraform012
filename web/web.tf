provider "aws" {
     region = "ca-central-1"
}



#module "vpc" {
#     source = "../vpc"
#}

module "sg" {
     source = "../sg"
}




resource "aws_instance" "web1a" {
      ami = "ami-04bf6dcdc9ab498ca"
      instance_type = "t2.micro"
      subnet_id = aws_subnet.subnet.SUBNET_PUBLIC_1a
      security_groups = [module.sg.BASTION_SG_ID]
      user_data = file("webserver-script.sh")      

      tags = {
        Name = "kapil_webserver_1a"
      }
}


resource "aws_instance" "web1b" {
      ami = "ami-04bf6dcdc9ab498ca"
      instance_type = "t2.micro"

      subnet_id = aws_subnet.subnet.SUBNET_PUBLIC_1b
      security_groups = [module.sg.BASTION_SG_ID]
      user_data = file("webserver-script.sh")

      tags = {
        Name = "kapil_webserver_1b"
      }
}



    
output "EC2_WEB_1a_ID" {
    value = aws_instance.web1a.id
}

output "EC2_WEB_1b_ID" {
    value = aws_instance.web1b.id
}




