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

resource "aws_kms_key" "this" {
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
