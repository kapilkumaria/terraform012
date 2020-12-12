provider "aws" {
    region = "ca-central-1"
}



module "eip" {
   source = "./eip"
}

module "web" {
   source = "./web"
}

module "db" {
    source = "./db"
}



resource "aws_vpc" "terraformvpc" {
    cidr_block = "192.168.0.0/26"
 
    tags = {
       Name = "kapilterravpc"   
    }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.terraformvpc.id

    tags = {
      Name = "kapil_igw"
    }
}


resource "aws_nat_gateway" "nat" {
    subnet_id = aws_subnet.public1a.id
    allocation_id = module.eip.EIP_ID

    tags = {
      Name = "kapil_nat"
    }
}



resource "aws_subnet" "public1a" {
    vpc_id = aws_vpc.terraformvpc.id 
    cidr_block = "192.168.0.0/28"
   
    tags = {
      Name = "kapil_public_1a"
    }
}



resource "aws_subnet" "public1b" {
   vpc_id = aws_vpc.terraformvpc.id
   cidr_block = "192.168.0.16/28"

   tags = {
     Name = "kapil_public_1b"
   }
}


resource "aws_subnet" "private1a" {
   vpc_id = aws_vpc.terraformvpc.id
   cidr_block = "192.168.0.32/28"
 
   tags = {
     Name = "kapil_private_1a"
   }
} 


resource "aws_subnet" "private1b" {
   vpc_id = aws_vpc.terraformvpc.id
   cidr_block = "192.168.0.48/28"
 
   tags = {
     Name = "kapil_private_1b"
   }
}


resource "aws_route_table" "publicrt" {
   vpc_id = aws_vpc.terraformvpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
   }

   tags = {
     Name = "kapil_public_RT"
   }
}



resource "aws_route_table" "privatert" {
   vpc_id = aws_vpc.terraformvpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.nat.id
   }

   tags = {
     Name = "kapil_private_RT"
   }
}




resource "aws_route_table_association" "rta1" {
   subnet_id = aws_subnet.public1a.id
   route_table_id = aws_route_table.publicrt.id
}
   

resource "aws_route_table_association" "rta2" {
   subnet_id = aws_subnet.public1b.id
   route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "rta3" {
   subnet_id = aws_subnet.private1a.id
   route_table_id = aws_route_table.privatert.id
}

resource "aws_route_table_association" "rta4" {
   subnet_id = aws_subnet.private1b.id
   route_table_id = aws_route_table.privatert.id
}





output "VPC_ID" {
     value = aws_vpc.terraformvpc.id
}

output "IGW_ID" {
     value = aws_internet_gateway.igw.id
}



output "SUBNET_PUBLIC_1a" {
     value = aws_subnet.public1a.id
} 

output "SUBNET_PUBLIC_1b" {
     value = aws_subnet.public1b.id
}


output "SUBNET_PRIVATE_1a" {
     value = aws_subnet.private1a.id
}

output "SUBNET_PRIVATE_1b" {
     value = aws_subnet.private1b.id
}

output "PUBLIC_RT_ID" {
    value = aws_route_table.publicrt.id
}

output "PRIVATE_RT_ID" {
   value = aws_route_table.privatert.id
}

output "EIP_ID" {
   value = [module.eip.EIP_ID]
}

output "NAT_ID" {
   value = aws_nat_gateway.nat.id
}


output "INSTANCE_WEB_1a_ID" {
   value = module.web.EC2_WEB_1a_ID
}

output "INSTANCE_WEB_1b_ID" {
   value = module.web.EC2_WEB_1b_ID
}
