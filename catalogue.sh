echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create catalogue service file  >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service &&>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create mongodb repo file >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application user >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Remove application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download the application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> extract application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download nodejs dependencies >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
npm install &>>/tmp/roboshop.log



echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mongodb client >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> configure schema >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.jakdevops.online </app/schema/catalogue.js &>>/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> start the catalogue service  >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log

