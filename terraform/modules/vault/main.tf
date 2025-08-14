data "http" "hcp_token" {
  url             = "https://auth.idp.hashicorp.com/oauth2/token"
  method          = "POST"
  request_headers = { "Content-Type" = "application/x-www-form-urlencoded" }
  request_body    = "grant_type=client_credentials&client_id=${var.hcp_client_id}&client_secret=${var.hcp_client_secret}&audience=https://api.hashicorp.cloud"
}

locals {
  token_response = jsondecode(data.http.hcp_token.response_body)
  access_token   = local.token_response.access_token
  base_url       = "https://api.cloud.hashicorp.com/secrets/2023-11-28/organizations/${var.hcp_org_id}/projects/${var.hcp_project_id}/apps/${var.hcp_app_name}/secrets"
  secrets = {
    "access_Key" = var.aws_accessKey_nom
    "secret_Key" = var.aws_secretKey_nom
    "ssh_github" = var.githug_ssh_nom
    "harbor_user" = var.harbor_user_nom
    "harbor_pwd"  = var.harbor_pwd_nom

  }
  aws_secret_accesKey_response  = jsondecode(data.http.aws_accessKey_http.response_body)
  aws_secret_secretKey_response = jsondecode(data.http.aws_secretKey_http.response_body)
  ssh_github_response           = jsondecode(data.http.ssh_github_http.response_body)
  harbor_user_response          = jsondecode(data.http.harbor_user_http.response_body)
  harbor_pwd_response           = jsondecode(data.http.harbor_pwd_http.response_body)
  aws_accessKey                 = local.aws_secret_accesKey_response.secret.static_version.value
  aws_secretKey                 = local.aws_secret_secretKey_response.secret.static_version.value
  harbor_user                  = local.harbor_user_response.secret.static_version.value
  harbor_pwd                   = local.harbor_pwd_response.secret.static_version.value
  ssh_github                    = replace(local.ssh_github_response.secret.static_version.value, "\\n", "\n")
}

data "http" "aws_accessKey_http" {
  url    = "${local.base_url}/${local.secrets.access_Key}:open"
  method = "GET"

  request_headers = {
    "Authorization" = "Bearer ${local.access_token}"
    "Content-Type"  = "application/json"
  }
}

data "http" "aws_secretKey_http" {
  url    = "${local.base_url}/${local.secrets.secret_Key}:open"
  method = "GET"

  request_headers = {
    "Authorization" = "Bearer ${local.access_token}"
    "Content-Type"  = "application/json"
  }
}

data "http" "ssh_github_http" {
  url    = "${local.base_url}/${local.secrets.ssh_github}:open"
  method = "GET"

  request_headers = {
    "Authorization" = "Bearer ${local.access_token}"
    "Content-Type"  = "application/json"
  }
}
 data "http" "harbor_user_http" {
  url    = "${local.base_url}/${local.secrets.harbor_user}:open"
  method = "GET"

  request_headers = {
    "Authorization" = "Bearer ${local.access_token}"
    "Content-Type"  = "application/json"
  }
}

data "http" "harbor_pwd_http" {
  url    = "${local.base_url}/${local.secrets.harbor_pwd}:open"
  method = "GET"

  request_headers = {
    "Authorization" = "Bearer ${local.access_token}"
    "Content-Type"  = "application/json"
  }
}