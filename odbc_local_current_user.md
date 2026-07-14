# PTFs related to using the *LOCAL DSN with IBM i ODBC Driver

## Problem
On  V7R5 machine I ran into an issue with the IBM i ODBC driver not working correctly when specifying *LOCAL without a user and password in a PASE app.

You can test like this: ```isql *LOCAL```. This should connect with the current logged in PASE user, but I was getting errors related to needing a user id and password.

## Resolution
It turns out the following two PTFs are available for release V7R5 and V7R6.    

They are related to the 5770DG1 Apache HTTP server, but apparently also resolve the *CURRENT user issue with ODBC.   

Link to PTF:  
https://www.ibm.com/mysupport/s/defect/aCIgJ000000A0efWAC/dt461861?language=en_US

PTF numbers are:
SJ08666 and SJ08667. They are the same IBM i fix for different releases V7R5 and V7R6.

## Reading Links
This doc talks about *CURRENT but predates V7R5 and V7R6   
https://ibmi-oss-docs.readthedocs.io/en/latest/odbc/using.html

ODBC Info from GitHub  
https://github.com/IBM/ibmi-oss-docs/tree/main/odbc


