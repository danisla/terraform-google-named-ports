# Adding named port to existing instance

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/danisla/terraform-google-named-ports&working_dir=examples/basic&page=shell&tutorial=README.md)

This example shows how to add a named port to an existing instance running in a managed instance group.

## Change to the example directory

```
[[ `basename $PWD` != basic ]] && cd examples/basic
```

## Install Terraform

1. Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

```
../terraform-install.sh
```

## Set up the environment

1. Set the project, replace `YOUR_PROJECT` with your project ID:

```
PROJECT=YOUR_PROJECT
```

```
gcloud config set project ${PROJECT}
```

2. Configure the environment for Terraform:

```
[[ $CLOUD_SHELL ]] || gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Run Terraform

```
terraform init
terraform apply
```

## Testing

1. Verify that the name port was added:

```
./test.sh
```

## Cleanup

1. Remove all resources created by terraform:

```
terraform destroy
```
