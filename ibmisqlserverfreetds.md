# Connecting to Microsoft SQL Server from IBM i Using FreeTDS

IBM i Open Source Developers can now connect directly to SQL Server using the FreeTDS Libraries and ODBC

Overview from the FreeTDS site: http://www.freetds.org

FreeTDS is a set of libraries for Unix and Linux that allows your programs to natively talk to Microsoft SQL Server and Sybase databases.

Technically speaking, FreeTDS is an open source implementation of the TDS (Tabular Data Stream) protocol used by these databases for their own clients. It supports many different flavors of the protocol and three APIs to access it. Additionally FreeTDS works with other software such as Perl and PHP, providing access from those languages as well.

If you are looking for a Java implementation, we refer you to the jTDS project on SourceForge.

FreeTDS has many possible uses. It has been used by Unix/Linux webservers to present data stored in SQL Server to the web, to port SQL Server database code from NT to Unix, to import data into SQL Server from a Unix source, and to provide database access on platforms (such as realtime systems) that have no native drivers.

# IBM i Prerequisites

Make sure open source package Management is installed on IBM i

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

# Web Links on FreeTDS
http://www.freetds.org
https://stackoverflow.com/questions/33341510/how-to-install-freetds-in-linux
