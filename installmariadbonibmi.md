# Install and configure MariaDB DB Server on IBM i

Install MariaDB yum packages from IBM i ACS Open Source Package Management
```
Package list:
mariadb   
mariadb-server
```
Log in to SSH as IBM i QSECOFR level user to do server setup.

If not started, start the bash shell by typing ***bash*** unless bash is already your default shell. 

# Setting the IP binding address and TCP port for the MariaDB server in my.cnf config file

Use nano editor, vim or other editor to edit ***/QOpenSys/etc/mariadb/my.cnf*** file so the server will listen on TCP/IP addresses. We will enable access on all IP addresses.

Edit /QOpenSys/etc/mariadb/my.cnf
Add following 2 entries: bind-address and port:

```
bind-address=0.0.0.0 
port=3306
```
Save the my.cnf file

***For a more secure server only listen on IP address 127.0.0.1/localhost***

Example of what your actual /QOpenSys/etc/mariadb/my.cnf will look like after adding the bind-address and port entries.
```
#                                                      
# This group is read both by the client and the server 
# use it for options that affect everything            
#                                                      
[client-server]                                        
                                                       
#                                                      
# include *.cnf from the config directory              
#                                                      
!includedir /QOpenSys/etc/mariadb/my.cnf.d             
                                                       
bind-address=0.0.0.0                                   
port = 33306                                           
```

# First time database initialization in directory: /QOpenSys/var/lib/mariadb/data

Run the following shell command line sequence to initialize the MariaDB database in directory: /QOpenSys/var/lib/mariadb/data
```
/QOpenSys/pkgs/bin/mysql_install_db
```

# Starting the MariaDB server job - mysqld

Run the following mysqld_safe command to start MariaDB database server daemon. The server must be started before using the ***mysqladmin*** command to perform actions.
https://dev.mysql.com/doc/refman/8.0/en/mysqld-safe.html

```
cd /QOpenSys/pkgs ; /QOpenSys/pkgs/bin/mysqld_safe --datadir=/QOpenSys/var/lib/mariadb/data
```
***The bash server start will lock up the terminal window so you may want to start the MariaDB server job from a submitted job on the IBM i - (SAMPLE TODO)***
***Since the mysqld starts as a background thread job you can probably just close the SSH/bash terminal windows and the mysqld server daemon will stay running. (Need to Test)***

# Setting the MariaDB root user password after starting server for the first time
The server must be running before setting the new root user password and using the mysqladmin command.

Set root user password as desired with your own password. (Replace yournewpassword with the actual desired password.)
```
/QOpenSys/pkgs/bin/mysqladmin -u root password yournewpassword
```

# Stopping the MariaDB server job - mysqld

The following command can be used from any bash session to stop the server. Make sure to specify your root user and yourpassword when shutting down the server
```
/QOpenSys/pkgs/bin/mysqladmin  --no-defaults --user=root --password=yourpassword shutdown
```

# Checking for active MariadDB server instance

From a 5250 session, run WRKACTJOB and you should see the active server jobs and threads in the QUSRWRK subsystem
```
--------------------------------------------------------------------------------
QP0ZSPWP     RICHARD     BCI      .0  PGM-mysqld       SELW 
--------------------------------------------------------------------------------
```

# Checking for active MariadDB server port

From a 5250 session, run "NETSTAT *CNN" to verify the server is listening on port 3306. You should see an entry for Local Port 3306 which tells you the server is listening for connections. 
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

Allow remote access to server from any host for the MariaDB root user ***for development*** using mysql command.
```
mysql -u root -p
use mysql;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'YourPassword';
select host,user from user;   (Wildcard should show)
```
***Note: If this setting does not work, you may need to Stop and restart the MariaDB server after this change.***

Use Heidi, DBeaver or other MySQL/MariaDB client to connect to MariaDB database. 
```
Host: IBMi host name or IP
Port: 3306
User: root
Password: yourpassword
```

If desired, change the port that MariaDB server listens on to something other than 3306.

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
This is a quick getting started document for testing and development. 

This document does not cover production best practices. Best practices should be addressed with your security team or by researching MySql/MariaDB security best practices. 

# Links

MariaDB Site

http://www.mariadb.com/

MariaDB Knowledgebase

http://mariadb.com/kb

MariaDB Documentation

https://mariadb.com/kb/en/documentation/

Tutorial Link

https://powerwire.eu/hello-maria
