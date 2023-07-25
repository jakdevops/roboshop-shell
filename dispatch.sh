log=/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create service file >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Install go lang >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
yum install golang -y &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create user >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
useradd roboshop &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> clean up old application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    rm -rf /app &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
mkdir /app

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Download the application  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>${log}
cd /app
unzip /tmp/dispatch.zip &>>${log}

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Download dependencies >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cd /app
go mod init dispatch &>>${log}
go get &>>${log}
go build &>>${log}


echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> start the service >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable dispatch  &>>${log}
systemctl restart dispatch &>>${log}


