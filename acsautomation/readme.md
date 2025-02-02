# Automating IBM i ACS Uploads and Downloads
This area covers how to automate uploads and downloads with IBM i Access Client Solutions and the Java based ```acsbundle.jar``` file.

As part of IBM Access Client Solutions you have the ability to use ```acsbundle.jar``` to automatically file uploads and downloads using the file upload/download capabilities.   

You can download directly to Excel or CSV.

You can upload from Excel or CSV as long as you have saved your transfer definition field definitions to an ```.fdfx``` file. 

Saved **file download definitions** get saved to files ending in ```.dtfx```.   

Saved **file upload definitions** get saved to files ending in ```.dttx```.   

## General steps to set up a file download or upload profile  

### Install acsbundle.jar file to IFS  
Install the ```acsbundle.jar``` file into IFS directory ```/acsautomation```.  

### File download definition profile - .dtfx
If you want to set up an automated download, you need to use the ```Data Transfer``` option in IBM i Access Client Solutions and save your download definition to a ```.dtfx``` file. You should also save the field definitions to a ```.fdfx``` file if you plan to upload data from an Excel or CSV file in the IFS.

### File upload definition profile - .dttx
If you want to set up an automated upload, you need to use the ```Data Transfer``` option in IBM i Access Client Solutions to do an upload and then save your download definition to a ```.dttx``` file. You should also specify a previously saved field definition ```.fdfx``` file since it's required with Excel uploads and possibly CSV uploads as well.

## Links   
IBM documentation on using ACS upload and download    
https://www.ibm.com/support/pages/ibm-i-access-acs-getting-started   


## Files    
**accessclientsolutions_dataxfer.pdf** - Craig Pelkie Ocean presentation on ACS - 2012    


## QShell on i Examples using QSHEXEC command  

### Run an SQL Select statement and output to Excel file in the IFS 
Set DSPSTDOUT(*YES) to see stdout log info if you are testing interactivly.    
```
QSHEXEC CMDLINE('cd /acsautomation;java -jar acsbundle.jar
/PLUGIN=cldownload /system=localhost /userid=USER1
/sql="select * from qiws.qcustcdt"  /clientfile=/tmp/test.xlsx')    
DSPSTDOUT(*NO)     
```
   
### Download physical file QIWS/QCUSTCDT to Excel file using Data Transfer Request File
Set DSPSTDOUT(*YES) to see stdout log info if you are testing interactivly.    
```
QSHEXEC CMDLINE('cd /acsautomation;java -jar acsbundle.jar 
/PLUGIN=download /home/richard/acsautomation/testout.dtfx')                           
DSPSTDOUT(*NO)                                          
```

   
### Upload Excel file from IFS to physical file QIWS/QCUSTCDT using Data Transfer Request File
Set DSPSTDOUT(*YES) to see stdout log info if you are testing interactivly.    
```
QSHEXEC CMDLINE('java -jar /home/richard/acsautomation/acsbundle.jar 
/PLUGIN=upload /home/richard/acsautomation/testout.dttx')                           
DSPSTDOUT(*NO)                                          
```

