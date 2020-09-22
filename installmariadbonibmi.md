# Install and configure MariaDB DB Server on IBM i - DRAFT

Install MariaDB yum packages from IBM i ACS Open Source Package Management
```
Package list:
mariadb   (Not available on IBM repo yet. Install from downloads via yum install mariadb*) 
mariadb-server
```
Log in to SSH as IBM i QSECOFR level user to do server setup.

If not started, start the bash shell by typing ***bash*** unless bash is already your default shell. 

Run the following shell command line sequence to initialize MariaDB database in the /postgres IFS directory location
```
/QOpenSys/pkgs/bin/mysql_install_db --user=mysql
```

Set root user password as desired with your own password. (Replace yourpassword with the desired password.)
```
/QOpenSys/pkgs/bin/mysqladmin mysqladmin -u root password yourpassword
```

***Do not start server yet until after you modify /QOpenSys/etc/mariadb/server.cnf***

Use nano editor, vim or other editor to edit ***/QOpenSys/etc/mariadb/server.cnf*** file so the server will listen on TCP/IP addresses. We will enable access on all IP addresses.
```
edit /QOpenSys/etc/mariadb/server.cnf
uncomment #bind-address=0.0.0.0 so it looks like: bind-address=0.0.0.0
save server.cnf
```
***For a more secure server only listen on IP address 127.0.0.1/localhost***

Run the following command to start MariaDB database server daemon.
```
cd /QOpenSys/pkgs ; /QOpenSys/pkgs/bin/mysqld_safe --datadir='/QOpenSys/var/lib/mariadb/data'
```
***The server start will lock up the terminal window so you may want to submit the job from a submitted job on the IBM i - SAMPLE TODO***

***the mysqld starts as a background thread job so you can probably just close the terminal session also. (TBD)***

This following command can be used from any bash session to stop the server.
```
/QOpenSys/pkgs/bin/mysqladmin -u root -p shutdown
Enter password: ********
```

From a 5250 session, run WRKACTJOB and you should see the active server jobs and threads in the QUSRWRK subsystem
```
--------------------------------------------------------------------------------
QP0ZSPWP     RICHARD     BCI      .0  PGM-mysqld       SELW 
--------------------------------------------------------------------------------
```

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

Allow remote access to server from any host for the MariaDB root user for development using mysql command.
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

use nano editor, vim or other editor to edit ***/QOpenSys/etc/mariadb/server.cnf*** file 

Change port number or add a port entry under the ***[mysqld]*** section in ***server.cnf***

```
Change port number or add a port entry under [mysqld] section:

[mysqld]
port = 3306 

save server.cnf
```

Stop and restart MariaDB server and it should listen on the new port.

Now refer to standard MariaDB documentation as needed. 

# Links

MariaDB Site

http://www.mariadb.com/

MariaDB Knowledgebase

http://mariadb.com/kb

MariaDB Documentation

https://mariadb.com/kb/en/documentation/
