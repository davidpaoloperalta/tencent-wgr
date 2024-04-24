// instantiate instance types
data "tencentcloud_instance_types" "instance_types" {
  filter {
    name   = "instance-family"
    values = ["S1", "S2", "S3", "S4", "S5"]
  }

  cpu_core_count   = 4
  exclude_sold_out = true
}

// Bo-Fe
resource "tencentcloud_instance" "cvm_bo_fe" {
  instance_name     = "${var.env_name}-${var.project}-bo-fe"
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  image_id          = var.bo_fe_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  project_id        = tencentcloud_project.project.id
  vpc_id            = tencentcloud_vpc.app.id
  subnet_id         = tencentcloud_subnet.app.id
  orderly_security_groups = [tencentcloud_security_group.cvm_security_group.id]
/*
  data_disks {
    data_disk_type = "CLOUD_BSSD"
    data_disk_size = 20
    encrypt        = false
  }

  data_disks {
    data_disk_type = "CLOUD_BSSD"
    data_disk_size = 20
    encrypt        = false
  }
*/
}

resource "tencentcloud_security_group" "cvm_security_group" {
  name        = "${var.env_name}-${var.project}-cvm-sg"
  description = "${var.env_name}-${var.project} security group"
}

resource "tencentcloud_security_group_lite_rule" "cvm_security_group_rules" {
  security_group_id = tencentcloud_security_group.cvm_security_group.id

  ingress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#0.0.0.0/0#ALL#ICMP",
    "ACCEPT#10.0.0.0/8#ALL#TCP",
    "ACCEPT#172.16.0.0/12#ALL#TCP",
    "ACCEPT#192.168.0.0/16#ALL#TCP"
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]
}