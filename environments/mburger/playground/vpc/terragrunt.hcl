include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/mburger/vpc"
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = [
      "-lock-timeout=60m"
    ]
  }
}

inputs = {
  cidr                   = "10.200.0.0/16"
  name                   = "mburger-playground"
  region                 = "eu-central-1"
}
