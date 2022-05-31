resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = var.domain_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = 1
    dedicated_master_enabled = false
    zone_awareness_enabled   = false
  }
  ebs_options {
    volume_size = 10
    volume_type = "gp2"
    ebs_enabled = true
  }
  encrypt_at_rest {
    enabled = true
  }
  node_to_node_encryption {
    enabled = true
  }
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true

    master_user_options {
      master_user_name     = var.master_name
      master_user_password = var.master_password
    }
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
}

resource "aws_elasticsearch_domain_policy" "domain_policy" {
  domain_name = aws_elasticsearch_domain.opensearch.domain_name

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "${aws_elasticsearch_domain.opensearch.arn}/*"
    }
  ]
}
POLICIES
}


