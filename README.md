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
with, at minimum, full `repo` scope for access permissions

## Usage
1. Clone this repository
2. Run `terraform init` to initialize Terraform backend
3. Create a `terraform.tfvars` file which looks like the following with your values substituted:
```
aws_region      = "ca-central-1"
aws_profile     = "personal-aws"
gh_org_name     = "tomsbakery"
gh_user_name    = "tom_the_baker"
gh_access_token = "access_token"
```
4. Run `terraform plan`
5. If the plan looks good, run `terraform apply`
6. Configure the provided `endpoint_url` in the Terraform output as a [GitHub webhook](https://docs.github.com/en/developers/webhooks-and-events/webhooks/about-webhooks)
applicable to your organization. It need only push `Respositories` events

## Notes
It may not be obvious how certain tunables are making their way into the `fresh_bread.py` Lambda
worker process. The GitHub organization name, user name, and personal access token defined in the
`terraform.tfvars` file are referenced in `main.tf` under the `environment_variables` data structure
of the `lambda_function` module. During provisioning, the Terraform module translates these into
[AWS Lambda environment variables](https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html),
which can then be accessed from, for example, a Python application using the common `os.environ`
procedure, which is the approach that you see in `fresh_bread.py`

## Possible enhancements
- Support for credential store(s) for secrets
- Authentication to the Lambda function itself