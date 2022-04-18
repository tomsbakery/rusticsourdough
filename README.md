# rusticsourdough
## Summary
A small application designed as an AWS Lambda function to serve as the facility which enforces
certain branch protections for newly created GitHub repositories within an organization. Upon
success, it also files an issue to the repository confirming actions taken. It utilizes
[the GitHub REST API](https://docs.github.com/en/rest) to accomplish this functionality, and is
provisioned and deployed using [Terraform](https://www.terraform.io), particularly the excellent
[terraform-aws-lambda](https://github.com/terraform-aws-modules/terraform-aws-lambda) and
[terraform-aws-apigateway-v2](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2)
modules.

## Prerequisites
* The [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
* An AWS account
* The [AWS CLI (2.0+)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  * Your AWS account configured in a profile
* A GitHub account and organization
* A [GitHub personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

## Usage

1. Clone this repository
2. Run `terraform init` to initialize Terraform backend
3. Set your AWS profile name and region, as well as GitHub user name, personal access token, and
organization name in `terraform.tfvars`
4. Run `terraform plan`
5. If the plan looks good, run `terraform apply`
6. Configure the provided `endpoint_url` in the Terraform output as a [GitHub webhook](https://docs.github.com/en/developers/webhooks-and-events/webhooks/about-webhooks)
applicable to your organization. It need only push `Respositories` events

## Possible enhancements
- Support for credential store(s) for secrets
- Authentication to the Lambda function itself