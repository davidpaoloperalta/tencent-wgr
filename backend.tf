terraform {
  backend "cos" {
    region = "ap-singapore"
    bucket = "dynamic_env-dynamic_proj-state-1324350682"
  }
}