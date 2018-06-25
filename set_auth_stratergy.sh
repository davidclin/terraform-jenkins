#!/bin/bash
JAVA=/usr/bin/java
JENKINS_CLI=/home/ubuntu/jenkins-cli.jar
JENKINS_URL=http://localhost:8080/
JCMD="$JAVA -jar $JENKINS_CLI -s $JENKINS_URL"
echo "setting up AuthorizationStrategy for jenkins..." 
$JCMD -remoting groovy /home/ubuntu/setAuthorizationStrategy.groovy $1
echo "Restarting..."
sudo service jenkins restart
