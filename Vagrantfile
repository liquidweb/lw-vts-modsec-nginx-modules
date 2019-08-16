# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
export DEBEMAIL="scoil@liquidweb.com"
export DEBFULLNAME="Scott Coil"

export DEBIAN_FRONTEND=noninteractive

cd /vagrant
sh build.sh

  SHELL
end
