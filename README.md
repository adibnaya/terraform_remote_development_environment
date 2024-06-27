# AWS Deployment with Terraform

This project demonstrates the process of deploying an AWS infrastructure using Terraform. It provides a step-by-step guide on how to set up the necessary prerequisites and deploy the infrastructure.

## Prerequisites

Before getting started, ensure that you have the following prerequisites in place:

1. **Git Clone the Repository**: Clone this repository to your local machine using the following command:

    ```bash
    git clone https://github.com/adibnaya/terraform_remote_development_environment.git
    ```

1. **Install Terraform**: Install Terraform locally on your machine. You can download the latest version of Terraform from the official website: [Terraform Downloads](https://www.terraform.io/downloads.html). Follow the installation instructions specific to your operating system.

1. **AWS IAM Key**: Obtain an AWS IAM key with the necessary permissions to create and manage resources. Make sure you have the access key ID and secret access key ready.

## Getting Started

To deploy the AWS infrastructure using Terraform, follow these steps:

1. **Configure AWS Credentials**: Set up your AWS credentials on your local machine. You can do this by either exporting the credentials as environment variables or by using the AWS CLI. For example:

    ```bash
    export AWS_ACCESS_KEY_ID=your-access-key-id
    export AWS_SECRET_ACCESS_KEY=your-secret-access-key
    ```

    **If you are using VS Code you can use the `AWS toolkit` extension, after installing the extention go to View->Command pallet then search for `AWS: Create Credentials Profile` and modify the `[vscode]` section with the access key and secret**

1. **Review and Modify Configuration**: Review the Terraform configuration files in the project directory. Make any necessary modifications to customize the infrastructure deployment according to your requirements:

    The ingress cider block allows access from anywhere by default, if you want to secure it to allow only your IP modify the ingress `local_ip` in the `terraform.tfvars` file to match your own public IP address, Make sure to add /32 at the end of the cidr block to allow only one address, for example: 17.18.19.20/32

1. **Get your key pair**: Before you can connect to your created environment create a key pair:

    ```bash
    ssh-keygen -t ed25519
    ```

    After creating the key pair you need to update the right `key_name` and path in `terraform.tfvars` file

1. **Plan and Apply**: Generate an execution plan to preview the changes that Terraform will make to your infrastructure. Run the following command:

    ```bash
    terraform init
    ```

    ```bash
    terraform plan
    ```

    If the plan looks good, apply the changes by running:

    ```bash
    terraform apply
    ```

    Confirm the changes by typing `yes` when prompted.

1. **Verify Deployment**: Once the deployment is complete, verify that the AWS resources have been created successfully. You can use the AWS Management Console, AWS CLI, or other tools to check the status of your infrastructure.

1. **SSH connection to the created instance**: Before you can actually connect to your instance you need to know the public IP.
This deployment also contains a provisioner section inside `main.tf` that will automatically add the IP, user and ssh private key location, after you apply the deployment you can install in VS code the `Remote-SSH` extension and connect to the newly created virtual machine and access it's files directly from VS code for remote development environment

    ```bash
    terraform state list
    ```

    Locate the instance name the show it's state:
    ```bash
    terraform state show <instance name>
    ```

    Then look in the properties list for the `Public IP` then you can ssh to your instanceusing the default user `ubuntu` and your private generated key:
    ```bash
    ssh -i ~\.ssh\aws_key ubuntu@<Public IP>
    ```

## Cleanup

To clean up the AWS resources created by Terraform, run the following command:

```bash
terraform destroy
```
