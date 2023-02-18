# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, we will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Deny Resources that don't have an assigned tag [Tagging Policy](tagging-policy.json)

Check assigned policies
```
az policy assignment list
```
Output:
[tagging-policy.png](screenshots/tagging-policy.png)

## **Packer**
Learn your Azure [client_secret, subscription_id and client_id](https://aster.cloud/2019/07/30/how-to-retrieve-subscription-id-resource-group-id-tenant-id-client-id-and-client-secret-in-azure/)

Update the variables in local.env file accordingly. Attention: ARM_SECRET_ID is the secret value in the registered app not the secret ID
```
ARM_CLIENT_ID=
ARM_CLIENT_SECRET=
ARM_SUBSCRIPTION_ID=
ARM_TENANT_ID=
ARM_PROJECT_TAG=udacity-azure-devops-nanodegree-project-1
ARM_RESOURCE_GROUP=Azuredevops
ARM_IMAGE_NAME=project-1

USERNAME=
PASSWORD=
```
Export the local.env file

```
export $(xargs <local.env)
```

Create Azure Credentials 

```
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```


```
packer build server.json
```

### Output
Check the [outputs/packer-build-logs.txt](outputs/packer-build-logs.txt) for the logs of packer build server.json

## **Terraform**
1. Initialize terraform
```
terraform init
```
Since the Udacity Lab session account does not have Create/Delete Resource Group permission we have to use the already created RG and usually it is Azuredevops with location: East US. If not please update the local.env file accordingly.

2. Tell Terraform to write the resource group into its state:
```
terraform import azurerm_resource_group.main /subscriptions/0ee6d06f-69ab-4b3b-9f35-003e1b6eb227/resourceGroups/Azuredevops
```

3. Generate the terraform plan
```
terraform plan -out solution.plan -var-file="default.tfvars"
```

Output:
[outputs/terraform-plan-terminal-output.txt](outputs/terraform-plan-terminal-output.txt)

4. Apply the generatpr terraform plan (solution.plan)

```
terraform apply "solution.plan"
```
Output:
[outputs/terraform-apply-terminal-output.txt](outputs/terraform-apply-terminal-output.txt)