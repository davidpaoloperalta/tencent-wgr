terraform {
  required_version = ">= 1.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
    }
  }
}

provider "tencentcloud" {
    region = var.region
}

provider "tencentcloudjp" {
  alias  = "tky"
  region = var.bridge_region
}