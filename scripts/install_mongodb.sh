#!/bin/bash
# Script to setup repo and install MongoDB

meta_dir="../meta"

echo ""
echo "Setting up MongoDB repo.."
cp $meta_dir/mongodb.repo /etc/yum.repos.d/mongodb.repo


echo ""
echo "Installing MongoDB.."
yum -y install mongodb-org

echo ""
echo "Starting mongod service.."
service mongod start
echo ""
echo "Congrats! You have setup OVPL successfully!!! :-)"
echo "Now run 'make' from inside the src directory"
echo " of OVPL to start the services."

exit 0
