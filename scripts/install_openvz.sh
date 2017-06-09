#!/bin/bash
# Script to setup OpenVZ repo, install and configure OpenVZ

scripts_dir="../scripts"
meta_dir="../meta"
vz_template_file="ubuntu-12.04-custom-x86_64.tar.gz"

echo "==============="
echo "Downloading $vz_template_file file to $meta_dir directory"
echo "==============="
echo "iiit_lan = $iiit_lan"
if [ $iiit_lan -eq 1 ]
then
    echo "In the IIIT lan, have to unset proxy while downloading from LAN"
    unset http_proxy
    unset https_proxy
    cd $meta_dir
    wget community.virtual-labs.ac.in/downloads/ubuntu-12.04-custom-x86_64.tar.gz
    cd $scripts_dir
    source ./config.sh
    echo $http_proxy
else
    cd $meta_dir
    wget community.virtual-labs.ac.in/downloads/ubuntu-12.04-custom-x86_64.tar.gz
fi

echo ""
echo "Setting up OpenVZ repo.."
#wget -P /etc/yum.repos.d/ http://ftp.openvz.org/openvz.repo
cp $meta_dir/openvz.repo /etc/yum.repos.d/openvz.repo
rpm --import http://ftp.openvz.org/RPM-GPG-Key-OpenVZ

echo ""
echo "Installing the OpenVZ kernel.."
yum -y install vzkernel

echo ""
echo "Configuring OpenVZ.."
cat $meta_dir/updated_sysctl.conf >> /etc/sysctl.conf
echo "SELINUX=disabled" > /etc/sysconfig/selinux

echo ""
echo "Installing OpenVZ tools.."
yum -y install vzctl vzquota ploop vzstats

if [[ ! -f $meta_dir/$vz_template_file ]]; then
  echo ""
  echo "VZ OS template file not found!"
  echo "Please obtain an VZ OS template image and manually"
  echo "copy that into /vz/template/cache folder."
  echo "Failing the above step will result in OVPL not working."
  echo "Please contact VLEAD for further clarifications."
else
  echo ""
  echo "Copying the default OS template for containers.."
  cp $meta_dir/$vz_template_file /vz/template/cache
fi

# Not needed!? Not sure.
echo "Allowing multiple subnets to reside on the same network interface.."
sed -i 's/#NEIGHBOUR_DEVS=all/NEIGHBOUR_DEVS=all/g' /etc/vz/vz.conf
sed -i 's/#NEIGHBOUR_DEVS=detect/NEIGHBOUR_DEVS=all/g' /etc/vz/vz.conf
#
echo "Setting container layout to default to ploop (VM in a file).."
sed -i 's/VE_LAYOUT=ploop/VE_LAYOUT=simfs/g' /etc/vz/vz.conf
#
echo "Setting Ubuntu 12.04 64bit to be the default template.."
sed -i 's/centos-6-x86/ubuntu-12.04-x86_64/g' /etc/vz/vz.conf

#set nf_conntrack ip_conntrack_disable_ve0 to 0
sed -i 's/=1/=0/g' /etc/modprobe.d/openvz.conf
#
#sysctl -p
#
#Setting the IP table rules
cp $meta_dir/iptables-save /etc/sysconfig/iptables
#service iptables restart

echo ""
echo "Finished installing OpenVZ"

exit 0
