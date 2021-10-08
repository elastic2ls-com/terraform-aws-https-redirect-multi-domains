# Terraform module for S3 redirects with CloudFront, ACM

<p align="center">
<img src="/assets/img/Logo_box-1-150x150.png">
</p>
<p>&nbsp;</p>

![License](https://img.shields.io/badge/license-Apache-brightgreen?logo=apache) ![Status](https://img.shields.io/badge/status-active-brightgreen.svg?logo=git) [![Sponsor](https://img.shields.io/badge/sponsors-AlexanderWiechert-blue.svg?logo=github-sponsors)](https://github.com/sponsors/AlexanderWiechert/) [![Contact](https://img.shields.io/badge/follow-@Elastic2lscom-blue.svg?logo=facebook&style=social)](https://www.facebook.com/Elastic2lscom-241339337786673/) [![Terraform Registry](https://img.shields.io/badge/download-blue.svg?logo=terraform&style=social)](https://registry.terraform.io/modules/elastic2ls-com/https-redirect-multi-domains/aws/latest)



This module helps you create a S3 bucket which performs HTTPS redirects for multiple domains. This can scale to as much domains you will enter in settings.yaml.

It includes the following:

* S3 bucket
* SAN certificate managed by AWS ACM
* route53 Zones for the apex domains **(You have to add a NS delegation to your main DNS setup.)**
* cloudfront distribution


## Sample Usage
This module requires 3 arguments.
* `stage` namer of the stage where you want to deploy to resources.
* `target_domain`is the domain you redirect to.
* `source_domains` are the domains where you need to enable the redirect for.
* `project_name` may `myredirects`
* `aws_region` Is hardcoded as `us-east-1` as it is used for the AWS provider which will create the SAN certificate for teh cloudffront distribution.

## Add domains

Domains need to be added to settings.yaml this way. The key is apex domain name which will be used to create the route53 zones. All subdomains follow as values to ensure they can be added to the correct route53 zones.
```
source_domains:
  elastic2ls.com:
    - elastic2ls.com
    - www.elastic2ls.com
```



```
module "terraform-aws-s3-cloudfront-redirect" {
source = "git@github.com:elastic2ls/terraform-aws-https-redirect-multi-domains.git"

  stage  = var.project_name
  target_domain = var.source_domain
  source_domains = var.target_domain+
  project_name = var.project_name
  aws_region = var.aws_region
}
```

The module can also be found in the Terraform Registry https://registry.terraform.io/modules/elastic2ls-com/https-redirect-multi-domains/aws/latest.
