#!/bin/bash
ID=$(id -u)
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
    echo -e "$2 ...$R FAILED $N"
    exit 1
    else
    echo -e " $2... $G SUCCESS $N"
fi }
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "script started executing at $TIMESTAMP" &>> $LOGFILE

if [ $ID -ne 0 ]
then 
echo -e "$R Error: : Please run the script without root user $N"
exit    1
else
echo -e "$G Your a root user $N"
fi #reverse of if condition

cp monog.repo /etc/yum.repos.d/mongo.repo  &>> $LOGFILE
VALIDATE $? "Copied MONGODB Repository"

dnf install mongodb-org -y  &>> $LOGFILE
VALIDATE $? "Installing Mongodb"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabling Mongodb"

systemctl start mongod  &>> $LOGFILE
VALIDATE $? "Starting Mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Remote access to Mongodb"

systemctl restart mongod  &>> $LOGFILE
VALIDATE $? "Restarting Mongodb"
