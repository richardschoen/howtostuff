# How to set up IBM i Access ODBC Driver to use an SSL Certificate 
```This article is not a full tutorial on setting up SSL on your IBM i. It simply covers the issue I had after all that was set up and ODBC still was giving the CWBCO1050 error.```

Installing and using the ```IBM i Access Client Solutions``` Java based software (which provides 5250, File Transfer IFS, RUn SQL, etc utilities) and the Windows ODBC driver which is installed with the ```ACS Windows App Pkg English (64bit)``` is usually a pretty easy process.    

There are two separate installers for: ```IBM i Access Client Solutions``` and ```ACS Windows App Pkg English (64bit)``` available from this site if you have an IBM login:    
https://www.ibm.com/support/pages/ibm-i-access-client-solutions   

After installation and configuration you can usually configure a Telnet session with Access Client Solutions or create and use an ODBC data source without issues.   

Until you want to use SSL to connect to your database via ODBC instead of unsecured access......    

I was trying to set up my IBM i Access ODBC Driver with SSL on a Windows machine and every time I ran ```cwbping mysysname /ssl:1``` I got the following error: ```Error message CWBCO1050 - "The system certificate is not trusted.```     

My regular IBM i Access services such as Telnet were working fine with SSL, so I knew the issue had to be with the Windows based ODBC drivers different technology (C/C++) and its need to use a different certificate store for SSL certs.  The certificate store file for IBM i Access Winddows package is named: ```C:\Users\Public\Documents\IBM\Client Access\cwbssldf.kdb``` and uses GSKit to encrypt and decrypt certificates. 

The CWBCO1050 error usually occurs when you have not downloaded the public Certificate Authority certificate or the system Client/Server certificate to the PC key database. Or you have the public Certificate Authority certificate certificate downloaded but it's not marked marked as trusted in the PC key database."

So initially I went through the instructions on the site listed below to make sure my certs were getting downloaded and placed into the IBM i Access Windows package key store file named: ```C:\Users\Public\Documents\IBM\Client Access\cwbssldf.kdb```   
https://www.ibm.com/support/pages/importing-certificates-use-ibm-i-access-client-solutions-windows-application-package-acs-winap  
    
Then ran ```cwbping mysysname /ssl:1``` and kept getting: CWBCO1050 - "The system certificate is not trusted.```    

## How to finally solve this issue
Well in the end it's actually pretty easy if you have the right little bit of information: You need to make sure all the certs you have added to the IBM i Access Windows package key store file named: ```C:\Users\Public\Documents\IBM\Client Access\cwbssldf.kdb```  are marked as ```Trusted```.    

Let's look at a little example:
First open a DOS terminal window and run the following commands:

Set the path to the gsk8capicmd.exe which is used to list or make changes to the ```cwbssldf.kdb``` key store file. This change will only be in place while the DOS Window is open.
```set PATH=C:\Program Files (x86)\IBM\gsk8\bin;C:\Program Files (x86)\IBM\gsk8\lib;%PATH%```

This command lists all the certs for IBM i Access for Windows key store (different than the Java keystore used by IBM i Access Client Solutions)   
```gsk8capicmd.exe -cert -list all -db "C:\Users\Public\Documents\IBM\Client Access\cwbssldf.kdb" -pw ca400```

Results look like this possibly: All trusted entries are pefixed with an exclamation point ```!```      
In my scenario Godaddy is the provider for my wildcard domain certificate, but that shouldn't matter.    
```
!       "RSA Secure Server Certification Authority"
!       "VeriSign Class 3 Secure Server CA"
!       "Entrust.net Certification Authority (2048)"
!       "Entrust.net Client Certification Authority"
!       "Entrust.net Global Client Certification Authority"
!       "Entrust.net Global Secure Server Certification Authority"
!       "Entrust.net Secure Server Certification Authority"
!       "Entrust.net Certification Authority (2048) 29"
!       "Entrust Root Certification Authority - EC1"
!       "Entrust Root Certification Authority - EV"
!       "Entrust Root Certification Authority - G2"
!       "Thawte Personal Basic CA"
!       "Thawte Personal Freemail CA"
!       "Thawte Personal Premium CA"
!       "Thawte Premium Server CA"
!       "Thawte Server CA"
!       "Thawte Primary Root CA - G2 ECC"
!       "Thawte Primary Root CA"
!       "VeriSign Class 1 Public Primary Certification Authority"
!       "VeriSign Class 1 Public Primary Certification Authority - G2"
!       "VeriSign Class 1 Public Primary Certification Authority - G3"
!       "VeriSign Class 2 Public Primary Certification Authority"
!       "VeriSign Class 2 Public Primary Certification Authority - G2"
!       "VeriSign Class 2 Public Primary Certification Authority - G3"
!       "VeriSign Class 3 Public Primary Certification Authority"
!       "VeriSign Class 3 Public Primary Certification Authority - G2"
!       "VeriSign Class 3 Public Primary Certification Authority - G3"
!       "VeriSign Class 3 Public Primary Certification Authority - G5"
!       "VeriSign Class 4 Public Primary Certification Authority - G2"
!       "VeriSign Class 4 Public Primary Certification Authority - G3"
        "MYSYS.MYDDMAIN.COM - Tuesday, November 21, 2023 13:36:07"
        "acs_import_Richard Schoen_71806731094500 CA - Tuesday, November 21, 2023 15:04:36"
        "acs_import_*.mydomain.com_71806234456600 CA - Tuesday, November 21, 2023 15:04:35"
        "acs_import_Go Daddy Secure Certificate Authority - G2_71806484262100 CA - Tuesday, November 21, 2023 15:04:35"
        "acs_import_Go Daddy Root Certificate Authority - G2_71806571558600 CA - Tuesday, November 21, 2023 15:04:35"
```
