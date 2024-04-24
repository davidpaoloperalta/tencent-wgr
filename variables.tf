variable "vpc_cidr" {
  default = "0.0.0.0/0"
}

variable "pub_cidr" {
  default = "0.0.0.0/0"
}

variable "priv_a_cidr" {
  default = "0.0.0.0/0"
}

variable "priv_b_cidr" {
  default = "0.0.0.0/0"
}

variable "db_a_cidr" {
  default = "0.0.0.0/0"
}

variable "db_b_cidr" {
  default = "0.0.0.0/0"
}

variable "region" {
  default = "ap-singapore"
}

variable "bridge_region" {
  default = "ap-tokyo"
}

variable "project" {
  default = "undefined_proj"
}

variable "project_id" {
  default = "0"
}

variable "env_name" {
  default = "undefined_env"
}

variable "certificate_id" {
  default = "undefined_cert"
}

/*
variable "db_memory" {
  default = "0"
}

variable "db_disk" {
  default = "0"
}

variable "db_version" {
  default = "0"
}
*/

variable "bo_fe_image" {
  default = "null"
}

variable "bo_be_image" {
  default = "null"
}

variable "job_proc_image" {
  default = "null"
}

variable "bridge_image" {
  default = "null"
}

