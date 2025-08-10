resource "aws_instance" "dev" {
    ami =  "ami-084a7d336e816906b"
    instance_type ="t2.nano"
    availability_zone =  "us-east-1a"
    tags = {
      Name="Dev"
    }

    
    lifecycle {
     create_before_destroy = true
    # prevent_destroy = true
    ignore_changes = [ tags, ]
    }

    }