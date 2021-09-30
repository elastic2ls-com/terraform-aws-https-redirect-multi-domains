resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.aws_account_id}"

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
