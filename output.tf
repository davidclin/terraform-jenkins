# Copyright 2018 Toyota Research Institute. All rights reserved.

output "jenkins_private_ip" {
  value = "${aws_instance.jenkins.private_ip}"
}
