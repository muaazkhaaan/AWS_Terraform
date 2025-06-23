# Parameters & Outputs

In this lesson we will build on the previous and add parameters and outputs to our existing Terraform code.

Variables can reduce duplicating strings and allow for the code to be made modular by passing in alternative values.

The Outputs can give us information that can be used elsewhere, like IP addresses or DNS addresses.

Open the `DOA.tf` file and add the following code at the bottom of the file.

    variable "vpc_cidr" {
      type = string
      default = "10.10.0.0/20"
      description = "CIDR block for the VPC"
    }


To reference this new parameter change the following line inside the VPC resource block:

    cidr_block = "10.10.0.0/20"

to:

    cidr_block = var.vpc_cidr


Run the Terraform using the commands in the previous lesson. Noting the resources should have been deployed with no changes (unless you destroyed them already).

Next lets add in an output. For this we will just output the id of the VPC, but as spoken about above anything can be output via this method.

Add the following code to the end of your file.

    output "vpc_id" {
      value = aws_vpc.this.id
      description = "value of the VPC ID"
    }
    
Rerun the apply code.

To view the output the following command can to be run:

`terraform output`

No outputs will be displayed until a `terraform apply` has been run.

![Terraform apply with output](/AWS-Terraform/Images/Lesson3-Output.png)

## Next Steps

Now we have gone through the basics. You will add some additional Variables and Outputs.

Add 2 new variables for the CidrBlock's of the 2 Subnets in your code.

Add a new variable for the `deployed-by` tag attached to each resource.

Reading the [Terraform Variables custom validation rules](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules) document, add in the following constraints to the VPC cidr variable.

- Minimum length: 9
- Maximum length: 18
- Constraint Description: Must be a valid IP CIDR range of the form x.x.x.x/x.

As a stretch goal find a regex for CIDR notation and add that.

For additional outputs. 
Reading the [Outputs section structure](https://developer.hashicorp.com/terraform/language/values/outputs) add an additional output that outputs all subnets ids in a list in a single output.

## Final Steps

Don't forget to spin down the terraform before finishing the lesson.