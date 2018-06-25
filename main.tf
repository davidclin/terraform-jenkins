# Copyright 2018 Toyota Research Institute. All rights reserved.
resource "aws_s3_bucket_object" "folder" {
    bucket = "${var.bucket_name}"
    acl    = "private"
    key    = "${var.pretty_name}-backup/"
    source = "/dev/null"
}
resource "aws_iam_role" "role"{  
   name = "${var.name}_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "attach-policy" {
    role       = "${aws_iam_role.role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_instance_profile" "instance_profile" {
    name = "${var.name}_instance_profile"
    role = "${aws_iam_role.role.name}"
}
resource "aws_iam_role_policy" "s3_role_policy"{  
   name = "${var.pretty_name}_iam_role_policy"	  
   role = "${aws_iam_role.role.id}"

  policy = <<EOF
{ 
   "Version":"2012-10-17",
   "Statement": [
        {
            "Sid": "AllowRootAndHomeListingOfCompanyBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:prefix": [
                        "",
                        "${var.pretty_name}-backup"
                    ],
                    "s3:delimiter": [
                        "/"
                    ]
                }
            }
        },
        {
            "Sid": "AllowAllS3ActionsInUserFolder",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/${var.pretty_name}-backup/*"
            ]
        }
    ]
}
EOF
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-d359afc5"                                   # Jenkins 2 AMI
  instance_type          = "${var.instance_type}"
  subnet_id              = "subnet-15fa8728"                                # AZ: us-east-1e
  vpc_security_group_ids = ["${aws_security_group.open_to_inbound_ssh.id}"]
  key_name               = "${var.key_pair}"
  iam_instance_profile   = "${aws_iam_instance_profile.instance_profile.id}"

  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = "${var.disk_size}"
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  tags {
    Name = "Jenkins2-${var.name}-Team"
  }
  provisioner "file" {
    source      = "${var.cert_file_path}"
    destination = "/tmp/star_awsinternal_tri_global.crt"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "upgrade-plugins.sh"
    destination = "/home/ubuntu/upgrade-plugins.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "set_auth_stratergy.sh"
    destination = "/home/ubuntu/set_auth_stratergy.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "init.sh"
    destination = "/home/ubuntu/init.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "set_security_relam.sh"
    destination = "/home/ubuntu/set_security_relam.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "setup_s3_bucket.sh"
    destination = "/home/ubuntu/setup_s3_bucket.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "backup-jenkins.sh"
    destination = "/home/ubuntu/backup-jenkins.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "apache_ssl_cert.sh"
    destination = "/home/ubuntu/apache_ssl_cert.sh"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "setSecurityRealm.groovy"
    destination = "/home/ubuntu/setSecurityRealm.groovy"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "setAuthorizationStrategy.groovy"
    destination = "/home/ubuntu/setAuthorizationStrategy.groovy"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "file" {
    source      = "setJNLPAgentProtocols.groovy"
    destination = "/home/ubuntu/setJNLPAgentProtocols.groovy"
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
  provisioner "remote-exec" {
    inline = [
        "sh /home/ubuntu/init.sh ${var.pretty_name} ${var.admin_email}",
        "crontab -r",
        "(crontab -l 2>/dev/null; echo '0 5 * * * sudo apt-get update ; DEBIAN_FRONTEND=noninteractive sudo apt-get -y upgrade > /home/ubuntu/upgrade.log 2>&1') | crontab -",
        "sudo service apache2 restart",
        "sudo service jenkins restart",
        "sleep 60",
        "sudo chmod +x /home/ubuntu/backup-jenkins.sh /home/ubuntu/upgrade-plugins.sh",
        "sh /home/ubuntu/set_security_relam.sh ${var.ghe_web_uri} ${var.ghe_api_uri} ${var.ghe_client_id} ${var.ghe_client_secret}",
        "sh /home/ubuntu/upgrade-plugins.sh",
        "(crontab -l 2>/dev/null; echo '30 5 * * * /home/ubuntu/upgrade-plugins.sh > /home/ubuntu/upgrade-plugins.log 2>&1') | crontab -",
        "sleep 60",
        "sh /home/ubuntu/set_auth_stratergy.sh ${var.admin_user_name}",
        "sh /home/ubuntu/setup_s3_bucket.sh",
        "sh /home/ubuntu/backup-jenkins.sh ${var.region} ${var.bucket_name} ${var.pretty_name}-backup",
        "(crontab -l 2>/dev/null; echo '30 5 * * * /home/ubuntu/backup-jenkins.sh ${var.region} ${var.bucket_name} ${var.pretty_name}-backup > /home/ubuntu/upgrade-plugins.log 2>&1') | crontab -",
        "sh /home/ubuntu/apache_ssl_cert.sh"
    ]
    connection {
       type = "ssh"
       user = "ubuntu"
       private_key = "${file(var.pem_file)}"
    }
  }
}

resource "aws_route53_record" "jenkins_route53_record" {
  zone_id = "ZTRS331F0P30Y"
  name    = "${var.pretty_name}.awsinternal.tri.global."
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.jenkins.private_ip}"]
}

resource "aws_security_group" "open_to_inbound_ssh" {
  name        = "jenkins-inbound-ssh-https"
  description = "Open to inbound ssh and https traffic"
  vpc_id      = "vpc-b7407ed3"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "jenkins-inbound-ssh-https"
  }
}
