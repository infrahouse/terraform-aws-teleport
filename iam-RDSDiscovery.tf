data "aws_iam_policy_document" "RDSDiscovery" {
  statement {
    actions = [
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "rds-db:connect",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
    ]
    resources = ["*"]

  }
}

resource "aws_iam_policy" "RDSDiscovery" {
  name_prefix = "teleport-RDSDiscovery-"
  description = "Teleport uses these permissions to discover and connect to RDS instances."
  policy      = data.aws_iam_policy_document.RDSDiscovery.json
}
