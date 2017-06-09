#!/bin/bash

meta_dir="../meta"


echo "Installing dependencies.. yum -y install gcc python-devel.x86_64 python-pip ssh rsync"
yum -y install gcc python-devel.x86_64 python-pip

echo "====== Installing python-setuptools using yum -y install python-setuptools ======"
yum -y install python-setuptools


cd /root
echo "======== Cloning OVPL source code ========="
git clone https://github.com/vlead/ovpl.git
cd ovpl
git checkout -b develop remotes/origin/develop
echo "===== Changed to ovpl directory ======="
echo "===== Running python setup.py install ========="
python setup.py install

exit 0
