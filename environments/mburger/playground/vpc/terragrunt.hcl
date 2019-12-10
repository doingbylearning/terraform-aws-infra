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
}
