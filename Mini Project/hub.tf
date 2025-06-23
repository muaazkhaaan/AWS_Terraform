resource "aws_apigatewayv2_api" "hub_api" {
    name = "hub-api"
    protocol_type = "HTTP"

    tags = {
    managed-by = "Terraform"
    deployed_by = var.deployed_by
    Environment = "hub"    
    }
}

resource "aws_dynamodb_table" "example" {
    name             = "example-muaaz"
    hash_key         = "TestTableHashKey"
    billing_mode     = "PAY_PER_REQUEST"
    stream_enabled   = true
    stream_view_type = "NEW_AND_OLD_IMAGES"

    attribute {
        name = "TestTableHashKey"
        type = "S"
    }

    tags = {
    managed-by = "Terraform"
    deployed_by = var.deployed_by
    Environment = "hub"    
    }
}

resource "aws_security_group" "central_sg" {
  name   = "central-allow-from-spokes"
  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = local.spoke_cidrs
    content {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "central-ingress-from-spokes"
    environment  = "dev"
    managed-by   = "Terraform"
    deployed-by  = var.deployed_by
  }
}
