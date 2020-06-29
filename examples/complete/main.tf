variable "region" {
  default = "us-east-2"
}

provider "aws" {
  region  = var.region
  version = "= 2.68"
}

module "container" {
  source = "../.."

  container_name               = "log_pusher"
  container_memory             = 256
  container_memory_reservation = 128
  container_cpu                = 256
  essential                    = true
}
