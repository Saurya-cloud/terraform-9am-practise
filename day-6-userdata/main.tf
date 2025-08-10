provider "aws" {
  
}

resource "aws_instance" "dev" {
    ami =  "ami-084a7d336e816906b"
    instance_type ="t2.nano"
    availability_zone =  "us-east-1a"
    user_data = file("test.sh")
    tags = {
      Name="Dev-1"
    }
 }
    