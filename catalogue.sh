source common.sh

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Installing nodejs"
yum install nodejs -y

print_head "Adding User Roboshop"
useradd roboshop

print_head "Creating Dir"
mkdir /app

print_head "Removing old file from Dir"
rm -rf /app/*
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app

print_head "Installing npm catalogue service"
npm install
cp configs/catalogue.service etc/systemd/system/catalogue.service

print_head "Daemon reloading"
systemctl daemon-reload

print_head "Enable Catalogue service"
systemctl enable catalogue

print_head "Start Catalogue Service"
systemctl start catalogue

print_head "Installing mongodb service"
cp configs/mongodb.repo etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y

mongo --host catalogue.antodevops20.com </app/schema/catalogue.js