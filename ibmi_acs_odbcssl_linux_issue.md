# How to set up IBM i Access ODBC Driver for Linux to use an SSL Certificate 
```This article is not a full tutorial on setting up SSL on your IBM i. It covers the issue I had after SSL was set up and ODBC still was giving the CWBCO1050 certificate not trusted error on Linux.```

Installing and using the ```IBM i Access Client Solutions``` Java based software (which provides 5250, File Transfer IFS, Run SQL utilities, etc) and the Linux ODBC driver which is installed with the ```ACS Linux App Pkg``` is usually a pretty easy process.    

There are two separate installers for: ```IBM i Access Client Solutions``` and ```ACS Linux App Pkg``` available from the following download site if you have an IBM login:    
https://www.ibm.com/support/pages/ibm-i-access-client-solutions   

After installation and configuration you can usually configure a Telnet session with Access Client Solutions or create and use an ODBC data source without issues.   

***Until you want to use SSL to connect to your database via ODBC instead of unsecured access......***

I was trying to set up my IBM i Access ODBC Driver with SSL on a Linux machine and every time I ran:   
```cwbping mysysname /ssl:1``` to test SSL connectivity for the ODBC driver I got the following error: ```Error message CWBCO1050 - "The system certificate is not trusted".``` I got the same errors from the isql utility if I defined an ODBC data source with the ```SSL=1``` setting. Ex isql command to connect: ```isql -v mysysname user1 pass1```  

My regular IBM i Access services (Java) such as Telnet were working fine with SSL, so I knew the issue had to be with the Linux based ODBC drivers (different technology - C/C++) and its need to use a different certificate store for SSL certs. Apparently on Linux, trusted certificate files need to be located in the following directory: ```/usr/local/share/ca-certificates```    

Using the ```Key Management``` option from IBM i Access Client Solutions, I exported the trusted certificate file I wanted Linux to trust and saved it to a file. In this example we'll say we exported it to file: ```/tmp/mysysname.crt```    

**Make sure to use the .crt extension. My certificate would not add unless I used the .crt file extension instead of .cer**

Then I copied the ```mysysname.crt``` file to the ```/usr/local/share/ca-certificates``` directory. I suppose you could just save your cert there during export as well to save a step.    
Ex: ```cp /tmp/mysysname.crt /usr/local/share/ca-certificates/mysysname.crt``` 

The last step is to register the new cert file using the following command line:  
```sudo update-ca-certificates```

You should see a result similar to this indicating your certificate was added:
```
Updating certificates in /etc/ssl/certs...
rehash: warning: skipping ca-certificates.crt,it does not contain exactly one certificate or CRL
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
```

Now if you run ```cwbping mysysname /ssl:1``` you should no longer see any errors if your SSL certificates are working as expected with the IBM i Access ODBC Driver.    
And you should now be able to create ODBC data sources or DSN-less connections that use connection strings and they should all work fine with SSL as well.    

If this didn't solve your issue, then you probably have something different happening in your environment.   

## Links
ibm-iaccess for Linux ODBC Configuration   
https://www.ibm.com/support/pages/ibm-iaccess-linux-odbc-configuration
