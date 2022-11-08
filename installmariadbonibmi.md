# Install and configure MariaDB Database Server on IBM i

Install MariaDB yum packages from IBM i ACS Open Source Package Management
```
Package list:
mariadb   
mariadb-server
```

# Connecting via SSH terminal to complete install process
Log in to SSH as IBM i QSECOFR level user to do server setup.

If not started, start the bash shell by typing ***bash*** unless bash is already your default shell. 

# Setting the IP binding address and TCP port for the MariaDB server in my.cnf config file

## This step must be done before starting the server for the first time

Use nano editor, vim or other editor to edit ***/QOpenSys/etc/mariadb/my.cnf*** file so the server will listen on TCP/IP addresses. We will enable access on all IP addresses. Also make a change to prevent problems with the `my.cnf.d` directory. If you prefer using the green screen you can use the following CL command to edit the configuration file: ```EDTF '/QOpenSys/etc/mariadb/my.cnf'```

Edit ***/QOpenSys/etc/mariadb/my.cnf***
Add the [mysqld] directive and the following 2 entries: bind-address and port:

```
[mysqld]
bind-address=0.0.0.0 
port=3306
```
Comment out the `!includedir` directive to prevent a startup error if the `/QOpenSys/etc/mariadb/my.cnf.d` directory is missing. This directory can get deleted on startup when it's empty, then causing an error if `!includedir` requires it.
```
#!includedir /QOpenSys/etc/mariadb/my.cnf.d             
```

Save the my.cnf file

***For a more secure server only listen on IP address 127.0.0.1/localhost***

**Also, the default port is 3306. I often change to a non-standard port like 33306 instead.**

Example of what your actual ***/QOpenSys/etc/mariadb/my.cnf*** will look like after adding the bind-address and port entries.
```
#                                                      
# This group is read both by the client and the server 
# use it for options that affect everything            
#                                                      
[client-server]                                        
                                                       
#                                                      
# include *.cnf from the config directory              
# Comment out this directive if my.cnf.d is empty                                                     
#!includedir /QOpenSys/etc/mariadb/my.cnf.d             
                       
[mysqld]                       
bind-address=0.0.0.0                                   
port = 3306                                           
```

# First time database initialization in directory: /QOpenSys/var/lib/mariadb/data

Run the following shell command line sequence to initialize the MariaDB database in directory: ***/QOpenSys/var/lib/mariadb/data***
```
/QOpenSys/pkgs/bin/mysql_install_db
```

# Starting the MariaDB server job - mysqld

Run the following mysqld_safe command to start MariaDB database server daemon. The server must be started before using the ***mysqladmin*** command to perform actions.
https://dev.mysql.com/doc/refman/8.0/en/mysqld-safe.html

```
cd /QOpenSys/pkgs ; /QOpenSys/pkgs/bin/mysqld_safe --datadir=/QOpenSys/var/lib/mariadb/data
```
***The MariaDB mysqld server startup will lock up the terminal window so you may want to start the MariaDB server job from a submitted job on the IBM i or possibly using the QSHEXEC command which is part of the QSHONI library (if you have it installed)*** https://github.com/richardschoen/qshoni

***Since the MariaDB mysqld server starts as a background thread job and locks up the terminal windows, you can probably just close the SSH/bash terminal window and the mysqld server daemon will stay running. (Need to Test)***

# Setting the MariaDB root user password after starting server for the first time
The server must be running before setting the new root user password and using the mysqladmin command.

