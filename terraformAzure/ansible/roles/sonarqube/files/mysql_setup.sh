#!/bin/bash
logit() {
    while read LINE
    do
        LOGFILE=/var/log/sonar_mysql_ansible.log
        STAMP=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$STAMP       $LINE" >> $LOGFILE
    done
}
set -x
((
##################################### USER  DATA START ############################################

mysql -e 'CREATE DATABASE sonarqube_db;'
mysql -e "CREATE USER 'sonarqube_user'@'localhost' IDENTIFIED BY 'admin@123';"
mysql -e "GRANT ALL PRIVILEGES ON sonarqube_db.* TO 'sonarqube_user'@'localhost' IDENTIFIED BY 'admin@123';"
mysql -e "FLUSH PRIVILEGES;"


##################################### USER DATA END #######################################
) 2>&1)  | logit




