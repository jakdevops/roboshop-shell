log=/tmp/roboshop.log
func_systemd() {
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}

}
func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msucess \e[0m"
    else
      echo -e "\e[34mfailure \e[0m"
fi
}
func_schema_setup() {
    if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install mongodb client >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    yum install mongodb-org-shell -y &>>${log}
    func_exit_status

    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> configure schema >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    mongo --host mongodb.jakdevops.online </app/schema/${component}.js &>>${log}
    func_exit_status
    fi

    if [ "${schema_type}" == "mysql" ]; then
      echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install my sql client  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
        yum install mysql -y &>>${log}
        func_exit_status

        echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> load schema  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
        mysql -h mysql.jakdevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
        func_exit_status
        fi

}
func_appreq()
{
  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create service file >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service
  func_exit_status

    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application user >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    id roboshop &>>${log}
    if [ $? -ne 0 ];then
    useradd roboshop &>>${log}
    fi
    func_exit_statusk

    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> clean up old application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    rm -rf /app &>>${log}
    func_exit_status

    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create application directory >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    mkdir /app &>>${log}
    func_exit_status

    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download the application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
    func_exit_status

    echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> extract application content >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app

}

func_nodejs () {


  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create ${component} service file  >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &&>>${log}
  func_exit_status

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create mongodb repo file >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs repos >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  func_exit_status

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install nodejs >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  yum install nodejs -y &>>${log}
  func_exit_status

  func_appreq

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> download nodejs dependencies >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  npm install &>>${log}
  func_exit_status


func_schema_setup

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> start the user service  >>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a ${log}
  func_systemd

}

func_java() {
  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create ${component} service file  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Install maven  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  yum install maven -y &>>${log}
  func_exit_status


  func_appreq

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> build dependencies  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit_status



  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> start the service  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  func_systemd
}

func_python() {


 echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> install python   >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_exit_status

  func_appreq

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> python dependenceis  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status

  func_systemd

}

func_golang() {

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> create the service file  >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
func_exit_status

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Install go lang >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  yum install golang -y &>>${log}
  func_exit_status

  func_appreq

  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> Download dependencies >>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  cd /app
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}
  func_exit_status

  func_systemd
}


