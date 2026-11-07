resource "aws_dynamodb_table" "orders" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.partition_key_name
  range_key      = var.sort_key_name

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.partition_key
      range_key       = try(global_secondary_index.value.sort_key, null)
      projection_type = try(global_secondary_index.value.projection_type, "KEYS_ONLY")
      read_capacity   = try(global_secondary_index.value.read_capacity, null)
      write_capacity  = try(global_secondary_index.value.write_capacity, null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.lsi
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.sort_key
      projection_type = try(local_secondary_index.value.projection_type, "KEYS_ONLY")
    }
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  server_side_encryption {
    enabled     = var.enable_encryption
    kms_key_arn = var.kms_key_arn
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.enable_ttl
  }

  tags = merge(
    var.tags,
    {
      "Name"        = var.table_name
      "Environment" = var.environment
      "Project"     = var.project_name
      "ManagedBy"   = "terraform"
    }
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_dynamodb_table_replica" "orders_replica" {
  count = var.enable_replication ? 1 : 0

  provider       = aws.replica
  table_name     = aws_dynamodb_table.orders.name
  kms_key_arn    = var.replica_kms_key_arn
  replica_region = var.replica_region

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ssm_parameter" "table_name_parameter" {
  count = var.store_table_name_in_ssm

  name        = "/${var.environment}/${var.project_name}/dynamodb/table-name"
  description = "DynamoDB table name for orders"
  type        = "String"
  value       = aws_dynamodb_table.orders.name

  tags = merge(
    var.tags,
    {
      "ManagedBy" = "terraform"
    }
  )
}

resource "aws_cloudwatch_log_group" "dynamodb_logs" {
  count = var.enable_detailed_metrics

  name              = "/aws/dynamodb/${var.table_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.table_name}-logs"
      "Environment" = var.environment
      "Project"     = var.project_name
    }
  )
}

resource "aws_iam_role" "dynamodb_access_role" {
  count = var.create_service_role

  name = "${var.table_name}-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.table_name}-access-role"
      "Environment" = var.environment
    }
  )
}

resource "aws_iam_policy" "dynamodb_read_policy" {
  count = var.create_service_role

  name        = "${var.table_name}-read-policy"
  description = "IAM policy for read access to ${var.table_name} DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.orders.arn,
          "${aws_dynamodb_table.orders.arn}/index/*"
        ]
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      "Name" = "${var.table_name}-read-policy"
    }
  )
}

resource "aws_iam_policy" "dynamodb_write_policy" {
  count = var.create_service_role

  name        = "${var.table_name}-write-policy"
  description = "IAM policy for write access to ${var.table_name} DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.orders.arn
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.orders.arn
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      "Name" = "${var.table_name}-write-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "dynamodb_read_attachment" {
  count = var.create_service_role

  role       = aws_iam_role.dynamodb_access_role[0].name
  policy_arn = aws_iam_policy.dynamodb_read_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_write_attachment" {
  count = var.create_service_role

  role       = aws_iam_role.dynamodb_access_role[0].name
  policy_arn = aws_iam_policy.dynamodb_write_policy[0].arn
}

resource "aws_backup_plan" "dynamodb_backup" {
  count = var.enable_backup

  name = "${var.table_name}-backup-plan"

  rule {
    name                = "daily-backup"
    target_vault_name   = var.backup_vault_name
    schedule            = var.backup_schedule
    start_window        = 60
    completion_window   = 180
    copy_action {
      destination_vault_arn = var.backup_destination_arn
    }
    lifecycle {
      cold_storage_after = var.backup_cold_storage_after
      delete_after       = var.backup_retention_days
    }
  }

  rule {
    name                = "monthly-backup"
    target_vault_name   = var.backup_vault_name
    schedule            = var.backup_monthly_schedule
    start_window        = 60
    completion_window   = 180
    lifecycle {
      delete_after       = var.backup_long_term_retention_days
    }
  }

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.table_name}-backup-plan"
      "Environment" = var.environment
    }
  )
}

resource "aws_backup_selection" "dynamodb_backup_selection" {
  count = var.enable_backup

  name         = "${var.table_name}-backup-selection"
  plan_id      = aws_backup_plan.dynamodb_backup[0].id
  resources    = [aws_dynamodb_table.orders.arn]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }

  tags = var.tags
}