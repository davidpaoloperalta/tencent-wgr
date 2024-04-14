resource "tencentcloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  name       = "${var.env_name}-${var.project}-vpc"
}

/*
resource "tencentcloud_eip" "eip_1" {
  name = "tf_nat_gateway_eip1"
}


resource "tencentcloud_nat_gateway" "example" {
  name             = "tf_example_nat_gateway"
  vpc_id           = tencentcloud_vpc.vpc.id
  bandwidth        = var.bandwidth
  max_concurrent   = var.max_concurrent
  assigned_eip_set = [
    tencentcloud_eip.eip_1.public_ip
  ]
  tags = {
    tf_tag_key = "tf_tag_value"
  }
}
*/