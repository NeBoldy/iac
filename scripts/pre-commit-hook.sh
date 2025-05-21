#!/bin/sh

if ! command -v terraform &> /dev/null; then
  echo "terraform is required to run this script. Please read the README.md. exiting"
fi

if ! command -v terraform-docs &> /dev/null; then
  echo "terraform-docs is required to run this script. Please read the README.md. exiting"
fi

if ! command -v tfsort &> /dev/null; then
  echo "tfsort is required to run this script. Please read the README.md. exiting"
fi

# Update docs
terraform-docs markdown --output-file README.md --output-mode inject . &> /dev/null
git add README.md

echo "README is updated"

echo "Formatting all tf files"
terraform fmt

echo "Sorting variables.tf file"
tfsort variables.tf

echo "Sorting outputs.tf file"
tfsort outputs.tf
