echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create catalogue service file  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create mongodb repo file >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
yum install nodejs -y

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application user >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Remove application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
rm -rf /app

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
mkdir /app

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download the application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> extract application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download nodejs dependencies >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
npm install

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> restart the service  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mongodb client >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> configure schema >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
mongo --host mongodb.jakdevops.online </app/schema/catalogue.js

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> start the service >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable catalogue
systemctl restart catalogue

