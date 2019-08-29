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
sudo -E apt-get -y install devscripts build-essential dpkg-dev

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

dch --nmu "OpenSSL Bump for http/2"
dch --nmu "Patched http2"

echo "************************* Build Packages *********************************"
cd ..
debuild -us -uc -b

echo "************************* Copy Important Debs ****************************"
cd /vagrant
rm -rf /vagrant/build_debs
mkdir -p /vagrant/build_debs

packages=(
    nginx_1.12.1-1~0.*_amd64.deb
)

for package in "${packages[@]}"
do
    echo "copying $package into /vagrant/build_debs"
    cp build/$package build_debs
done
