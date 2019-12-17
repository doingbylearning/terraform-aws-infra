include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/mburger/atlantis"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  instance_type = "c5.xlarge"
  key_name = "doingbylearning"
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnet_ids
}
