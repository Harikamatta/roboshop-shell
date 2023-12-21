#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
    echo "$2 .. $R FAILED $N "
    exit 1
    else
    echo "$2 .. $G SUCCESS $N"
fi 
}

if [ $ID -ne 0 ]
    then 
    echo "$R Error: : Please ru nthe script with root access $N "
    exit 1
    else
    echo "$G root user $N"
fi 
dnf install python36 gcc python3-devel -y &>> $LOGFILE
VALIDATE $? "Installing python"

id roboshop
if [ $ID -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else 
echo "roboshop user already exist $Y SKIPPING $N"
fi

mkdir /app &>> $LOGFILE
VALIDATE $? "creating a directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>> $LOGFILE
VALIDATE $? "Downlaoding payment application"

cd /app 
unzip -o /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "Unzipping payment application"

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "Downlaoding dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE $? "Copying payment file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "payment Daemon Reload"

systemctl enable payment  &>> $LOGFILE
VALIDATE $? "Enabling payment"

systemctl start payment &>> $LOGFILE
VALIDATE $? ""Starting payment" 