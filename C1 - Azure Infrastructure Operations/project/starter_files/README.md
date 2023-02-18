# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
**Packer**
1. [Find client_secret, subscription_id and client_id](https://aster.cloud/2019/07/30/how-to-retrieve-subscription-id-resource-group-id-tenant-id-client-id-and-client-secret-in-azure/)

Subscription ID: a9ab978b-a5d4-42b1-a453-fe2690ceb40f
Tenant ID: f958e84a-92b8-439f-a62d-4f45996b6d07
Client ID: 1ab0adcd-cd33-4f22-ac75-40695a82528b
Secret Value: b1J8Q~3FjDkiOvtzVvEi~Xbnsg6x2NzDpEWyMcYz
Secret ID: dc6c69ec-7072-4cae-91bf-05043d98d4b6

Create Azure Credentials 

```
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
```

Fill ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID variables to be used in server.json
```
export $(xargs <local.env)
```

```
packer build  -var 'client_secret=XXX' -var 'subscription_id=XXX' -var 'client_id=XXX'  server.json
```
2. Generate the terraform plan. Optionally, create tfvars file to override the default values.


```
terraform import azurerm_resource_group.main /subscriptions/0ee6d06f-69ab-4b3b-9f35-003e1b6eb227/resourceGroups/Azuredevops
```
Output:

```
uena034@Erdems-MBP starter_files % terraform import azurerm_resource_group.main /subscriptions/0ee6d06f-69ab-4b3b-9f35-003e1b6eb227/resourceGroups/Azuredevops
azurerm_resource_group.main: Importing from ID "/subscriptions/0ee6d06f-69ab-4b3b-9f35-003e1b6eb227/resourceGroups/Azuredevops"...
azurerm_resource_group.main: Import prepared!
  Prepared azurerm_resource_group for import
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/0ee6d06f-69ab-4b3b-9f35-003e1b6eb227/resourceGroups/Azuredevops]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

```
terraform plan -out solution.plan -var-file="default.tfvars"
```
3. Apply the generated plan
```
terraform apply "solution.plan"
```

### Output
Paste terminal output here

