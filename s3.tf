resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.aws_account_id}"
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  website {
    redirect_all_requests_to = "https://${var.target_domain}"
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.project_name
    },
  )
}
