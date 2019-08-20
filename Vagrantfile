# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.provider :virtualbox do |vb|
      vb.customize [
                      'modifyvm', :id,
                      '--memory', '2048',
                      '--cpus', '4'
                   ]
  end

  config.vm.provision "shell", privileged: false, inline: <<-SHELL

export DEBEMAIL="scoil@liquidweb.com"
export DEBFULLNAME="Scott Coil"
export DEBIAN_FRONTEND=noninteractive

cd /vagrant
sh build.sh

  SHELL
end
