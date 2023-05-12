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

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "this" {
  deletion_window_in_days = 10
  enable_key_rotation = true
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

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = true
  }
}

resource "aws_s3_bucket_versioning" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = true
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log_bucket"
}

resource "aws_s3_bucket_public_access_block" "log" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.this.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
