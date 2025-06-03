# The Action list is taken from
# https://goteleport.com/docs/admin-guides/teleport-policy/integrations/aws-sync/#step-22-set-up-access-graph-aws-sync
data "aws_iam_policy_document" "TeleportIdentitySecurity" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeImages",
      "ec2:DescribeTags",
      "ec2:DescribeSnapshots",
      "ec2:DescribeKeyPairs",

      "eks:ListClusters",
      "eks:DescribeCluster",
      "eks:ListAccessEntries",
      "eks:ListAccessPolicies",
      "eks:ListAssociatedAccessPolicies",
      "eks:DescribeAccessEntry",

      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:ListTagsForResource",
      "rds:DescribeDBProxies",

      "dynamodb:ListTables",
      "dynamodb:DescribeTable",

      "redshift:DescribeClusters",
      "redshift:Describe*",

      "s3:ListAllMyBuckets",
      "s3:GetBucketPolicy",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketAcl",

      "iam:ListUsers",
      "iam:GetUser",
      "iam:ListRoles",
      "iam:ListGroups",
      "iam:ListPolicies",
      "iam:ListGroupsForUser",
      "iam:ListInstanceProfiles",
      "iam:ListUserPolicies",
      "iam:GetUserPolicy",
      "iam:ListAttachedUserPolicies",
      "iam:ListGroupPolicies",
      "iam:GetGroupPolicy",
      "iam:ListAttachedGroupPolicies",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:GetRolePolicy",
      "iam:ListSAMLProviders",
      "iam:GetSAMLProvider",
      "iam:ListOpenIDConnectProviders",
      "iam:GetOpenIDConnectProvider"    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "TeleportIdentitySecurity" {
  name_prefix = "teleport-identity-security-"
  description = "The policy is designed with a set of read-only actions, enabling Teleport to access and retrieve information from resources within your AWS Account."
  policy = data.aws_iam_policy_document.TeleportIdentitySecurity.json
}
