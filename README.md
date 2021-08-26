# Terraform AWS EC2 Provisioning

This repository holds a Terraform script to easily provision an NGINX instance in Amazon AWS.

---

## Instructions

1. Initialize the working directory:
```
    terraform init
```
2. Update the user-sensible variables located at **terraform.tfvars**. You will need to specify a region, access and secret key for a valid IAM, a valid Key Pair name, and an AMI id.
3. Review the changes that will be queued to the Cloud:
```
    terraform plan
```
4. Create all the necessary resources:
```
    terraform apply
```
5. The output **url** will provide you with the Public IP to connect to the instance.
6. Don't forget to destroy all resources created via:
```
    terraform destroy
```

---

### Design
TBD