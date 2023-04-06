source common.sh

print_head "Configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installing nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Creating User Roboshop"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Creating Application Directory"
if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Removing old files from Dir"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading app content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
cd /app
status_check $?

print_head "Extracting app content"
unzip /tmp/user.zip &>>${log_file}
cd /app
status_check $?

print_head "Installing npm user service"
npm install &>>${log_file}
status_check $?

print_head "Copying SystemD Service File"
# shellcheck disable=SC2154
cp ${code_dir}/configs/user.service etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "SystemD reloading"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable user service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Start user Service"
systemctl restart user &>>${log_file}
status_check $?

print_head "Copy mongodb Repo File"
cp configs/mongodb.repo etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema"
mongo --host user.antodevops20.com </app/schema/user.js &>>${log_file}
status_check $?