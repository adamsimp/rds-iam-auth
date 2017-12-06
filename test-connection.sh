#! /bin/bash

# edit the values below
USERNAME=your_username
SQL_HOST=rds_hostname
REGION=your_region

mysql -u $USERNAME -h $_SQL_HOST \
--password=`aws rds generate-db-auth-token --hostname $SQL_HOST \
--port 3306 \
--username $USERNAME \
--region $REGION` \
--ssl-ca=~/rds-ssl/rds-combined-ca-bundle.pem \
--enable-cleartext-plugin
