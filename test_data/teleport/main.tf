module "teleport" {
  source              = "./../.."
  environment         = var.environment
  backend_subnet_ids  = var.backend_subnet_ids
  frontend_subnet_ids = var.frontend_subnet_ids
  zone_id             = data.aws_route53_zone.this.zone_id
  force_destroy = true

  teams_to_roles = [
    {
      "organization" : "infrahouse",
      "team" : "developers",
      "roles" : ["access", "editor"],
    }
  ]
  github_client_id                 = "Ov23litM1y0qjRrl6ZwA"
  github_client_secret_secret_name = module.teleport_github_app_secret.secret_name
}


# * Go to https://github.com/organizations/infrahouse/settings/applications/3022369
# * Create a new Client secrets
# * Write its value to this value.

module "teleport_github_app_secret" {
  source             = "registry.infrahouse.com/infrahouse/secret/aws"
  version            = "1.0.2"
  secret_description = "Github App Client secret for Teleport"
  secret_name_prefix = "teleport_github_app_secret"
  environment        = var.environment
  writers = [
    local.sso_roles.admin
  ]
  readers = [
    module.teleport.teleport_role_arn,
  ]
}
