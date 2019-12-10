include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/mburger/vpc"
}

inputs = {
  cidr                   = "10.200.0.0/16"
  name                   = "mburger-playground"
  region                 = "eu-central-1"
  availability_zones     = ["eu-central-1a", "eu-central-1b"]
  private_subnet_cidr    = ["10.200.1.0/24", "10.200.2.0/24"]
  public_subnet_cidr     = ["10.200.10.0/24", "10.200.11.0/24"]
}
