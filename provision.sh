#!/bin/sh

echo "**** HIERA DEMO: BOOTSTRAPPING ****"

# Remove old version of puppet installed in this box.
yum remove -y puppet facter

# Install some other useful utils
yum install -y tree

# Add puppetlabs EL6 yum repo.
rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

# Install the latest version of puppet.
yum install -y puppet facter

# Install the required ruby gems for the hiera demo.
gem install hiera-gpg hiera-eyaml hiera-eyaml-gpg deep_merge --no-ri --no-rdoc 

# Host name setup.
HOSTNAME=hierademo
DOMAIN=example.com
FQDN="${HOSTNAME}.${DOMAIN}"
hostname ${FQDN}
echo "127.0.0.1 ${FQDN} ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/HOSTNAME=.*$/HOSTNAME=${FQDN}/" /etc/sysconfig/network

echo "**** HIERA DEMO: BOOTSTRAP DONE. ****"

