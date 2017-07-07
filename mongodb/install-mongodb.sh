#!/bin/bash

mongodb_version="3.2"

cat << EOF >> /etc/yum.repos.d/mongodb-org-$mongodb_version.repo
[mongodb-org-$mongodb_version]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/$mongodb_version/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-$mongodb_version.asc
EOF

mv /tmp/disable-thp /etc/init.d/disable-thp
chown 0:0 /etc/init.d/disable-thp
chmod 755 /etc/init.d/disable-thp
chkconfig disable-thp on
service disable-thp start

sed -ie 's/1024/65000/g' /etc/security/limits.d/90-nproc.conf

yum install -y mongodb-org
chkconfig mongod on
service mongod start

