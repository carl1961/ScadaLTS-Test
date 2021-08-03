#Carl Shelton
#email: cmshelton2021@protonmail.com
# date 7/29/2021
echo "Welcome to ScadaLTS installer!"

apt-get update
sudo apt-get install software-properties-common dirmngr
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
mkdir -p /opt/scadalts
cp ScadaBR.war /opt/scadalts
cp env.properties /opt/scadalts
echo "Installing Tomcat"
apt install -y tomcat

echo "Installing Default Jdk"

#install java 11
apt install -y default-jdk


 
echo "Install MariaDB Server"

# MySQL/MariaDB
apt install -y mariadb-server

# MySQL connector
apt install -y libmariadb-java

apt install -y librxtx-java

sudo systemctl enable mariadb
sudo systemctl start mariadb

root_password=admin
 
# Make sure that NOBODY can access the server without a password

sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('$root_password') WHERE User = 'root'"
 
# Kill the anonymous users
sudo mysql -e "DROP USER IF EXISTS ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
sudo mysql -e "DROP USER IF EXISTS ''@'$(hostname)'"
# Kill off the demo database
sudo mysql -e "DROP DATABASE IF EXISTS test"
 
echo "Creating scadalts database..."

sudo mysql -e "create user 'scadalts' identified by 'scadalts'"
sudo mysql -e "create database if not exists scadalts"
sudo mysql -e "grant all privileges on scadalts.* to 'scadalts'"
sudo mysql -e "flush privileges"


echo "Installing Scada-LTS "


mkdir -p /var/lib/tomcat9/webapps/ScadaBR
cd /opt/scadalts
unzip ScadaBR.war -d var/lib/tomcat9/webapps/ScadaBR
sudo rm /var/lib/tomcat9/webapps/ScadaBR/WEB-INF/classes/env.properties
cp env.properties /var/lib/tomcat9/webapps/ScadaBR/WEB-INF/classes/

echo "Starting Scada-LTS "
cd

/var/lib/tomcat9/bin/startup.sh



echo "Removing Install Folder"
 
sudo rm -rf /opt/scadalts

#echo "Removing ScadaLTS-Test Folder"

sudo rm -rf ScadaLTS-Test

echo "ScadaLTS Install Complete!"


