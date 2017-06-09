#!/bin/bash
# Script to setup a fresh installation of CentOS to run OVPL
# Installs: Dependencies: python-devel, git, pip; mongodb; openvz.

# check if script is run as root
if [[ $UID -ne 0 ]]; then
  echo ""
  echo "$0 must be run as root!"
  echo "Exiting.."
  exit 1
fi

# check if meta directory exists
if [[ ! -d "../meta" ]]; then
  echo ""
  echo "You don't have the necessary files."
  echo "Please contact the author of the script."
  exit 1
fi

# read proxy settings from config file
source ./config.sh

if [[ -n $http_proxy ]]; then
  echo $http_proxy
  export http_proxy=$http_proxy
fi
if [[ -n $https_proxy ]]; then
  export https_proxy=$https_proxy
fi

yum update -y
yum install -y vim rsync


export PATH="$PATH:/usr/local/git/bin"
echo "Invoking install_dependencies.sh"
./install_dependencies.sh
if [ $? -ne 0 ]; then
  echo ""
  echo "Error installing dependencies. Quitting!"
  exit 1
fi

echo "Invoking install_openvz.sh"
./install_openvz.sh
if [ $? -ne 0 ]; then
  echo ""
  echo "Error installing OpenVZ. Quitting!"
  exit 1
fi

echo "Invoking install_mongodb.sh"
./install_mongodb.sh
if [ $? -ne 0 ]; then
  echo ""
  echo "Error installing MongoDB. Quitting!"
  exit 1
fi

exit 0
