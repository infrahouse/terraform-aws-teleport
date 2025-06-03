data "aws_iam_policy_document" "TeleportEC2Discovery" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ssm:DescribeInstanceInformation",
      "ssm:GetCommandInvocation",
      "ssm:ListCommandInvocations",
      "ssm:SendCommand"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "TeleportEC2Discovery" {
  name_prefix = "teleport-ec2-discovery-"
  description = "Teleport uses these permissions to discover EC2 instances and install Teleport on them."
  policy = data.aws_iam_policy_document.TeleportEC2Discovery.json
}
