# lw-vts-modsec-nginx-modules
Vagrantfile build of mwp v2's nginx modsecurity and vts modules

## Pre-Installation
1. Make sure you have `vagrant` and `virtual box` installed

## Installation Instructions
1. git clone this repo
2. Enter into `lw-vts-modsec-nginx-modules` directory
3. `$ vagrant up` 
4. Grab some coffee, this will take awhile.
5. All your necessary debian packages will be located in
    - `/{path_to_local_proj}/lw-vts-modsec-nginx-modules/build_debs`

## Cleanup
1. First, make sure you have your debian packages copied over into mwp v2
2. You may delete your `build` and `build_debs` directories to free some space
2. `$ vagrant halt; vagrant destroy` will get rid of your VM
