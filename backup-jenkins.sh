#!/bin/bash
# /var/lib/jenkins/backup/backup-jenkins.sh

# comment out credentials if AWS role based access will be provisioned
# best practice is to use AWS role based access with scoped permissions
# in this example, we will use an AWS role that has been assigned by the AWS IE Cloud admin 
# your AWS role will include EC2 and S3 policies at a minimum
#export AWS_ACCESS_KEY_ID=*** your access key*** ← not needed if using IAM roles
#export AWS_SECRET_ACCESS_KEY=***your secret key *** ← not needed if using IAM roles

cd /var/lib/jenkins/backup/jenkins-backup-s3   
git pull

BACKUP_PY=/var/lib/jenkins/backup/jenkins-backup-s3/backup.py


python $BACKUP_PY  --bucket-region=$1 --bucket=$2 --bucket-prefix=$3 create -e workspace -e backup -e .gradle -e .npm -e .kube -e .cache -e tools

