source common.sh

print_head "Setup MongoDB Repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install MongoDB"
yum install mongodb-org -y

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf

print_head "Enable MongoDB"
systemctl enable mongod

print_head "Start MongoDB Service "
systemctl start mongod

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf