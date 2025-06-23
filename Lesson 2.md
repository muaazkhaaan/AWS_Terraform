# Basic VPC

In this lesson we will start off our Terraform project and deploy a basic VPC with 2 Subnets.

Start by creating a new folder that will contain the Terraform project.
For the screenshots these will be contained at `C:\dev\projects\AnswerDigital\DOA-Terraform`

Create a file within this folder called `DOA.tf` and paste in the following

    terraform {
      required_version =">= 1"
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = ">= 6.0"
        }
      }
    }

    provider "aws" {
        region = "eu-west-2"
    }

    resource "aws_vpc" "this" {
      cidr_block = "10.10.0.0/20"
      enable_dns_hostnames = false
      enable_dns_support = true

      tags = {
        Name = "VPC",
        managed-by = "Terraform",
        deployed-by = "<Enter Name Here>"
      }
    }

    resource "aws_subnet" "this" {
      vpc_id = aws_vpc.this.id
      cidr_block = "10.10.10.0/24"
      map_public_ip_on_launch = true

      tags = {
        Name = "Subnet",
        managed-by = "Terraform",
        deployed-by = "<Enter Name Here>"
      }
    }

Open a command window and navigate it to your folder. 

Before we can run the Terraform first we need to initiate the folder and make sure all packages are downloaded. This command is below.

`terraform init --upgrade`

![Successful Init](/AWS-Terraform/Images/Lesson2-Init.png?raw=true)

Next we run a Terraform plan to check what is going to happen. The command to run a Terraform plan is as below.

`terraform plan`

![Successful plan](/AWS-Terraform/Images/Lesson2-Plan.png?raw=true)

And finally to deploy.

`terraform apply`

This will run a plan again and then ask if you want to perform these actions, enter `yes`.

![Successfully deployed](/AWS-Terraform/Images/Lesson2-Deployed.png?raw=true)

You can also go into the Portal and should see a VPC called `VPC`, the details of should look at follows:

![Successfully deployed in Portal](/AWS-Terraform/Images/Lesson2-DeployedPortal.png?raw=true)

## Next steps
Add an additional subnet to your file named `Subnet2` with the CidrBlock of `10.10.11.0/24`

Once added re-run the apply command and check the portal to see the new subnet.

## Final Steps
Most resources once spun up cost money, while the VPC doesn't for the sake of keeping the AWS environment clean we will spin down the resources each time.

The command to delete the Terraform resources is as below.

`terraform destroy`

This, like the apply will show you the changes first and then ask if you want to perform these actions, enter `yes`.

![Successfully deleted](/AWS-Terraform/Images/Lesson2-Deleted.png?raw=true)


## Links
[Terraform AWS VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

[Terraform AWS Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

[CloudFormation Concepts](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)