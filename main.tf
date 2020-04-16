/**
 * ## Usage
 *
 * Creates an IAM Role for use by AWS API Gateway to log to CloudWatch Logs.
 *
 * ```hcl
 * module "api_gateway_cloudwatch_role" {
 *   source = "dod-iac/api-gateway-cloudwatch-role/aws"
 *
 *   name = "api-gateway-cloudwatch-role"
 *   tags = {
 *     Automation  = "Terraform"
 *   }
 * }
 *
 * resource "aws_api_gateway_account" "main" {
 *   cloudwatch_role_arn = module.api_gateway_cloudwatch_role.arn
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 is not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "main" {
  name               = var.name
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
  tags               = var.tags
}

data "aws_iam_policy_document" "main" {
  statement {
    sid = "WelcomeLogGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/apigateway/welcome:log-stream:",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
  statement {
    sid = "WelcomeLogStreams"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/apigateway/welcome:log-stream:*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
  statement {
    sid = "LogGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:API-Gateway-Execution-Logs_*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
  statement {
    sid = "LogStreams"
    actions = [
      "logs:DescribeLogStreams",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:GetLogEvents"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:API-Gateway-Execution-Logs_*:log-stream:*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
}

resource "aws_iam_policy" "main" {
  name   = format("%s-policy", var.name)
  path   = "/"
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
