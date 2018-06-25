#!/bin/bash
JAVA=/usr/bin/java
JENKINS_CLI=/home/ubuntu/jenkins-cli.jar
JENKINS_URL=http://localhost:8080/
JCMD="$JAVA -jar $JENKINS_CLI -s $JENKINS_URL"
wget -O /home/ubuntu/jenkins-cli.jar -N $JENKINS_URL/jnlpJars/jenkins-cli.jar
echo "set GHE URL, Client info and TCP Port in Jenkins..."
$JCMD -remoting groovy /home/ubuntu/setSecurityRealm.groovy $1 $2 $3 $4 
$JCMD -remoting groovy /home/ubuntu/setJNLPAgentProtocols.groovy
