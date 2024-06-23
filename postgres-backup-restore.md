# Backup and Restore PostgreSQL Database from Command Line
This document is a short guide that covers backing up and restoring Postgres databases using the ```pg_dump``` and ```pg_restore``` PostgreSQL commands. These utilities are available on Windows, Linux, Mac, IBM i and any other operating system that supports PostgreSQL.    

❗If you are an IBM i user and using PostgreSQL on i, you can find the ```PGDUMP``` and ```PGRESTORE``` CL commmand examples on the following page link listed below to integrate PostgreSQL with your traditional IBM i jobs.. These samples work in conjunction with the QShell on i utilities. https://github.com/richardschoen/QshOni/blob/master/samples   

See examples of the ```PGDUMP``` and ```PGRESTORE``` IBM i CL command wrappers for pg_dump and pg_restore below.   

## Backup/Dump database named: mydatabase to tar file /tmp/mydatabase.tar using pg_dump
Use pg_dump to backup/dump your database in tar format with the ```-F t``` switch.   

```pg_dump -F t mydatabase > /tmp/mydatabase.tar```     

## Verify backup tar file /tmp/mydatabase.tar with tar command    
```tar -tvf /tmp/richard.tar```   

It should list your files in the tar file something like this:
```
-rw-------  0 postgres postgres 2898 Jun 22 16:45 toc.dat
-rw-------  0 postgres postgres   50 Jun 22 16:45 3192.dat
-rw-------  0 postgres postgres    5 Jun 22 16:45 3190.dat
-rw-------  0 postgres postgres 3149 Jun 22 16:45 restore.sql
```

## Restore postgres database with the original database name and create it using pg_restore if the database does not already exist
This examples restores the database: ```mydatabase``` using it's original name and also creates it on the PostgreSQL server. The ```-C``` switch auto-creates the database but you have to specify an existing database name with the ```-d``` switch or you'll get an error when restoring. So the examples I found said to use the ```-d "postgres"``` setting when using ```-C``` to create the database on restore because the ```postgres``` database should always exist. You'll notice that user ```postgres``` is the owner of the database so you may need to assign appropriate permissions after restoring the database.

```pg_restore -C -d "postgres" -U postgres --verbose "/tmp/mydatabase.tar"```

❗Make sure database doesn't exist on target system. or you'll need to drop it or rename it first in psql utility. ```DROP DATABASE mydatabase;```

## Restore postgres database with the original database name and replace database contents using pg_restore when database already exists
This examples restores the database: ```mydatabase``` using it's original name and also clears the existing database on the PostgreSQL server before restore. The ```--clean``` switch clears the existing database before restore. 

```pg_restore -C -d "mydatabase" -U postgres --clean --verbose "/tmp/mydatabase.tar"```

❗If the database already exists, you can use the ```--clean``` switch to clear all tables and restore the entire backup to the original database.

## Restore backup of mydatabase database as different database: mydatabase2 using pg_restore
❗First you need to create the new mydatabase2 database as an empty database before restoring

### Create new mydatabase2 database using createdb command
Create new empty database: ```mydatabase2```

```createdb -U postgres -W mydatabase2``` 

## Restore mydatabase database from tar file as mydatabase2 using pg_restore
```pg_restore -d "mydatabase2" -U postgres --verbose "/tmp/mydatabase.tar"```

## IBM i CL commands PGDUMP and PGRESTORE which are helpers for backup/restore of PostgreSQL database on i  
The PGDUMP and PGRESTORE commands are wrappers around the QSHBASH utility for running pg_dump and pg_restore to backup and restore a Postgres database on IBM i 

The PGDUMP and PGRESTORE CL commanda and programs PGDUMPC/PGRESTOREC are located at the following link and must be created on your IBM i system.   
https://github.com/richardschoen/QshOni/blob/master/samples

The QShell on i library ```QSHONI``` is also a requirement to use these CL commands. 

QShell on i install info:   
https://github.com/richardschoen/QshOni

### Backup/Dump database named: mydatabase to tar file /tmp/mydatabase.tar with PGDUMP CL command
Use the PGDUMP CL command to backup/dump your database in tar format with the ```-F t``` switch.  

Example of backing up mydatabase to /tmp/mydatabase.tar via PGDUMP command which calls pg_dump   
```
PGDUMP DATABASE(mydatabase)                        
       OUTPUTFILE('/tmp/mydatabase.tar')           
       OPTIONS('-p 5432 -U postgres')           
       PROMPT(*NO)                               
       REPLACE(*YES)
```

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar with PGRESTORE CL command if database does not exist yet
Use the PGRESTORE CL command to restore your database from a tar formatted file if it does not already exist and you want to restore it to the same or a new system.    

Example of restoring mydatabase from /tmp/mydatabase.tar via PGRESTORE command which calls pg_restore to create and restore the database.
You can specify the -C option to create the database and then just specify ```postgres``` as the database because apparently the -C switch requires an existing database when run and the ```postgres``` database always exists. Then the database ```mydatabase``` should get created and restored correctly. 
```
PGRESTORE DATABASE(postgres)                            
          INPUTFILE('/tmp/mydatabase.tar')                
          OPTIONS('-C -p 5432 -U postgres')            
          PROMPT(*YES)                                  
          DSPSTDOUT(*YES)                               
```

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar with PGRESTORE CL command if database already exists - replace
Use the PGRESTORE CL command to restore your database from a tar formatted file and replace your existing database of the same name if you want to clear and refresh an existing database from a backup.

Example of restoring mydatabase from /tmp/mydatabase.tar via PGRESTORE command which calls pg_restore to clear and overwrite existing database.
❗If the database already exists, you can use the ```--clean``` switch to clear all tables and restore the entire backup to the original database.

```
PGRESTORE DATABASE(mydatabase)                            
          INPUTFILE('/tmp/mydatabase.tar')                
          OPTIONS('-p 5432 -U postgres --clean')       
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

