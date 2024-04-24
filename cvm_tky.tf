data "tencentcloud_availability_zones" "tky_zones" {
  provider = tencentcloud.tky
}

// Bridge
resource "tencentcloud_instance" "cvm_bridge" {
  provider = tencentcloud.tky
  instance_name     = "${var.env_name}-${var.project}-bridge"
  availability_zone = data.tencentcloud_availability_zones.tky_zones.zones.0.name
  image_id          = var.bridge_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  internet_max_bandwidth_out = 100
  project_id        = tencentcloud_project.project.id
  orderly_security_groups = [tencentcloud_security_group.cvm_security_group_tky.id]

}

resource "tencentcloud_eip" "tky_eip" {
  provider = tencentcloud.tky
  name = "${var.env_name}-${var.project}-pub-for-bridge"
  internet_max_bandwidth_out = 100
}

resource "tencentcloud_eip_association" "tky_eip_assoc" {
  provider = tencentcloud.tky
  eip_id      = tencentcloud_eip.tky_eip.id
  instance_id = tencentcloud_instance.cvm_bridge.id
}

resource "tencentcloud_security_group" "cvm_security_group_tky" {
  provider = tencentcloud.tky
  name        = "${var.env_name}-${var.project}-cvm-sg"
  description = "${var.env_name}-${var.project} security group"
}

resource "tencentcloud_security_group_lite_rule" "cvm_security_group_rules_tky" {
  provider = tencentcloud.tky
  security_group_id = tencentcloud_security_group.cvm_security_group_tky.id

  ingress = [
    "ACCEPT#0.0.0.0/0#443#TCP",
    "ACCEPT#10.0.0.0/8#ALL#TCP",
    "ACCEPT#172.16.0.0/12#ALL#TCP",
    "ACCEPT#192.168.0.0/16#ALL#TCP"
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]
}