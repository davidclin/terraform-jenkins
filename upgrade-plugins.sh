#!/bin/bash
JAVA=/usr/bin/java
JENKINS_CLI=/home/ubuntu/jenkins-cli.jar
JENKINS_URL=http://localhost:8080/ 
JCMD="$JAVA -jar $JENKINS_CLI -s $JENKINS_URL"
wget -O /home/ubuntu/jenkins-cli.jar -N $JENKINS_URL/jnlpJars/jenkins-cli.jar
echo "Upgrading Jenkins plug-ins..."
$JCMD list-plugins | cut -d" " -f1 | xargs $JCMD install-plugin
echo "install plugin amazon ec2 container service for slave nodes..."
$JCMD install-plugin amazon-ecs
echo "install role-based access plugin..."
$JCMD install-plugin role-strategy
echo "Restarting..."
$JCMD safe-restart

