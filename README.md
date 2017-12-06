###### These are just notes for me to look back on and are in no way complete. Please read the official documenatation as well. http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html

## Create MySQL User
```
mysql> CREATE USER '<DB_USERNAME>' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS';
mysql> GRANT ALL PRIVILEGES ON <DB_NAME>.* TO ''<DB_USERNAME>'@'%';
mysql> FLUSH PRIVILEGES;
```

## Find DbiResourceId of your RDS instance(s)
run this command below to list the DbiResourceIds in your account, quickly scan throuh it to find the correct one for the database you're working on. It begins with _*db-*_
```
$ aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier,DbiResourceId]"
```

## Edit IAM role for your instance/function to include something like this.
###### Edit ACCOUNT_NUMBER, DBIRESOURCEID, DB_USERNAME
```
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
             "rds-db:connect"
         ],
         "Resource": [
             "arn:aws:rds-db:us-east-1:ACCOUNT_NUMBER:dbuser:DBIRESOURCEID/DB_USERNAME"
         ]
      }
   ]
}
```

## Grab the RDS CA Bundle. This is used for clear text authentication over SSL.
```
$ mkdir -p ~/rds-ssl
$ curl -o ~/rds-ssl/rds-combined-ca-bundle.pem https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
```

# Create the MySQL client configuration file
```
cat <<EOT >> ~/.my.cfn
[client]
ssl-ca = ~/rds-ssl/rds-combined-ca-bundle.pem
EOT
```

# The moment of truth...
Edit and use [test-connection.sh](/test-connection.sh) to verify functionality.
