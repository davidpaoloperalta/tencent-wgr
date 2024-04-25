// instantiate instance types
data "tencentcloud_instance_types" "instance_types" {
  filter {
    name   = "instance-family"
    values = ["S1", "S2", "S3", "S4", "S5"]
  }

  cpu_core_count   = 2
  exclude_sold_out = true
}

// gl-fe
resource "tencentcloud_instance" "cvm_gl_fe" {
  count             = var.env_name == "prod" ? 1 : 0
  instance_name     = "${var.env_name}-${var.project}-gl-fe"
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  image_id          = var.gl_fe_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  project_id        = tencentcloud_project.project.id
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.priv_a_subnet.id
  orderly_security_groups = [tencentcloud_security_group.cvm_security_group.id]

}

// bo-fe
resource "tencentcloud_instance" "cvm_bo_fe" {
  count             = var.env_name == "prod" ? 1 : 0
  instance_name     = "${var.env_name}-${var.project}-bo-fe"
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  image_id          = var.bo_fe_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  project_id        = tencentcloud_project.project.id
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.priv_a_subnet.id
  orderly_security_groups = [tencentcloud_security_group.cvm_security_group.id]

}


// gl-be
resource "tencentcloud_instance" "cvm_gl_be" {
  instance_name     = "${var.env_name}-${var.project}-gl-be"
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  image_id          = var.gl_be_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  project_id        = tencentcloud_project.project.id
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.priv_a_subnet.id
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

// Bo-Be
resource "tencentcloud_instance" "cvm_bo_be" {
  instance_name     = "${var.env_name}-${var.project}-bo-be"
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  image_id          = var.bo_be_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  project_id        = tencentcloud_project.project.id
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.priv_a_subnet.id
  orderly_security_groups = [tencentcloud_security_group.cvm_security_group.id]

}

// job-proc
resource "tencentcloud_instance" "cvm_job_proc" {
  instance_name     = "${var.env_name}-${var.project}-jp"
  availability_zone = data.tencentcloud_availability_zones.zones.zones.0.name
  image_id          = var.job_proc_image
  instance_type     = data.tencentcloud_instance_types.instance_types.instance_types.1.instance_type
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 100
  project_id        = tencentcloud_project.project.id
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.priv_a_subnet.id
  orderly_security_groups = [tencentcloud_security_group.cvm_security_group.id]

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