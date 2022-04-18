output "endpoint_url" {
  description = "URL of the API endpoint"

  value = module.api_gateway.apigatewayv2_api_api_endpoint
}