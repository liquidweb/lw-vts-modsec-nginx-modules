sudo -E apt-get update
sudo -E apt-get -y upgrade
sudo -E apt-get -y install devscripts build-essential
sudo -E apt-get -y install debhelper po-debconf libexpat-dev libgd-dev libgeoip-dev libhiredis-dev libluajit-5.1-dev libmhash-dev libpam0g-dev libpcre3-dev libperl-dev libssl-dev libxslt1-dev quilt zlib1g-dev
sudo -E apt-get -y install libcurl4-openssl-dev apache2-dev

rm -rf /vagrant/build
mkdir -p /vagrant/build
cd /vagrant/build


mkdir modsecurity
wget -o /dev/null https://github.com/SpiderLabs/ModSecurity/archive/v2.9.3.tar.gz -O - | tar -xzvf - --strip-components 1 -C modsecurity
cd modsecurity
./autogen.sh
./configure
make
sudo -E make install
cd ..


apt-get source nginx
cd nginx*/debian

dch -n ""

# BEGIN VTS module block
mkdir modules/http-vhost-traffic-status
wget -o /dev/null https://github.com/vozlt/nginx-module-vts/archive/v0.1.18.tar.gz -O - | tar -xzvf - --strip-components 1 -C modules/http-vhost-traffic-status

cat > libnginx-mod-http-vhost-traffic-status.nginx <<"EOF"
#!/usr/bin/perl -w

use File::Basename;

# Guess module name
$module = basename($0, '.nginx');
$module =~ s/^libnginx-mod-//;

$modulepath = $module;
$modulepath =~ s/-/_/g;

print "mod debian/build-extras/objs/ngx_${modulepath}_module.so\\n";
print "mod debian/libnginx-mod.conf/mod-${module}.conf\\n";
EOF

chmod 755 libnginx-mod-http-vhost-traffic-status.nginx

cat >> control <<"EOF"

Package: libnginx-mod-http-vhost-traffic-status
Architecture: any
Depends: ${misc:Depends}, ${shlibs:Depends}
Description: Nginx virtual host traffic status module
 Nginx module that provides access to virtual host status information. It
 contains the current status such as servers, upstreams, caches. This is
 similar to the live activity monitoring of nginx plus. The built-in html is
 also taken from the demo page of old version.
EOF

cat >> modules/control <<"EOF"
Module: http-vhost-traffic-status
Homepage: https://github.com/vozlt/nginx-module-vts
Version: 0.1.18

EOF

cat >> libnginx-mod.conf/mod-http-vhost-traffic-status.conf <<"EOF"
load_module modules/ngx_http_vhost_traffic_status_module.so;
EOF

sed -ri 's/(.+)http-auth-pam(.+)/\1http-auth-pam\2\n\1http-vhost-traffic-status\2/' rules

dch -a "add vts module"
# END VTS module block

# BEGIN Mod Sec module block
mkdir modules/http-modsecurity
wget -o /dev/null https://github.com/SpiderLabs/ModSecurity-nginx/archive/v1.0.0.tar.gz -O - | tar -xzvf - --strip-components 1 -C modules/http-modsecurity

cat > libnginx-mod-http-modsecurity.nginx <<"EOF"
#!/usr/bin/perl -w

use File::Basename;

# Guess module name
$module = basename($0, '.nginx');
$module =~ s/^libnginx-mod-//;

$modulepath = $module;
$modulepath =~ s/-/_/g;

print "mod debian/build-extras/objs/ngx_${modulepath}_module.so\\n";
print "mod debian/libnginx-mod.conf/mod-${module}.conf\\n";
EOF

chmod 755 libnginx-mod-http-modsecurity.nginx

cat >> control <<"EOF"

Package: libnginx-mod-http-modsecurity
Architecture: any
Depends: ${misc:Depends}, ${shlibs:Depends}
Description: ModSecurity-nginx connector
 The ModSecurity-nginx connector is the connection point between nginx and libmodsecurity (ModSecurity v3).
 Said another way, this project provides a communication channel between nginx and libmodsecurity.
 This connector is required to use LibModSecurity with nginx.
EOF

cat >> modules/control <<"EOF"
Module: libnginx-mod-http-modsecurity
Homepage: https://github.com/SpiderLabs/ModSecurity-nginx
Version: 1.0.0

EOF

cat >> libnginx-mod.conf/mod-http-modsecurity.conf <<"EOF"
load_module modules/ngx_http-modsecurity_module.so;
EOF

sed -ri 's/(.+)http-auth-pam(.+)/\1http-auth-pam\2\n\1http-modsecurity\2/' rules

dch -a "add Mod Sec module"
# END Mod Sec module block

dch -r ""

cd ..
debuild -us -uc -b

shutdown -h now
