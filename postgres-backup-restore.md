# Backup and Restore PostgreSQL Database from Command Line
This document is a short guide that covers backing up and restoring Postgres databases using the ```pg_dump``` and ```pg_restore``` PostgreSQL commands. These utilities are available on Windows, Linux, Mac, IBM i and any other operating system that supports PostgreSQL.    

❗If you are an IBM i user and using PostgreSQL on i, you can find the ```PGDUMP``` and ```PGRESTORE``` CL commmand examples on the following page link listed below to integrate PostgreSQL with your traditional IBM i jobs.. These samples work in conjunction with the QShell on i utilities. https://github.com/richardschoen/QshOni/blob/master/samples   

See example usage of the ```PGDUMP``` and ```PGRESTORE``` IBM i CL command wrappers for pg_dump and pg_restore below. https://github.com/richardschoen/howtostuff/blob/master/postgres-backup-restore.md#ibm-i-cl-commands-pgdump-and-pgrestore-which-are-helpers-for-backuprestore-of-postgresql-database-on-i

❗```In my examples I am using mydatabase and mydatabase2, You would supply your own database names.```

❗I also use the ```--verbose``` switch to list operations, but this switch is optional.   

## Backup/Dump database named: mydatabase to tar file /tmp/mydatabase.tar using pg_dump
Use pg_dump to backup/dump your database in tar format with the ```-F t``` switch.   

```pg_dump -F t -d mydatabase -p 5432 -U postgres --verbose > /tmp/mydatabase.tar```     

❗If the tar file is 0 bytes, then something failed on you dump/backup operation. Otherwise the backup should have been successful with no errors. Next we will use the tar command to verify the tar file is not corrupted.

## Verify backup tar file /tmp/mydatabase.tar with tar command    
```tar -tvf /tmp/richard.tar```   

It should list your files in the tar file something like this:
```
-rw-------  0 postgres postgres 2898 Jun 22 16:45 toc.dat
-rw-------  0 postgres postgres   50 Jun 22 16:45 3192.dat
-rw-------  0 postgres postgres    5 Jun 22 16:45 3190.dat
-rw-------  0 postgres postgres 3149 Jun 22 16:45 restore.sql
```

❗If the tar file list completes successfully your tar file should technically be error-free, but no guarantees.

## Restore postgres database with the original database name and create it using pg_restore if the database does not already exist
This example restores the database: ```mydatabase``` using it's original name and also creates it on the PostgreSQL server. The ```-C``` switch auto-creates the database but you have to specify an existing database name with the ```-d``` switch or you'll get an error when restoring. So the examples I found said to use the ```-d "postgres"``` setting when using ```-C``` to create the database on restore because the ```postgres``` database should always exist.      

❗You'll notice that user ```postgres``` is the owner of the database so you may need to assign appropriate permissions after restoring the database.   

❗Make sure database doesn't exist on target system. or you'll need to drop it or rename it first in psql utility. ```DROP DATABASE mydatabase;```

```pg_restore -C -d "postgres" -p 5432 -U postgres --verbose "/tmp/mydatabase.tar"```

If there are no errors, the command completed successfully and the mydatabase PostgreSQL database should now exist.   

## Restore postgres database with the original database name and replace database contents using pg_restore when database already exists
This example restores the database: ```mydatabase``` using it's original name and also clears the existing database on the PostgreSQL server before restore. The ```--clean``` switch clears the existing database before restore. 

```pg_restore -d "mydatabase" -p 5432 -U postgres --clean --verbose "/tmp/mydatabase.tar"```

❗If the database already exists, you can use the ```--clean``` switch to clear all tables and restore the entire backup to the original database.

If there are no errors, the command completed successfully and the refreshed mydatabase PostgreSQL database should now exist with all the restored tables and other objects for the PostgreSQL database.  

## Restore backup of mydatabase database as different database: mydatabase2 using pg_restore
❗First you need to create the new mydatabase2 database as an empty database before restoring

### Create new mydatabase2 database using createdb command
Create new empty database: ```mydatabase2```

```createdb -U postgres -W mydatabase2``` 

### Restore mydatabase database from tar file as mydatabase2 using pg_restore
```pg_restore -d "mydatabase2" -p 5432 -U postgres --verbose "/tmp/mydatabase.tar"```   

If there are no errors, the command completed successfully and the mydatabase2 PostgreSQL database should now exist with all the restored tables and other objects for the PostgreSQL database that was saved in ```/tmp/mydatabase.tar```.  

## IBM i CL commands PGDUMP and PGRESTORE which are helpers for backup/restore of PostgreSQL database on i  
The PGDUMP and PGRESTORE commands are wrappers around the QSHBASH utility for running pg_dump and pg_restore to backup and restore a Postgres database on IBM i 

❗The PGDUMP and PGRESTORE CL commands and programs PGDUMPC/PGRESTOREC are located at the following link and must be created on your IBM i system.   
https://github.com/richardschoen/QshOni/blob/master/samples

❗The QShell on i library ```QSHONI``` is also a requirement to use these CL commands. 

QShell on i install info:   
https://github.com/richardschoen/QshOni

### Backup/Dump database named: mydatabase to tar file /tmp/mydatabase.tar with PGDUMP CL command
Use the PGDUMP CL command to backup/dump your database in tar format with the ```-F t``` switch.  

