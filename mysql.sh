source common.sh

mysql_root_password=$1
if[ -z "${mysql_root_password}" ]; then
  echo "Missing MySql Root Pwd Argument"
  exit 1
fi


print_head "Disabling MySql 8 Version"
dnf module disable mysql -y
status_check $?

print_head "Installing Mysql server"
yum install mysql-community-server -y
status_check $?

print_head "Enable Mysql server"
systemctl enable mysqld
status_check $?

print_head "Start Mysql server"
systemctl start mysqld
status_check $?

print_head "Set Root Password"
mysql_secure_installation --set-root-pass ${mysql_root_password}
status_check $?

mysql -uroot -pRoboShop@1
status_check $?