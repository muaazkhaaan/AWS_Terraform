# Lambda / IAM

For the next lesson we are going to deploy a lambda via Terraform. The files that the lambda will contain are located at [lambda_function.py](/AWS-Terraform/Assets/lambda_function.py) the code itself simple returns the area if the length and width are sent. The code is not so important but knowing it is a python is.

Lets start by looking at the [Terraform Lambda Function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) documentation and start adding the base for the resources. Move the python code into your base folder. `C:\dev\projects\AnswerDigital\DOA-Terraform\lambda_function.py`


For the `filename:` chunk use the following.

- Filename: `${path.module}/lambda_function.py`
- Runtime: `python3.13`
- Function Name: `python_area`
- Handler: `index.lambda_handler`
- Role: `aws_iam_role.lambda`

Make sure to add Tags.

As you can see in the above, you are referencing a `aws_iam_role.lambda`. In the code this does not currently exist so that will be the next step. AWS IAM roles are out of spec for these lessons so the code required is below. But a good link to read is [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html).

    resource "aws_iam_role" "lambda" {
      name        = "LambdaRole"
      description = "Allows Lambda functions to call AWS services on your behalf."

      assume_role_policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Principal" : {
              "Service" : "lambda.amazonaws.com"
            },
            "Action" : "sts:AssumeRole"
          }
        ]
      })
    }

Apply your Terraform.

To test your newly deployed lambda open the AWS Ui, login to the Answer Academy account and navigate to [lambda functions](https://eu-west-2.console.aws.amazon.com/lambda/home?region=eu-west-2#/functions).

Open the newly created Lambda. Hit `Test` and replace the contents of `Event Json` with the following.

    {
      "length": 20,
      "width": 100
    }

Hit `Test` and a new green box will appear, titled `Executing function: succeeded`, expanding this will display the output of the lambda.

![Executing function succeeded](/AWS-Terraform/Images/Lesson5-ExecutedSucceeded.png)


## Final Steps

Don't forget to spin down the stack before finishing the lesson.