Example of backing up mydatabase to /tmp/mydatabase.tar via PGDUMP command which calls pg_dump   
```
PGDUMP DATABASE(mydatabase)                        
       OUTPUTFILE('/tmp/mydatabase.tar')           
       OPTIONS('-p 5432 -U postgres --verbose')           
       PROMPT(*NO)                               
       REPLACE(*YES)
```
Example of backing up mydatabase to /tmp/pgbackup directory with auto-timestamped IFS file name ```/tmp/pgbackup/mydatabase-yyyymmdd-hhmmssfff.tar``` via PGDUMP command which calls pg_dump. *DBTEMPDATETIME creates the file in the ```/tmp/pgbackup``` directory or whatever value exists in data area ```QGPL/PGBACKDIR```
```
PGDUMP DATABASE(mydatabase)                        
       OUTPUTFILE(*DBTEMPDATETIME)           
       OPTIONS('-p 5432 -U postgres --verbose')           
       PROMPT(*NO)                               
       REPLACE(*YES)
```
   
If there are no errors, the backup/dump command completed successfully and the tar file was verified.   

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar with PGRESTORE CL command if database does not exist yet
Use the PGRESTORE CL command to restore your database from a tar formatted file if it does not already exist and you want to restore it to the same or a new system.    

Example of restoring mydatabase from /tmp/mydatabase.tar via PGRESTORE command which calls pg_restore to create and restore the database.
You can specify the -C option to create the database and then just specify ```postgres``` as the database because apparently the -C switch requires an existing database when run and the ```postgres``` database always exists. Then the database ```mydatabase``` should get created and restored correctly. 
```
PGRESTORE DATABASE(postgres)                            
          INPUTFILE('/tmp/mydatabase.tar')                
          OPTIONS('-C -p 5432 -U postgres --verbose')            
          PROMPT(*YES)                                  
          DSPSTDOUT(*YES)                               
```
If there are no errors, the command completed successfully and the mydatabase PostgreSQL database should now exist.   

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar with PGRESTORE CL command if database already exists - replace
Use the PGRESTORE CL command to restore your database from a tar formatted file and replace your existing database of the same name if you want to clear and refresh an existing database from a backup.

Example of restoring mydatabase from /tmp/mydatabase.tar via PGRESTORE command which calls pg_restore to clear and overwrite existing database.
❗If the database already exists, you can use the ```--clean``` switch to clear all tables and restore the entire backup to the original database.

```
PGRESTORE DATABASE(mydatabase)                            
          INPUTFILE('/tmp/mydatabase.tar')                
          OPTIONS('-p 5432 -U postgres --clean --verbose')       
          PROMPT(*YES)                                  
          DSPSTDOUT(*YES)                               
```

If there are no errors, the command completed successfully and the refreshed mydatabase PostgreSQL database should now exist with all the restored tables and other objects for the PostgreSQL database.  

### Restore database named: mydatabase from tar file /tmp/mydatabase.tar as mydatabase2 with PGRESTORE CL command 
Use the PGRESTORE CL command to restore your database from a tar formatted file as a new name. The database with the new name must first be created. 

This example call to QSHBASH calls the PostgreSQL utility ```createdb``` to create a new empty database named: ```mydatabase2```    

```QSHONI/QSHBASH CMDLINE('createdb -U postgres  -p 5432 mydatabase2') DSPSTDOUT(*YES) PRTSPLF(CREATEDB)```

Example of restoring ```mydatabase``` from ```/tmp/mydatabase.tar``` as ```mydatabase2``` via PGRESTORE command which calls pg_restore.   
```
PGRESTORE DATABASE(mydatabase2)                        
          INPUTFILE('/tmp/mydatabase.tar')             
          OPTIONS('-p 5432 -U postgres --verbose')            
          PROMPT(*YES)                               
          DSPSTDOUT(*YES)                            
```

If there are no errors, the command completed successfully and the mydatabase2 PostgreSQL database should now exist with all the restored tables and other objects for the PostgreSQL database that was saved in ```/tmp/mydatabase.tar```.  

## Useful psql commands

### Starting psql not connected to a specific database   
```psql -U postgres -p 5432```     

### Starting psql connected to a specific database   
```psql -U postgres -p 5432 -d mydatabase```   

### List databases
```\list - list database info```

### List databse names with SQL
```SELECT datname FROM pg_database;```

### List all tables in the database that are not part of pg_catalog or information_schema schema
This is a good way to see what tables exist in the database under various schema's. Tables will normally exist in the ```public``` schema.
```
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog' AND 
schemaname != 'information_schema';
```

### Check if the selected table exists in the specified schema   
This is a good way to see what tables exist in the selected schema. This example checks for table: ```accounts``` in the ```public``` schema.
```
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname = 'public' AND 
    tablename = 'accounts';
```

## My Python Postgres Backup and Restore Scripts
Check out the following repository for a set of Python Backup and Restore scripts I created that utilize the backup and restore commands listed in this article. These scripts should work with PostgreSQL on any platform.   

Python Postgres Backup Utility    
https://github.com/richardschoen/pythonpostgresbackup

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

### Varchar and text fields with no specific length
https://dba.stackexchange.com/questions/20254/postgresql-data-type-text-vs-varchar-without-length   
https://www.sprinkledata.com/blogs/postgresql-text-vs-varchar-choosing-the-right-data-type-for-your-database   

