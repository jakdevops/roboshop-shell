log=/tmp/roboshop.log

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create catalogue service file  >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
cp catalogue.service /etc/systemd/system/catalogue.service &&>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create mongodb repo file >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
yum install nodejs -y &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application user >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
useradd roboshop &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Remove application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
rm -rf /app &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
mkdir /app &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download the application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> extract application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
cd /app
unzip /tmp/catalogue.zip &>>${log}
cd /app

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download nodejs dependencies >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
npm install &>>${log}



echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mongodb client >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> configure schema >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
mongo --host mongodb.jakdevops.online </app/schema/catalogue.js &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> start the catalogue service  >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}

