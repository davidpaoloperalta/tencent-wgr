
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

// GL-FE RULE
resource "tencentcloud_clb_listener_rule" "gl_fe_rule" {
  count                      = var.env_name == "prod" ? 1 : 0
  listener_id                = tencentcloud_clb_listener.https_listener.listener_id
  clb_id                     = tencentcloud_clb_instance.internal_clb.id
  domain                     = var.gl_fe_subdomain
  url                        = "/"
  health_check_switch        = true
  health_check_interval_time = 5
  health_check_health_num    = 3
  health_check_unhealth_num  = 3
  health_check_http_code     = 2
  health_check_http_path     = "Default Path"
  health_check_http_domain   = "Default Domain"
  health_check_http_method   = "GET"
  certificate_ssl_mode       = "UNIDIRECTIONAL"
  certificate_id             = var.certificate_id
  scheduler                  = "WRR"
  target_type                = "NODE"
}

resource "tencentcloud_clb_attachment" "gl_fe_rule_attachment" {
  count       = var.env_name == "prod" ? 1 : 0
  clb_id      = tencentcloud_clb_instance.internal_clb.id
  listener_id = tencentcloud_clb_listener.https_listener.listener_id
  rule_id     = tencentcloud_clb_listener_rule.gl_fe_rule[count.index].rule_id

  targets {
    instance_id = tencentcloud_instance.cvm_gl_fe[count.index].id
    port        = 80
    weight      = 10
  }
}

resource "tencentcloud_clb_redirection" "gl_fe_rule_rewrite" {
  count              = var.env_name == "prod" ? 1 : 0
  clb_id             = tencentcloud_clb_instance.internal_clb.id
  target_listener_id = tencentcloud_clb_listener.https_listener.listener_id
  target_rule_id     = tencentcloud_clb_listener_rule.gl_fe_rule[count.index].rule_id
  is_auto_rewrite    = true
}

// BO-FE RULE
resource "tencentcloud_clb_listener_rule" "bo_fe_rule" {
  count                      = var.env_name == "prod" ? 1 : 0
  listener_id                = tencentcloud_clb_listener.https_listener.listener_id
  clb_id                     = tencentcloud_clb_instance.internal_clb.id
  domain                     = var.gl_fe_subdomain
  url                        = "/"
  health_check_switch        = true
  health_check_interval_time = 5
  health_check_health_num    = 3
  health_check_unhealth_num  = 3
  health_check_http_code     = 2
  health_check_http_path     = "/"
  health_check_http_domain   = var.gl_fe_subdomain
  health_check_http_method   = "GET"
  certificate_ssl_mode       = "UNIDIRECTIONAL"
  certificate_id             = var.certificate_id
  scheduler                  = "WRR"
  target_type                = "NODE"
}

resource "tencentcloud_clb_attachment" "bo_fe_rule_attachment" {
  count       = var.env_name == "prod" ? 1 : 0
  clb_id      = tencentcloud_clb_instance.internal_clb.id
  listener_id = tencentcloud_clb_listener.https_listener.listener_id
  rule_id     = tencentcloud_clb_listener_rule.bo_fe_rule[count.index].rule_id

  targets {
    instance_id = tencentcloud_instance.cvm_bo_fe[count.index].id
    port        = 80
    weight      = 10
  }
}

resource "tencentcloud_clb_redirection" "bo_fe_rule_rewrite" {
  count              = var.env_name == "prod" ? 1 : 0
  clb_id             = tencentcloud_clb_instance.internal_clb.id
  target_listener_id = tencentcloud_clb_listener.https_listener.listener_id
  target_rule_id     = tencentcloud_clb_listener_rule.bo_fe_rule[count.index].rule_id
  is_auto_rewrite    = true
}

// GL-BE RULE
resource "tencentcloud_clb_listener_rule" "gl_be_rule" {
  listener_id                = tencentcloud_clb_listener.https_listener.listener_id
  clb_id                     = tencentcloud_clb_instance.internal_clb.id
  domain                     = var.gl_be_subdomain
  url                        = "/"
  health_check_switch        = true
  health_check_interval_time = 5
  health_check_health_num    = 3
  health_check_unhealth_num  = 3
  health_check_http_code     = 2
  health_check_http_path     = "/"
  health_check_http_domain   = var.gl_be_subdomain
  health_check_http_method   = "GET"
  certificate_ssl_mode       = "UNIDIRECTIONAL"
  certificate_id             = var.certificate_id
  scheduler                  = "WRR"
  target_type                = "NODE"
}


resource "tencentcloud_clb_attachment" "gl_be_rule_attachment" {
  clb_id      = tencentcloud_clb_instance.internal_clb.id
  listener_id = tencentcloud_clb_listener.https_listener.listener_id
  rule_id     = tencentcloud_clb_listener_rule.gl_be_rule.rule_id

  targets {
    instance_id = tencentcloud_instance.cvm_gl_be.id
    port        = 80
    weight      = 10
  }
}

resource "tencentcloud_clb_redirection" "gl_be_rule_rewrite" {
  clb_id             = tencentcloud_clb_instance.internal_clb.id
  target_listener_id = tencentcloud_clb_listener.https_listener.listener_id
  target_rule_id     = tencentcloud_clb_listener_rule.gl_be_rule.rule_id
  is_auto_rewrite    = true
}

// BO-BE RULE
resource "tencentcloud_clb_listener_rule" "bo_be_rule" {
  listener_id                = tencentcloud_clb_listener.https_listener.listener_id
  clb_id                     = tencentcloud_clb_instance.internal_clb.id
  domain                     = var.bo_be_subdomain
  url                        = "/"
  health_check_switch        = true
  health_check_interval_time = 5
  health_check_health_num    = 3
  health_check_unhealth_num  = 3
  health_check_http_code     = 2
  health_check_http_path     = "/"
  health_check_http_domain   = var.bo_be_subdomain
  health_check_http_method   = "GET"
  certificate_ssl_mode       = "UNIDIRECTIONAL"
  certificate_id             = var.certificate_id
  scheduler                  = "WRR"
  target_type                = "NODE"
}

resource "tencentcloud_clb_attachment" "bo_be_rule_attachment" {
  clb_id      = tencentcloud_clb_instance.internal_clb.id
  listener_id = tencentcloud_clb_listener.https_listener.listener_id
  rule_id     = tencentcloud_clb_listener_rule.bo_be_rule.rule_id

  targets {
    instance_id = tencentcloud_instance.cvm_bo_be.id
    port        = 80
    weight      = 10
  }
}

resource "tencentcloud_clb_redirection" "bo_be_rule_rewrite" {
  clb_id             = tencentcloud_clb_instance.internal_clb.id
  target_listener_id = tencentcloud_clb_listener.https_listener.listener_id
  target_rule_id     = tencentcloud_clb_listener_rule.bo_be_rule.rule_id
  is_auto_rewrite    = true
}