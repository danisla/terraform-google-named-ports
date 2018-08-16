# Adding named port to existing instance

This example shows how to add a named port to an existing instance running in a managed instance group.

## Set up the environment

```
gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Run Terraform

```
terraform init
terraform plan
terraform apply
```

## Testing

Verify that the name port was added:

```
./test.sh
```

## Cleanup

```
terraform destroy
```