#!/bin/bash
# Script to install git
# Installs: Dependencies: curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils perl-devel

yum erase -y git
yum -y update
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils
yum install -y perl-devel

cd /usr/src
echo "Get the git sources"
wget https://www.kernel.org/pub/software/scm/git/git-2.0.1.tar.gz
tar xzf git-2.0.1.tar.gz
cd git-2.0.1
echo "Install git from sources"
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc
echo $PATH

exit 0