***First open a new SSH/bash terminal window (if you haven't already done so)*** since starting the server took over your previous terminal session and you also may have closed the previous terminal session as noted above since mysqld starts as a background job.

Set root user password as desired with your own password. (Replace yournewpassword with the actual desired password.)
```
/QOpenSys/pkgs/bin/mysqladmin -u root password yournewpassword
```

# Stopping the MariaDB server job - mysqld

The following command can be used from any bash session to stop the server. Make sure to specify your root user and yourpassword when shutting down the server
```
/QOpenSys/pkgs/bin/mysqladmin  --no-defaults --user=root --password=yourpassword shutdown
```

# Checking for active MariaDB server instance

From a 5250 session, run the ***WRKACTJOB*** command or to be more specific to PASE jobs run ***WRKACTJOB SBS(QUSRWRK) JOB(QP0ZSPWP)*** and you should see the active server jobs and threads in the QUSRWRK subsystem. The entry below shows what you should see if the MariaDB server is running. 
```
--------------------------------------------------------------------------------
QP0ZSPWP     RICHARD     BCI      .0  PGM-mysqld       SELW 
--------------------------------------------------------------------------------
```

# Checking for active MariaDB server port

From a 5250 session, run the ***NETSTAT *CNN*** command to verify the server is listening on port 3306. You should see an entry for Local Port 3306 which tells you the server is listening for connections. 
```
--------------------------------------------------------------------------------
                        Work with IPv4 Connection Status                   
                                                             System:   SYS
 Type options, press Enter.                                                
   3=Enable debug   4=End   5=Display details   6=Disable debug            
   8=Display jobs                                                          
                                                                           
      Remote           Remote     Local                                    
 Opt  Address          Port       Port       Idle Time  State              
      *                *          3306       000:05:22  Listen             
--------------------------------------------------------------------------------
```

# Allow remote user access for MariaDB database development

:round_pushpin: By default all MariaDB server access can only be done from apps running natively on the IBM i server using the localhost host name or 127.0.0.1 IP address.

You can allow remote access to the MariaDB server from any host for the MariaDB root user or other users ***for development*** by running the ***mysql*** PASE command and a few related SQL commands. Make sure you know your MariaDB root user and password. You will be prompted for your password when you run the ***mysql*** command.
```
/QOpenSys/pkgs/bin/mysql -u root -p
```
After login to the mysql command line app, run the following SQL commands to allow access to the MariaDB instance from toolsets outside of localhost/127.0.0.1. ***Later for security purposes you can revoke this access so only the IBM i apps can access the MariaDB server.*** 
```
use mysql;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'YourPassword';
```
If desired, run the following SQL query to see all the access entries for the MariaDB server. You should see the ***root*** user entry with a wildcard ***%*** for the host which means it should be able to access the server from anywhere.
```
select host,user from user; 
```
The following results should show
```
+---------------------------------+------+
| host                            | user |
+---------------------------------+------+
| %                               | root |
| 127.0.0.1                       | root |
| ::1                             | root |
| localhost                       |      |
| localhost                       | root |
| myibmi.com                      |      |
| myibmi.com                      | root |
+---------------------------------+------+
```

***Note: If you have trouble connecting to the MariaDB instance from another computer after changing this setting, you may need to Stop and restart the MariaDB server after the permission change.***

Use Heidi, DBeaver or other MySQL/MariaDB client to connect to MariaDB database. 
```
Host: IBMi host name or IP
Port: 3306
User: root
Password: yourpassword
```

# Changing the MariaDB listening port to something other than 3306

If desired, change the port that MariaDB server listens on to something other than 3306. This can be useful if you want to run multiple versions of MariaDB or you already have another MySql server running on your IBM i system.

use nano editor, vim or other editor to edit ***/QOpenSys/etc/mariadb/my.cnf*** file 

Change port number or add a port entry in ***my.cnf***

```
Change port number or add a port entry:

port = 3306 

save my.cnf
```

Stop and restart MariaDB server and it should listen on the new port.

Now refer to standard MariaDB documentation as needed. 

# MariaDB Server Security - IMPORTANT

This document is mainly a quick getting started document for testing and development. 

This document does not cover all production best practices, but listed below are a few suggestions. Security best practices should be discussed and addressed with your security team or by researching MySql/MariaDB security best practices. 

Listed below are a few things that I can think of top of mind for keeping your MariaDB data safe:
* Limit access to the MariaDB data directories from the IFS. Perhaps create a MYSQL or MARIADB IBM i user that has access to the data directory ***/QOpenSys/var/lib/mariadb/data*** only and limit that users authority. Then when starting the MariaDB server submit the startup job as the MYSQL/MARIDB user to job queue QSYSNOMAX.
* Make sure server is only listening on localhost/127.0.0.1
* Make sure you've established a root password, but don't use it for production apps.
* Create application MariaDB users/password so the root user does not get exposed.
* Back up your MariaDB server regularly using one of the methods below.
  * Stop server and back up your MariaDB data directory regularly. ***/QOpenSys/var/lib/mariadb/data***
  * Or leave MariaDB server running and use accepted MySql/MariaDB backup procedures. There are 3rd party MariaDB/MySQL backup tools available or you can use the ***mysqldump*** command. Search for ***mysql data backup*** or here's a sample link: https://serverguy.com/servers/how-to-backup-mysql-database

# Submitting MariaDB Server Startup via QSHEXEC CL Command
The mysqld server startup command can be submitted to job queue QSYSNOMAX and will run in the QUSRWRK subsystem unless your IBM i is configured differently. The server job needs to be submitted to a multi-threaded subsystem so QSYSMOAX/QUSRWRK is the perfect combination. After submitting you can use the WRKACTJOB and NETSTAT example above to see if the server jobs and ports are active.

The QSHEXEC command can be used to call QSH/PASE jobs from a regular IBM i job and handles all the threading set up and log capture. https://www.github.com/richardschoen/qshoni

```
SBMJOB CMD(QSHONI/QSHEXEC             
 CMDLINE('/QOpenSys/pkgs/bin/mysqld_safe 
 --datadir=/QOpenSys/var/lib/mariadb/data') 
 PRTSTDOUT(*YES) PRTSPLF(STRMARIADB)) 
 JOB(STRMARIADB) JOBQ(QSYSNOMAX) JOBMSGQFL(*WRAP)
```

# Submitting MariaDB Server Shutdown/End via QSHEXEC CL Command
The mysqld server shutdown can be run interactively or submitted to job queue QSYSNOMAX and will run in the QUSRWRK subsystem unless your IBM i is configured differently. Make sure to specify your MariaDB root user and password. This job will typically only run a few seconds so it could be run without SBMJOB if desired. A shutdown operation can be delayed if there are several client threads connected to the MariaDB instance so you might need to explore other possible shutdown options such as killing the process using its process id if you have regular issues shutting down your MariaDB server. However shutting down a process via the kill command or ```ENDJOB *IMMED``` on the IBM i can cause data corruption if a server is shutdown while transactions are running.

```
SBMJOB CMD(QSHONI/QSHEXEC 
  CMDLINE('/QOpenSys/pkgs/bin/mysqladmin --no-defaults 
  --user=root --password=YourPassword shutdown') 
  SETPKGPATH(*YES) PRTSTDOUT(*YES) PRTSPLF(ENDMARIADB))                                 
  JOB(ENDMARIADB) JOBQ(QSYSNOMAX) JOBMSGQFL(*WRAP)                                          
```

# Hard Kill the MariaDB mysqld Instance Immediately
If you want to kill your MariaDB instance by using its process id file, locate the mysqld instance process id file in directory ***/QOpenSys/var/lib/mariadb/data***.

The file name will have a .pid extension and a name which will most likely match your IBM i system host name. 

In this example we are trying to kill the mysqld server on a server named: ***youribmihostname.com*** so the .pid file name will be: ***youribmihostname.com.pid***

If you are more comfortable doing an ENDJOB command from a regular IBM i 5250 session, do a WRKACTJOB to identify the mysqld job as mentioned above and do an ```ENDJOB *IMMED``` to kill the running MariaDB server instance immediately.

```
kill ```cat /QOpenSys/var/lib/mariadb/data/youribmihostname.com.pid```
```

# Links

MariaDB Site

http://www.mariadb.com/

MariaDB Knowledgebase

http://mariadb.com/kb

MariaDB Documentation

https://mariadb.com/kb/en/documentation/

Tutorial Link

https://powerwire.eu/hello-maria


