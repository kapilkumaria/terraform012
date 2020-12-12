#provider "aws" {
#    region = "ca-central-1"
#}



resource "aws_eip" "eip" {
   
   tags = {
     Name = "kapil_nat_eip"
   }
}


output "EIP_ID" {
   value = aws_eip.eip.id
}
    
