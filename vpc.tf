# DECLARATION OF TENCENT AZ --------------------------------------------------
data "tencentcloud_availability_zones" "zones" {}

# VPC AND SUBNETS ------------------------------------------------------------
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

# NATGW ----------------------------------------------------------------------
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

resource "tencentcloud_route_entry" "rtb_entry_instance" {
  vpc_id         = tencentcloud_vpc.vpc.id
  route_table_id = tencentcloud_vpc.vpc.default_route_table_id
  cidr_block     = "0.0.0.0/0"
  next_type      = "nat_gateway"
  next_hub       = "tencentcloud_nat_gateway.rtb_entry_instance.id"
}