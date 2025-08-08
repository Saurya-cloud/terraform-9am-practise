# creation of vpc
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name="dev-1"
    }
  
}
# creatiion of subnet
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
    Name="dev-publicsubnet"
    }
}
#private subnet
 resource  "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    tags = {
    Name="dev-privatesubnet"
    }
}
# creation IG and attach to vpc
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name="IGT"
    }
  
}
# creation of routetable and edit routes
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
        
    }
    tags = {
      Name="Public-route"
    }
}
 
# create subnet association
# resource "aws_route_table_association" "name" {
#   subnet_id      = aws_subnet.my_subnet.id
#   route_table_id = aws_route_table.my_route_table.id  # ✅ Correct
# }

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

# create sg 
resource "aws_security_group" "allow_tls" {
    name="allow_tls"
    vpc_id = aws_vpc.name.id
    tags = {
      Name="dev-sg"
    }
    ingress {
        description = "TLS from vpc"
        from_port = "22"
        to_port = "22"
        protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        description = "TLS from vpc"
        from_port = "443"
        to_port = "443"
        protocol = "TCP"
       cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        description = "TLS from vpc"
        from_port = "80"
        to_port = "80"
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        description = "TLS from vpc"
        from_port = "0"
        to_port = "0"
        protocol = "-1" #all protocol
       cidr_blocks = ["0.0.0.0/0"]

    }
  
  
}
# create servers
resource "aws_instance" "name" {
    ami = "ami-084a7d336e816906b"
    instance_type = "t2.nano"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    tags = {
      Name="MyEc2"
    }

}
# nat gateway
resource "aws_nat_gateway" "name" {
    connectivity_type = "private"
    subnet_id = aws_subnet.private-subnet.id
    tags = {
      Name="NGT"
    }

}
# creation of private routetable and edit routes
resource "aws_route_table" "private-routetable" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id =aws_nat_gateway.name.id
       
    }
    tags = {

      Name="private-route"
    }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-routetable.id
}
