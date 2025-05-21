include {
  path = find_in_parent_folders()
}

locals {
  auth0_credentials_filename = get_env("STAGE", "development") == "development" ? "auth0-credentials.sops.yaml" : "auth0-credentials.${get_env("STAGE")}.sops.yaml"
  auth0_credentials          = yamldecode(sops_decrypt_file("${get_terragrunt_dir()}/../../auth0/${local.auth0_credentials_filename}"))

  secrets = yamldecode(sops_decrypt_file("development.sops.yaml"))
}

inputs = merge(local.auth0_credentials, local.secrets)
