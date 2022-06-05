variable "username" {
  description = "The code of the Databricks user to use."
  type = string
  default = ""
}

variable "password" {
  description = "The code of the AWS Region to use."
  type = string
  default = ""
}

variable "host" {
  description = "The code of the AWS Region to use."
  type = string
  default = ""
}


variable "aws_region" {
  description = "The code of the AWS Region to use."
  type = string
  default = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

    databricks = {
      source = "databrickslabs/databricks"
    }
  }
}

provider "aws" {
  profile = var.aws_connection_profile
  region = var.aws_region
}

provider "databricks" {
  //profile = var.databricks_connection_profile
    username = "${var.username}"
  password = "${var.password}"
  host = "${var.host}"
}

variable "resource_prefix" {
  description = "The prefix to use when naming the notebook and job"
  type = string
  default = "terraform-demo"
}

variable "email_notifier" {
  description = "The email address to send job status to"
  type = list(string)
  default = ["test@email.com"]
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "single_node" {
  cluster_name            = "Single Node"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20

  spark_conf = {
    # Single-node
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
}
