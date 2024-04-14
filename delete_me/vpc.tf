# DECLARATION OF TENCENT AZ
data "tencentcloud_availability_zones" "zones" {}

# VPC AND SUBNETS
resource "tencentcloud_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  name       = "${var.env_name}-${var.project}-vpc"
}

resource "tencentcloud_subnet" "pub_subnet" {
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  name              = "${var.env_name}-${var.project}-pub-a"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.pub_cidr
  is_multicast      = false
}

resource "tencentcloud_subnet" "priv_a_subnet" {
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  name              = "${var.env_name}-${var.project}-priv-a"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.priv_a_cidr
  is_multicast      = false
}

resource "tencentcloud_subnet" "priv_b_subnet" {
  availability_zone = data.tencentcloud_availability_zones.zones.zones.1.name
  name              = "${var.env_name}-${var.project}-priv-b"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.priv_b_cidr
  is_multicast      = false
}

resource "tencentcloud_subnet" "db_a_subnet" {
  availability_zone = data.tencentcloud_availability_zones.zones.zones.2.name
  name              = "${var.env_name}-${var.project}-db-a"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.db_a_cidr
  is_multicast      = false
}

resource "tencentcloud_subnet" "db_b_subnet" {
  availability_zone = data.tencentcloud_availability_zones.zones.zones.3.name
  name              = "${var.env_name}-${var.project}-db-b"
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.db_b_cidr
  is_multicast      = false
}

# NATGW
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