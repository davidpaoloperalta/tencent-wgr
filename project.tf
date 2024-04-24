resource "tencentcloud_project" "project" {
  project_name = "${var.env_name}-${var.project}"
  info         = "${var.env_name} ${var.project}"
}