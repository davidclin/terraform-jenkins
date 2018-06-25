echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
sudo sed -i 's/ServerName cloud-jenkins.awsinternal.domain.com/ServerName '$1'.awsinternal.domain.com/g' /etc/apache2/sites-enabled/default-ssl.conf
sudo sed -i 's/ServerAdmin david.lin@domain.com/ServerName '$2'/g' /etc/apache2/sites-enabled/default-ssl.conf
sudo sed -i 's/<useSecurity>true/<useSecurity>false/g' /var/lib/jenkins/config.xml
sudo sed -i 's/cloud-jenkins.awsinternal.domain.com'/$1'.awsinternal.domain.com/g' /var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml
sudo sed -i 's/<adminAddress>cloud-jenkins@domain.com/<adminAddress>'$2'/g' /var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml
echo "updating apt-get... "
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
   sleep 10
done
sudo apt-get update
echo "upgrading apt-get..."
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
   sleep 10
done
sudo apt-get --yes --force-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade

sudo service apache2 restart
sudo service jenkins restart
