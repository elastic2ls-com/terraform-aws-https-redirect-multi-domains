# Terraform module for S3 redirects with CloudFront, ACM

This module helps you create a S3 bucket which performs HTTPS redirection. It includes the following:

* S3 bucket
* certificate managed by AWS ACM
* a route53 Zone (may you have to add a NS delegation to your main DNS setup.)
* cloudfront distribution


## Sample Usage
This module requires 3 arguments.
* `project_name` will be used for s3 bucket and tags.
* `source_domain` is the domain where you need to enable the redirect for.
* `target_domain`is the domain you redirect to.

```
module "terraform-aws-s3-cloudfront-redirect" {
source = "git@github.com:elastic2ls/terraform-aws-s3-cloudfront-redirect.git"

  project_name  = var.project_name
  source_domain = var.source_domain
  target_domain = var.target_domain
}
```

The module can also be found in the Terraform Registry https://registry.terraform.io/modules/elastic2ls-com/https-redirect/aws/latest.
