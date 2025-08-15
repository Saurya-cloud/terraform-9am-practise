resource "aws_instance" "dev" {
    ami = var.ami-id
    instance_type =var.instance_type
    tags = {
        Name="ec2-test"
    }
}