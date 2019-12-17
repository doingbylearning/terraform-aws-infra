include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/mburger/vpc"
}

inputs = {
  cidr                   = "10.200.0.0/16"
  private_subnet_cidr    = ["10.200.1.0/24", "10.200.2.0/24"]
  public_subnet_cidr     = ["10.200.10.0/24", "10.200.11.0/24"]
}
