## Usage

Creates an IAM Role for use by AWS API Gateway to log to CloudWatch Logs.

```hcl
module "api_gateway_cloudwatch_role" {
  source = "dod-iac/api-gateway-cloudwatch-role/aws"

  name = "api-gateway-cloudwatch-role"
  tags = {
    Automation  = "Terraform"
  }
}

resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = module.api_gateway_cloudwatch_role.arn
}
```

## Terraform Version

Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 is not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.55.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the AWS IAM Role. | `string` | `"api-gateway-cloudwatch-role"` | no |
| tags | Tags applied to the AWS IAM Role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) of the AWS IAM Role. |
| name | The name of the AWS IAM Role. |

