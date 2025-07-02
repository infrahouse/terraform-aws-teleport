locals {
  sso_roles = {
    admin : tolist(data.aws_iam_roles.sso-admin.arns)[0],
  }

}
