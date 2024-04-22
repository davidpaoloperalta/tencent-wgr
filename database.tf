resource "tencentcloud_mariadb_instance" "instance" {
  instance_name = "${var.env_name}-${var.project}-db"
  zones      = [data.tencentcloud_availability_zones.zones.zones.2.name]
  node_count = 2
  memory     = var.db_memory
  storage    = var.db_disk
  vpc_id     = tencentcloud_vpc.vpc.id
  subnet_id  = tencentcloud_subnet.db_a_subnet.id
  db_version_id = var.db_version
  security_group_ids = [tencentcloud_security_group.db_security_groups.id]

  init_params {
    param = "character_set_server"
    value = "utf8"
  }

  init_params {
    param = "sync_mode"
    value = "1"
  }

  #dcn_region      = var.region
  #dcn_instance_id = ""
}

resource "tencentcloud_security_group" "db_security_groups" {
  name        = "${var.env_name}-${var.project}-db-sg"
  description = "Database security group"
}

resource "tencentcloud_security_group_lite_rule" "db_security_group_rule" {
  security_group_id = tencentcloud_security_group.db_security_groups.id

  ingress = [
    "ACCEPT#0.0.0.0/0#27989#TCP",
    "ACCEPT#${var.vpc_cidr}#3306#TCP"
  ]

  egress = [
    "DROP#0.0.0.0/0#ALL#ALL",
  ]
}