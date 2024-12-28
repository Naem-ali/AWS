provider "aws" {
  region = "us-east-1"
# Change the region to match the AWS region where you want to deploy the firewall.
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
    Environment = "production"
  }
}

# Create subnets for the firewall
resource "aws_subnet" "firewall_subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "firewall-subnet-${count.index + 1}"
    Environment = "production"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create a Network Firewall Rule Group
resource "aws_networkfirewall_rule_group" "example" {
  capacity = 1000
  name     = "example-rule-group"
  type     = "STATEFUL"
  description = "Network firewall rule group for domain allowlist"

  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [aws_vpc.main.cidr_block]
        }
      }
    }

    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types        = ["TLS_SNI", "HTTP_HOST"]
        targets             = ["example.com"]
        ports              = [443, 80]
        protocols          = ["TCP"]
      }
    }
  }

  tags = {
    Name = "example-rule-group"
    Environment = "production"
  }
}

# Create a Firewall Policy
resource "aws_networkfirewall_firewall_policy" "example" {
  name = "example-firewall-policy"
# Change the firewall policy name to match your naming standards.

  firewall_policy {
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.example.arn
    }

    stateless_default_actions = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:drop"]
  }
}

# Create the Firewall
resource "aws_networkfirewall_firewall" "example" {
  name = "example-firewall"
# Update the firewall name to something meaningful for your environment.
  firewall_policy_arn = aws_networkfirewall_firewall_policy.example.arn
  vpc_id             = aws_vpc.main.id

  subnet_mappings {
    subnet_id = aws_subnet.firewall_subnets[0].id
  }
  subnet_mappings {
    subnet_id = aws_subnet.firewall_subnets[1].id
  }
}
