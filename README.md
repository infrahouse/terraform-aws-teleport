# terraform-aws-teleport

A Terraform module which creates Teleport resources on AWS.
The module will deploy a single-node Teleport cluster.
The configured resources are EC2 instances and RDS databases.

## Usage

Create a GitHub OAuth app

See https://goteleport.com/docs/admin-guides/access-controls/sso/github-sso/#step-14-create-a-github-oauth-app

Save a client secret to a secret in AWS Secrets Manager

```hcl
module "teleport_github_app_secret" {
  source             = "registry.infrahouse.com/infrahouse/secret/aws"
  version            = "1.0.1"
  secret_description = "Github App Client secret for Teleport"
  secret_name_prefix = "teleport_github_app_secret"
  environment        = var.environment
  writers = [
    data.aws_iam_role.AWSAdministratorAccess.arn,
  ]
}
```

Create a Teleport cluster. Note, you need to add the instance role as a secret reader.
```hcl
module "teleport" {
  source  = "infrahouse/teleport/aws"
  version = "0.2.3"
  
  backend_subnet_ids  = module.management.subnet_private_ids
  environment         = var.environment
  frontend_subnet_ids = module.management.subnet_public_ids
  zone_id             = module.infrahouse_com.infrahouse_zone_id

  asg_min_size = 1
  asg_max_size = 1

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

module "teleport_github_app_secret" {
  source             = "registry.infrahouse.com/infrahouse/secret/aws"
  version            = "1.0.1"
  secret_description = "Github App Client secret for Teleport"
  secret_name_prefix = "teleport_github_app_secret"
  environment        = var.environment
  writers = [
    data.aws_iam_role.AWSAdministratorAccess.arn,
  ]
  readers = [
    module.teleport.teleport_role_arn,
  ]
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.11 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.11 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instance_profile"></a> [instance\_profile](#module\_instance\_profile) | registry.infrahouse.com/infrahouse/instance-profile/aws | 1.8.1 |
| <a name="module_userdata"></a> [userdata](#module\_userdata) | registry.infrahouse.com/infrahouse/cloud-init/aws | 1.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_alb.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.redirect_to_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener_rule.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_autoscaling_group.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_dynamodb_table.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.RDSDiscovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.TeleportEC2Discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.TeleportIdentitySecurity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_key_pair.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_template.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb_listener.ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.teleport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_document.TeleportDiscoveryInstaller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [random_string.profile-suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.teleport](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu_pro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.RDSDiscovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.TeleportEC2Discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.TeleportIdentitySecurity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_subnet_ids"></a> [backend\_subnet\_ids](#input\_backend\_subnet\_ids) | Subnets to use for the Teleport server | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of environment. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow deleting data from S3 bucket and DynamoDB table. | `bool` | `false` | no |
| <a name="input_frontend_subnet_ids"></a> [frontend\_subnet\_ids](#input\_frontend\_subnet\_ids) | Subnets to use for the Teleport load balancer | `list(string)` | n/a | yes |
| <a name="input_github_client_id"></a> [github\_client\_id](#input\_github\_client\_id) | GitHub OAuth app client ID. See https://goteleport.com/docs/admin-guides/access-controls/sso/github-sso/#step-14-create-a-github-oauth-app | `string` | n/a | yes |
| <a name="input_github_client_secret_secret_name"></a> [github\_client\_secret\_secret\_name](#input\_github\_client\_secret\_secret\_name) | n/a | `string` | `"A secretsmanager secret containing the GitHub OAuth app client secret. See https://goteleport.com/docs/admin-guides/access-controls/sso/github-sso/#step-14-create-a-github-oauth-app"` | no |
| <a name="input_on_demand_base_capacity"></a> [on\_demand\_base\_capacity](#input\_on\_demand\_base\_capacity) | If specified, the ASG will request spot instances and this will be the minimal number of on-demand instances. | `number` | `null` | no |
| <a name="input_puppet_custom_facts"></a> [puppet\_custom\_facts](#input\_puppet\_custom\_facts) | A map of custom puppet facts | `any` | `{}` | no |
| <a name="input_puppet_debug_logging"></a> [puppet\_debug\_logging](#input\_puppet\_debug\_logging) | Enable debug logging if true. | `bool` | `false` | no |
| <a name="input_puppet_environmentpath"></a> [puppet\_environmentpath](#input\_puppet\_environmentpath) | A path for directory environments. | `string` | `"{root_directory}/environments"` | no |
| <a name="input_puppet_hiera_config_path"></a> [puppet\_hiera\_config\_path](#input\_puppet\_hiera\_config\_path) | Path to hiera configuration file. | `string` | `"{root_directory}/environments/{environment}/hiera.yaml"` | no |
| <a name="input_puppet_manifest"></a> [puppet\_manifest](#input\_puppet\_manifest) | Path to puppet manifest. By default ih-puppet will apply {root\_directory}/environments/{environment}/manifests/site.pp. | `string` | `null` | no |
| <a name="input_puppet_module_path"></a> [puppet\_module\_path](#input\_puppet\_module\_path) | Path to common puppet modules. | `string` | `"{root_directory}/environments/{environment}/modules:{root_directory}/modules"` | no |
| <a name="input_puppet_root_directory"></a> [puppet\_root\_directory](#input\_puppet\_root\_directory) | Path where the puppet code is hosted. | `string` | `"/opt/puppet-code"` | no |
| <a name="input_teams_to_roles"></a> [teams\_to\_roles](#input\_teams\_to\_roles) | List of GitHub teams and associated Teleport roles | <pre>list(<br/>    object(<br/>      {<br/>        organization = string<br/>        team         = string<br/>        roles        = list(string)<br/>      }<br/>    )<br/>  )</pre> | `[]` | no |
| <a name="input_ubuntu_codename"></a> [ubuntu\_codename](#input\_ubuntu\_codename) | Ubuntu version to use for the Teleport server | `string` | `"noble"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 zone ID to use for the Teleport server | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_teleport_role_arn"></a> [teleport\_role\_arn](#output\_teleport\_role\_arn) | IAM role ARN of a Teleport instance |
