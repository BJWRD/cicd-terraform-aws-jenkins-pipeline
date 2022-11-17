project_name = [
  "vault"
]

environment = [
  "prod"
]

vpc_cidr = "10.0.0.0/16"

az_public_subnet = {
  "eu-west-2a" : "10.0.0.0/24",
  "eu-west-2b" : "10.0.1.0/24",
  "eu-west-2c" : "10.0.2.0/24"
}

availability_zones = [
  "eu-west-2a",
  "eu-west-2b",
  "eu-west-2c"
]

destination_cidr_block = [
  "0.0.0.0/0"
]

subnet_id = [
  "aws_subnet.public_subnet.id"
]

aws_subnet_public_subnet = [
  "aws_subnet.public_subnet.id"
]
