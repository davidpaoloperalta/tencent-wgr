resource "tencentcloud_cos_bucket" "private_sbucket" {
  bucket = "${var.env_name}-${var.project}-bucket"
  acl    = "private"
}