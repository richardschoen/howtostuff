# How to set up IBM i Access ODBC Driver for MacOS to use an SSL Certificate 
```This article is not a full tutorial on setting up SSL on your IBM i. It covers the issue I had after SSL was set up and ODBC still was giving the CWBCO1050 certificate not trusted error on MacOS - M1.```

Installing and using the ```IBM i Access Client Solutions``` Java based software (which provides 5250, File Transfer IFS, Run SQL utilities, etc) and the MacOS ODBC driver which is installed with the ```ACS Mac App Pkg``` is usually a pretty easy process.    

There are two separate installers for: ```IBM i Access Client Solutions``` and ```ACS Mac App Pkg``` available from the following download site if you have an IBM login:    
https://www.ibm.com/support/pages/ibm-i-access-client-solutions   

After installation and configuration you can usually configure a Telnet session with Access Client Solutions or create and use an ODBC data source without issues.   

***Until you want to use SSL to connect to your database via ODBC instead of unsecured access......***

I was trying to set up my IBM i Access ODBC Driver with SSL on a Mac M1 machine and every time I ran:   
```cwbping mysysname /ssl:1``` to test SSL connectivity for the ODBC driver I got the following error: ```Error message CWBCO1050 - "The system certificate is not trusted.``` I got the same errors from the isql utility if I defined an ODBC data source with the ```SSL=1``` setting. Ex isql command to connect: ```isql -v mysysname user1 pass1```  

My regular IBM i Access services (Java) such as Telnet were working fine with SSL, so I knew the issue had to be with the Mac based ODBC drivers (different technology - C/C++) and its need to use a different certificate store for SSL certs. Apparently since unixodbc is installed byt HomeBrew, there is a related certificate store that needs to be used for trusted certiciates instead of the Mac Keychain. The certificate store directory used by HomeBrew is named: ```$HOMEBREW_PREFIX/etc/openssl@3/certs```. On my Mac that mapped to directory: ```/opt/homebrew/etc/openssl@3/certs```  

Using the ```Key Management``` option from IBM i Access Client Solutions, I exported the trusted certificate file I wanted HomeBrew to trust and saved it to a file. In this example we'll say we exported it to file: ```/tmp/mysysname.cer```    

Then I copied the ```mysysname.cer``` file to the ```/opt/homebrew/etc/openssl@3/certs``` directory. I suppose you could just save your cert there during export as well to save a step.    
Ex: ```cp ~/mysysname.cer /opt/homebrew/etc/openssl@3/certs/mysysname.cer``` 

The last step is to register the new cert file using the following command line:
```sudo $HOMEBREW_PREFIX/opt/openssl@3/bin/c_rehash```   

Now if you run ```cwbping mysysname /ssl:1``` you should no longer see any errors if your SSL certificates are working as expected with the IBM i Access ODBC Driver.    

And you should now be able to create ODBC data sources or DSN-less connections that use connection strings and they should all work fine with SSL as well.    

If this didn't solve your issue, then you probably have something different happening in your environment.   

## Related links where I learned this: 
https://formulae.brew.sh/formula/openssl@3
