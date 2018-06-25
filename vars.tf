# Copyright 2018 Toyota Research Institute. All rights reserved.

variable "name" {
  description = "Team name, appended to jenkins instance as a tag."
}

variable "pretty_name" {
  description = "Valid URL pretty name for Route53 record (do not include '.awsinternal.tri.global')."
}

variable "instance_type" {
  description = "AWS instance type to launch Jenkins Master on."
}

variable "disk_size" {
  description = "Disk size in GB for the Jenkins Master (default 300 GB)."
  default = 300
}

variable "key_pair" {
  description = "Name of key pair to attach to the Jenkins Master instance."
}

variable "admin_email" {
  description = "Valid Email address for admin user (including @tri.global)."
}

variable "admin_user_name" {
  description = "GHE user names to give admin rights to jenkins server(comma separated list of names)."
}
variable "pem_file" {
  description = "ec2 instance pem file to connect for post provision (full path to file)."
}

variable "ghe_web_uri" {
  description = "GHE web Uri for Authentication of User."
}

variable "ghe_api_uri" {
  description = "GHE API Uri for Authentication of User."
}

variable "ghe_client_id" {
  description = "GHE organization client id for Authentication of User."
}

variable "ghe_client_secret" {
  description = "GHE organization client secret for Authentication of User."
}

variable "cert_file_path" {
  description = "Valid ssl certificate jenkins server(cert full path)."
}

variable "bucket_name" {
  description = "Bucket Name where Jenkins backup will be stored."
}

variable "region" {
  description = "Region where bucket located."
  default = "us-east-1"
}
