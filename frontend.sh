source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

print_head "Extracting Downloaded Frontend Content"
# shellcheck disable=SC2164
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

print_head "Copying Nginx Config for Roboshop"

cp ${code_dir}/configs/nginx-roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

print_head "Starting nginx"
systemctl restart nginx &>>${log_file}
echo $?
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi