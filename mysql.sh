source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo "Missing MySql Root Pwd Argument"
  exit 1
fi


print_head "Disabling MySql 8 Version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Copy MySql Repo file"
cp ${code_dir}/configs/mysql.repo etc/yum.repos.d/mysql.repo  &>>${log_file}
status_check $?

print_head "Installing Mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable Mysql server"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start Mysql server"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set Root Password"
echi show databases | mysql -uroot -pR${mysql_root_password}   &>>${log_file}
if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?

