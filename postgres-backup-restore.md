# Backup and Restore Postgres Database from Command Line
This document covers backing up and restoring Postgres databases.   

If you are an IBM i user and using Postgres on i, you can find the ```pgdump``` and ```pgrestore`` CL commmand examples on the following page. These samples work in conjunction with the QShell on i utilizies.   
https://github.com/richardschoen/QshOni/blob/master/samples   

## Backup/Dump database named: mydatabase to tar file /tmp/mydatabase.tar
Use pg_dump to backup/dump your database in tar format wiuth the ```-F t``` switch.   

```pg_dump -F t mydatabase > /tmp/mydatabase.tar```     

## Verify backup tar file /tmp/mydatabase.tar   
```tar -tvf /tmp/richard.tar```   

It should list your files in the tar file something like this:
```
-rw-------  0 postgres postgres 2898 Jun 22 16:45 toc.dat
-rw-------  0 postgres postgres   50 Jun 22 16:45 3192.dat
-rw-------  0 postgres postgres    5 Jun 22 16:45 3190.dat
-rw-------  0 postgres postgres 3149 Jun 22 16:45 restore.sql
```

## Restore postgres database to with the same database name
This examples restores the database: ```mydatabase``` using it's original name and also creates it on the PostgreSQL server. The ```-C``` switch auto-creates the database but you have to specify an existing database name with the ```-d``` switch or you'll get an error when restoring. So the examples I found said to use the ```-d "postgres"``` setting when using ```-C``` to create the database on restore because the ```postgres``` database should always exist. You'll notice that user ```postgres``` is the owner of the database so you may need to assign appropriate permissions after restoring the database.

```pg_restore -C -d "postgres" -U postgres --verbose "/tmp/mydatabase.tar"```

❗Make sure database doesn't exist on target system. or you'll need to drop it or rename itfirst in psql. ```drop database mydatabase```


## Restore backup of mydatabase database as different database: mydatabase2
❗First you need to create the new mydatabase2 database as an empty database before restoring

### Create mydatabase2 database
Create new empty database: ```mydatabase2```

```createdb -U postgres -W mydatabase2``` 

## Restore mydatabase database from tar file as mydatabase2
```pg_restore -d "mydatabase2" -U postgres --verbose "/tmp/mydatabase.tar"```

## IBM i CL commands PGDUMP and PGRESTORE which are helpers for backup/restore of PostgreSQL database on i  
The PGDUMP and PGRESTORE commands are wrappers around the QSHBASH utility for running pg_dump and pg_restore to backup and restore a Postgres database on IBM i 

PGDUMP CL command and program PGDUMPC are located here and must be created on your IBM i system. QShell on i library ```QSHONI``` is also a requirement to use these CL commands. 
https://github.com/richardschoen/QshOni/blob/master/samples

QShell on i install info:   
https://github.com/richardschoen/QshOni

### Backup/Dump database named: mydatabase to tar file /tmp/mydatabase.tar with PGDUMP CL command
Use the PGDUMP CL command to backup/dump your database in tar format wiuth the ```-F t``` switch.  

Example of backing up mydatabase to /tmp/mydatabase.tar via PGDUMP command which calls pg_dump   
```
PGDUMP DATABASE(mydatabase)                        
       OUTPUTFILE('/tmp/mydatabase.tar')           
       OPTIONS('-p 5432 -U postgres')           
       PROMPT(*NO)                               
       REPLACE(*YES)
```

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar with PGRESTORE CL command if it does not exist yet
Use the PGRESTORE CL command to restore your database from a tar formatted file if it does not already exist. 

If the database already exists

Example of restoring mydatabase from /tmp/mydatabase.tar via PGRESTORE command which calls pg_restore.   
When run you specify the -C option to create the database and specify postgres as the database. Then mydatabase should get restored and auto-created. 
```
PGRESTORE DATABASE(postgres)                            
          INPUTFILE('/tmp/mydatabase.tar')                
          OPTIONS('-C -p 5432 -U postgres')            
          PROMPT(*YES)                                  
          DSPSTDOUT(*YES)                               
```

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar as mydatabase2 with PGRESTORE CL command 
Use the PGRESTORE CL command to restore your database from a tar formatted file as a new name. The database with the new name must first be created. 

This example calls createdb to create a new empty database named: mydatabase2   
```QSHONI/QSHBASH CMDLINE('createdb -U postgres  -p 55432 mydatabase2') DSPSTDOUT(*YES) PRTSPLF(CREATEDB)```

Example of restoring mydatabase from /tmp/mydatabase.tar as mydatabase2 via PGRESTORE command which calls pg_restore.   
When run you specify the -C option to create the database and specify postgres as the database. Then mydatabase should get restored and auto-created. 
```
PGRESTORE DATABASE(mydatabase2)                        
          INPUTFILE('/tmp/mydatabase.tar')             
          OPTIONS('-p 5432 -U postgres')            
          PROMPT(*YES)                               
          DSPSTDOUT(*YES)                            
```

## Misc / Reading Links

### Backup and Restore of PostgreSQL Database   
https://www.tecmint.com/backup-and-restore-postgresql-database    

### Restoring from a tar file  
https://serverfault.com/questions/115051/how-to-restore-postgresql-database-from-tar-file

### psql commmands
https://www.atlassian.com/data/admin/how-to-list-databases-and-tables-in-postgresql-using-psql   

```
\l - lists database
\c dbname - connect to database
\q - quit psql
```

### Dropping a database in psql  
```
drop database dbname   
commit
```

### Problems with the -C option on restore  
https://stackoverflow.com/questions/40784677/pg-restore-with-c-option-does-not-create-the-database

### Postgres Backups  
https://www.dbvis.com/thetable/a-complete-guide-to-pg-dump-with-examples-tips-and-tricks/

