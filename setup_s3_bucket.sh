#!/bin/bash
sudo apt-get -y upgrade
sudo apt-get -y install python
sudo apt-get -y install python-pip
sudo -H pip install boto3
sudo pip install Click
sudo pip install colorama
sudo pip install termcolor
sudo mkdir -p /var/lib/jenkins/backup/
cd /var/lib/jenkins/backup
sudo git clone https://github.awsinternal.tri.global/IE/jenkins-backup-s3.git
