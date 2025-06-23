# S3

Now we have the basics of a VPC, lets add a S3 bucket to the stack that hosts a static page.

First lets create a new file called `s3.tf` and use that for the following lesson.

Try using just [Terraform S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket), [Terraform S3 Bucket Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy), [Terraform S3 Bucket ACL](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) and [Terraform S3 bucket Website Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) to add the required resources to your code.

Add an output that lists the website URL, to aid you in checking if the code is correct.

Make sure you include Tags.

![Output listed in CLI](/AWS-Terraform/Images/Lesson4-Outputs.png)

If correctly deployed when navigating to the URL in your output you will see a 404, this is because we have not uploaded anything to your new S3 bucket.

![404 Not Found in Browser](/AWS-CloudFormation/Images/Lesson4-S3Bucket-Website.png)

If stuck, [S3 static website snippet](https://dev.to/aws-builders/how-to-create-a-simple-static-amazon-s3-website-using-terraform-43hc) has the required code at section 4, but try and complete it without looking here.


## Final Steps

Don't forget to destroy the resources before finishing the lesson.