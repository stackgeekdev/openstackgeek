#!/bin/bash

# get keystone
apt-get install keystone python-keystone python-keystoneclient

read -p "Enter a token for the OpenStack services to auth wth keystone: " token
read -p "Enter the password you used for the MySQL users (nova, glance, keystone): " password

# edit keystone conf file to use templates and mysql
sed -e "
/^admin_token = ADMIN/s/^.*$/admin_token = $token/
/^driver = keystone.catalog.backends.sql.Catalog/d
/^\[catalog\]/a driver = keystone.catalog.backends.templated.TemplatedCatalog 
/^\[catalog\]/a template_file = /etc/keystone/default_catalog.templates
/^connection =.*$/s/^.*$/connection = mysql:\/\/keystone:$password@127.0.0.1\/keystone/
" -i /etc/keystone/keystone.conf
