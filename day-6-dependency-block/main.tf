
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name="Dev-vpc"
    }
    depends_on = [ aws_s3_bucket.name ]# due to this block vpc will be created after s3(explicitly)
   
}
resource "aws_s3_bucket" "name" {
    bucket = "wgehwori"
}
