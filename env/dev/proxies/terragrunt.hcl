include {

  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules//applications/aws-sso/permission_sets"
}

inputs = {
  cost_center = "Development"
}