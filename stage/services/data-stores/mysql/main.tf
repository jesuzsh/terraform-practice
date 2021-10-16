provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraformp369"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"

  username          = local.db_creds.username
  password          = local.db_creds.password
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "mysql-master-creds-stage"
}

terraform {
  backend "s3" {
    bucket         = "bucketp369-terraform-state"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"

    dynamodb_table = "terraform369p-locks"
    encrypt        = true
  }
}
