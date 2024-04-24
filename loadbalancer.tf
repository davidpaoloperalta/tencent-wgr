
# EIP for LB ------------------------------------------------------
resource "tencentcloud_eip" "lb_eip" {
  name                 = "${var.env_name}-${var.project}-pub-for-lb"
  internet_max_bandwidth_out = 100
  type                 = "EIP"
}

resource "tencentcloud_eip_association" "lb_eip_association" {
  eip_id      = tencentcloud_eip.lb_eip.id
  instance_id = tencentcloud_clb_instance.internal_clb.id
}

# LB ------------------------------------------------------------
resource "tencentcloud_clb_instance" "internal_clb" {
  network_type = "INTERNAL"
  clb_name     = "${var.env_name}-${var.project}-priv-lb"
  project_id   = 0
  vpc_id       = tencentcloud_vpc.vpc.id
  subnet_id    = tencentcloud_subnet.priv_a_subnet.id
}

resource "tencentcloud_clb_listener" "http_listener" {
  clb_id        = tencentcloud_clb_instance.internal_clb.id
  listener_name = "${var.env_name}-${var.project}-http-listner"
  port          = 80
  protocol      = "HTTP"
}

resource "tencentcloud_clb_listener" "https_listener" {
  clb_id               = tencentcloud_clb_instance.internal_clb.id
  listener_name        = "${var.env_name}-${var.project}-https-listner"
  port                 = "443"
  protocol             = "HTTPS"
  certificate_ssl_mode = "UNIDIRECTIONAL"
  certificate_id       = var.certificate_id
  sni_switch           = true
}
