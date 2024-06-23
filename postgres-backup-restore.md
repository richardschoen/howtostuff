# Backup and Restore Postgres Database from Command Line

## Backup/Dump database named: mydatabase to tar file /mydatabase.tar   
```pg_dump -F t mydatabase > /tmp/mydatabase.tar```     

## Verify backup tar file   
```tar -tvf /tmp/richard.tar```   

## Restore postgres database to system with same name

Make sure database doesn't exist on target system. or drop it first in psql. ```drop database mydatabase```


## Restore backup of mydatabase database as different database: mydatabase2

## But first create the new richard2 database as empty database.

## Create richard2 database
/Applications/Postgres.app/Contents/Versions/12/bin/createdb -U postgres -W richard2

## Restore richard database as richard2
/Applications/Postgres.app/Contents/Versions/12/bin/pg_restore -d "richard2" -U postgres --verbose "/tmp/richard.tar"


# https://serverfault.com/questions/115051/how-to-restore-postgresql-database-from-tar-file

/Applications/Postgres.app/Contents/Versions/12/bin/pg_restore --dbname "richard" --verbose "/tmp/richard.tar"

# List databases
# https://www.atlassian.com/data/admin/how-to-list-databases-and-tables-in-postgresql-using-psql

\l - lists database
\c dbname - connect to database
\q - quit psql

drop database dbname
commit

## https://stackoverflow.com/questions/40784677/pg-restore-with-c-option-does-not-create-the-database

## Restore backup of richard database and create the richard database wih -C
## Specifying -d postgres is selecting a db that always exists.
/Applications/Postgres.app/Contents/Versions/12/bin/pg_restore -C -d "postgres" -U postgres --verbose "/tmp/richard.tar"

## Restore backup of richard database as richard2. 
## But first create the new richard2 database as empty database.

## Create richard2 database
/Applications/Postgres.app/Contents/Versions/12/bin/createdb -U postgres -W richard2

## Restore richard database as richard2
/Applications/Postgres.app/Contents/Versions/12/bin/pg_restore -d "richard2" -U postgres --verbose "/tmp/richard.tar"


# Postgres Backups

# https://www.dbvis.com/thetable/a-complete-guide-to-pg-dump-with-examples-tips-and-tricks/

