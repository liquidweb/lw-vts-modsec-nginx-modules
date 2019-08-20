# lw-vts-modsec-nginx-modules
Vagrantfile build of mwp v2's nginx modsecurity and vts modules

## Pre-Installation
1. Make sure you have `vagrant` and `virtual box` installed

## Installation Instructions
1. git clone this repo
2. Enter into `lw-vts-modsec-nginx-modules` directory
3. `$ vagrant up` 
4. Grab some coffee, this will take awhile.
5. Your debian packages will be located here:
    - `/{path_to_local_proj}/lw-vts-modsec-nginx-modules/build/libmodsecurity3_3.0.3-1_amd64.deb`
    - `/{path_to_local_proj}/lw-vts-modsec-nginx-modules/build/libnginx-mod-http-modsecurity_1.14.0-0ubuntu1.5_amd64.deb`
    - `/{path_to_local_proj}/lw-vts-modsec-nginx-modules/build/libnginx-mod-http-vhost-traffic-status_1.14.0-0ubuntu1.5_amd64.deb`

## Cleanup
1. First, make sure you have your debian packages on your machine
2. `$ vagrant halt; vagrant destroy` to get rid of your VM
