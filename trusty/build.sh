#!/bin/bash

echo "***************************** Install Packages ***************************"
cd /vagrant
sudo cp files/ppa_ondrej_php_trusty.list /etc/apt/sources.list.d
sudo cp files/nginx_org_trusty.list /etc/apt/sources.list.d
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 4F4EA0AAE5267A6C
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62
sudo sed -ri 's/archive.ubuntu.com/mirrors.liquidweb.com/' /etc/apt/sources.list
sudo sed -ri 's/security.ubuntu.com/mirrors.liquidweb.com/' /etc/apt/sources.list
sudo -E apt-get update
sudo -E apt-get -y upgrade
sudo -E apt-get -y upgrade openssl
sudo apt-get install -y dpkg-dev

echo "************************* Rebuild /vagrant/build *************************"
rm -rf /vagrant/build
mkdir -p /vagrant/build
cd /vagrant/build

echo "************************* Install nginx Source ***************************"
apt-get source nginx=1.12.1-1
sudo apt-get -y build-dep nginx=1.12.1-1

echo "************************* Apply security patch ***************************"
cd nginx-1.12.1/debian
mkdir -p patches
quilt import /vagrant/files/http2.patch

echo "************************* Build Packages *********************************"
cd ..
debuild -us -uc -b

# apt-get source (right nginx)
# add patch file
# rebuild

# # Install package building tools
# sudo apt-get install -y dpkg-dev
#
# # (optional) cleanup previous work directory
# #sudo rm -R /opt/nginx
#
# # Create a work directory
# sudo mkdir /opt/nginx
#
# # Switch to our work directory
# cd /opt/nginx
#
# # Get NGINX source files
# sudo apt-get source nginx
#
# # Install NIGNX build dependencies
# sudo apt-get -y build-dep nginx
#
# # Switch to the source files directory
# # You might need to change the version number in your case
# cd nginx-1.*
#
# # Build the .deb package files
# sudo dpkg-buildpackage -b
#
# # Move back to out work directory where the .deb files are placed
# cd /opt/nginx
#
# # Stop NGINX
# sudo service nginx stop
#
# # Install the newly build .deb file
# sudo dpkg --install nginx_1.*~trusty_amd64.deb
#
# # Start NGINX
# sudo service nginx start
#
# # Profit ;)
