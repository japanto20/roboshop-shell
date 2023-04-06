source common.sh

print_head "Setup MongoDB Repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?


print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "Start MongoDB Service "
systemctl start mongod &>>${log_file}
status_check $?

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf