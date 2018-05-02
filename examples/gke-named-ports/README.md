# Kubernetes Engine with Named Ports

This example shows how to do add named ports to a GKE cluster for the purpose of using an external L7 HTTPS Load Balancer.

**Figure 1.** *diagram of Google Cloud resources*

![architecture diagram](./diagram.png)

## Set up the environment

```
gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Create the `terraform.tfvars` file

```
cat > terraform.tfvars <<EOF
gke_username = "admin"
gke_password = "$(openssl rand -base64 16)"
EOF
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