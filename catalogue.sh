cp catalogue.service /etc/systemd/system/catalgoue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install

systemctl daemon-reload

yum install mongodb-org-shell -y
mongo --host mongodb.jakdevops.online </app/schema/catalogue.js

systemctl enable catalogue
systemctl restart catalogue

