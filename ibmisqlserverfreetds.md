# Connecting to Microsoft SQL Server from IBM i Using ODBC and FreeTDS

IBM i Open Source Developers can now connect directly to SQL Server using the FreeTDS Libraries and ODBC

Overview from the FreeTDS site: http://www.freetds.org

FreeTDS is a set of libraries for Unix and Linux that allows your programs to natively talk to Microsoft SQL Server and Sybase databases.

Technically speaking, FreeTDS is an open source implementation of the TDS (Tabular Data Stream) protocol used by these databases for their own clients. It supports many different flavors of the protocol and three APIs to access it. Additionally FreeTDS works with other software such as Perl and PHP, providing access from those languages as well.

**FreeTDS has many possible uses.** It has been used by Unix/Linux webservers to present data stored in SQL Server to the web, to port SQL Server database code from NT to Unix, to import data into SQL Server from a Unix source, and to provide database access on platforms (such as realtime systems) that have no native drivers.

# IBM i Prerequisites for FreeTDS

Make sure open source package Management is installed on IBM i via ACS

Make sure all unixODBC yum packages installed on IBM i 

Install unixODBC packages
```
yum install unixODBC*

-or individually-

yum install unixODBC
yum install unixODBC-devel
```

Make sure you have installed the FreeTDS yum packages

Install FreeTDS packages
```
yum install freetds*

-or individually-

yum install freetds
yum install freetds-devel
yum install freetds-odbc
```

# Testing ODBC connectivity to SQL Server

For this example we're configuring a SQL Server running on Port 1433

From your favorite SSH editor (vi, nano, vscode, etc.) or a 5250 session Edit the ODBC.ini file and create a data source entry for your SQL Server. The save the file.

File Name: ```/QOpenSys/etc/odbc.ini```

Ex CL command to edit from a 5250 session: 

```edtf '/QOpenSys/etc/odbc.ini' ```

Sample entry for an SQL Server system: (Use IP address or host name)
```
[mysqlserver]                           
Driver = FreeTDS                           
Server = mysqlserver.com         
Port = 1433                                
TDS_Version = 7.2                          
```

Trying out the connection with isql from a shell session command line
```
isql -v mysqlserver user password
```

If the connection works, you should see the isql commmand line and Connected!:
```
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> 
```

Let's do a test query where we have a database named: ```testdb``` and a table named: ```names```. SQL server also puts user tables in the default: '''dbo'' schema unless you have changed something on your SQL server. 
```
select * from testdb.dbo.names
```

Results:
```
+------------+---------------------------------------------------+---------------------------------------------------+
| id         | firstname                                         | lastname                                          |
+------------+---------------------------------------------------+---------------------------------------------------+
|  1         | Robert                                            | Johnston                                          |
|  2         | Maddy                                             | Carbury                                           |
+------------+---------------------------------------------------+---------------------------------------------------+
SQLRowCount returns 2
2 rows fetched
```

**You should now be set to use the FreeTDS ODBC driver with your Python, Node, PHP or other apps. Enjoy**

# Web Links on FreeTDS
http://www.freetds.org
https://stackoverflow.com/questions/33341510/how-to-install-freetds-in-linux
