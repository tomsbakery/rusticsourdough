# rusticsourdough
## Summary
This is a small application designed to be deployed as an AWS Lambda function to enforce certain branch protections for newly created GitHub repositories, e.g. within an organization.

It could easily be adapted to enforce those same branch protections on already-existing repositories.

Upon success, it also files an issue to the repository confirming actions taken.

It primarily utilizes [the GitHub REST API](https://docs.github.com/en/rest) to accomplish this functionality.

## Deployment procedure
- [Create an AWS Lamba function](https://docs.aws.amazon.com/lambda/latest/dg/getting-started-create-function.html#gettingstarted-zip-function)
  - For "Runtime", select Python 3.9
- [Create a layer with dependencies.zip](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html#configuration-layers-create)
  - There is additional discussion on this page on how to generate language-specific library dependencies, although a dependencies.zip containing the requisite Python libraries is provided in this repository as a convenience
- [Add the layer to the function you created](https://docs.aws.amazon.com/lambda/latest/dg/invocation-layers.html#invocation-layers-using)
- Modify the source code of this application to reflect relevant values for your GitHub organization/owner, user name, and [GitHub authentication token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- Insert source code into the AWS Lambda function
  - That is, in the actual console, paste it into `your-function-name/lambda_function.py`
- Deploy the function
- [Add an HTTP API endpoint to your Lamba function](https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html#apigateway-add)
- Finally, use the publicly accessible HTTP API endpoint URL to create and configure an appropriate [GitHub webhook](https://docs.github.com/en/developers/webhooks-and-events/webhooks/about-webhooks)
  - It should point to the HTTP API endpoint you created for your Lambda function
  - It should only push Repositories events

## Needed improvements
- The user name, token information, etc, should be stored environmentally and/or within a secrets store
- The deployment procedure could be wrapped inside a Terraform (or similar) provisioning scheme