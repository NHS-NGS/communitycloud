module "example" {
  source = "../../modules/_example"

  project     = var.project
  environment = var.environment
  component   = var.component
}
