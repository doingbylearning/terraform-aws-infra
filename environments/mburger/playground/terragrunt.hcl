terraform {
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = [
      "-lock-timeout=60m"
    ]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket = "mburger-playground-eu-central-1"
    key     = format("%s/terraform.tfstate", path_relative_to_include())
    region  = "eu-central-1"
    encrypt = true

    dynamodb_table = "mburger-playground-eu-central-1"
  }
}

inputs = {
  name                   = "mburger-playground"
  region                 = "eu-central-1"
  availability_zones     = ["eu-central-1a", "eu-central-1b"]
}
