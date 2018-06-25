#!/bin/bash
expiry=`openssl x509 -enddate -noout -in /etc/ssl/certs/star_awsinternal_domain.com.crt | cut -d "=" -f2`
date=`date -d "$expiry" +%Y%m%d`
echo "Back up existing cert..."
sudo cp /etc/ssl/certs/star_awsinternal_domain.com.crt /etc/ssl/certs/star_awsinternal_domain.com.crt-$date
echo "load latest valid cert..."
sudo cp /tmp/star_awsinternal_domain.com.crt /etc/ssl/certs
echo "restart apache..."
sudo service apache2 restart
