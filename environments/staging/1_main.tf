provider "aws" {
  shared_config_files      = ["/home/mantas/.aws/config"]
  shared_credentials_files = ["/home/mantas/.aws/credentials"]
  profile                  = "default"
  region                   = "eu-central-1"
}