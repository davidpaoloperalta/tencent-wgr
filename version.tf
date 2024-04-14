terraform {
  required_version = ">= 1.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
    }
  }

  backend "cos" {
    region = var.region
    bucket = "dynamic_env-${var.project}-state-${var.bucket_string}"
    prefix = "terraform/state"
  }

}

provider "tencentcloud" {
    region = var.region
}
