
resource "tencentcloud_eip" "eip" {
  name = "${var.env_name}-${var.project}-pub-for-nat"
}

resource "tencentcloud_nat_gateway" "natgw" {
  name             = "${var.env_name}-${var.project}-natgw"
  vpc_id           = tencentcloud_vpc.vpc.id
  bandwidth        = 100
  max_concurrent   = 1000000
  assigned_eip_set = [
    tencentcloud_eip.eip.public_ip
  ]
}