resource "aws_db_subnet_group" "dev_db_subnet_group" {
  name       = "dev-db-subnet1-group"
  subnet_ids = ["subnet-0186151e9dcd47d9e", "subnet-0569fda89aa67581a"] # Replace with your private subnet IDs
  tags = {
    Name = "dev-db-subnet-group"
  }
}

resource "aws_security_group" "dev_rds_sg" {
  name        = "dev-rds-sg"
  description = "Allow RDS access"
  vpc_id      = "vpc-013ee0948f7fcad29" # Replace with your VPC ID

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restrict to your internal network
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "dev_rds" {
  identifier              = "rds-database"  
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "StrongPassw0rd!"
  skip_final_snapshot     = true
  backup_retention_period = 7
  publicly_accessible     = true

  db_subnet_group_name    = aws_db_subnet_group.dev_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.dev_rds_sg.id]
}

resource "aws_db_instance" "dev_rds_replica" {
  identifier              = "rds-replica"  
  replicate_source_db     = aws_db_instance.dev_rds.arn
  instance_class          = "db.t3.micro"
  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.dev_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.dev_rds_sg.id]
}
