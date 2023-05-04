# IBM i NFS Share Mount Notes

## Overview
Mounting an NFS share over an IFS directory is a great way to provide access to remote WIndows or Linux file directories without exposing them via NetServer, SMB and QTNC which can cause issues when user authentication doesn't match across systems.   

You can also limit access on your NFS shares to the IBM i IP address so this adds another level of security by limiting which machines can access the NFS shares.

Qshell Documentation for V5R4   
http://public.dhe.ibm.com/systems/power/docs/systemi/v5r4/en_US/rzahz.pdf

##  NFS Share Network Mount Example
For our example we will assume we have a remote Windows or Linux Server on IP address: 1.1.1.1 with a remote NFS share of /nfsmount1 that will get mounted over an IFS directory named /nfsmount1 for consistency. It's always a good idea to name your NFS shares and IFS directories consistently so the names are easily recognizable by your applications and users.

### Copying Files from and to NFS Shares using the CPY Command 

#### Copy file from IFS to NFS location.  Make sure to specify CCSID(437) and AUT(*INDIR) or you may get an authority error when copying files to an nfs directory.
```CPY OBJ('/tmp/test.pdf') TOOBJ('/nfsmount1/test.pdf') TOCCSID(437) DTAFMT(*BINARY) REPLACE(*YES) AUT(*INDIR)```

#### Copy file from IFS to NFS location.  Make sure to specify CCSID(437) and AUT(*INDIR) or you may get an authority error when copying files to an nfs directory.
```CPY OBJ('/nfsmount1/test.pdf') TOOBJ('/tmp/test.pdf') FROMCCSID(437) DTAFMT(*BINARY) REPLACE(*YES) AUT(*INDIR)```

## Qshell/Pase File Copy to NFS Shares

Copying files is pretty much like copying any other file in Qsh/Pase.

#### Initial copy to NFS mount if file doesn't exist. If you do a WRKLNK option 8 on the file after copied, you will see a CCSID of 437. This can cause issues if you need to later replace the file on the remote NFS mount because the IBMi thinks it has a CCSID of 437.
``` cpy /tmp/test.pdf  /nfsmount1/test.pdf ```

#### Attempt to copy to NFS mount if file exists already. You may receive the following error because it appears the cp cmmand is not CCSID aware.
```
cp /tmp/test.pdf  /nfsmount1/test.pdf                                      
cp: 001-2230 Error found setting CCSID to 437 for file /nfsmount1/test3.pdf.
Operation not supported.$                                                   
```

#### Attempt to copy file to NFS mount if file exists already. The following options should work. Either use the -t switch option or first delete the remote NFS file with rm command. Then copy it as a new file via cp command and this should work.

#### Copy file to NFS share and replace with -t switch 
```cp -t /tmp/test.pdf  /nfsmount1/test.pdf ```

#### Remove existing file and copy to NFS share
```
rm /nfsmount1/test.pdf
cp /tmp/test.pdf  /nfsmount1/test.pdf                                      
```

#### Mount NFS Share using NFS share named /nfsmount1 over IFS directory /nfsmount1
An NFS share is always mounted over an existing IFS directory path which means once mounted the local IFS files in the directory cannot be seen because the IFS directory is mapped to a remote NFS share and hte local files in the IFS folder are hidden because of the mount. Once unmounted, the local files in teh IFS directory can be accessed again. 

Note: Usually if mounting an NFS share over an IFS directory, it's probably a good idea to dedicate the IFS directory just for the the NFS mount and don't put any files in the local IFS directory. This will help avoid confusion that may occur where users may think local files have disappeared.

#### Create the IFS directory you will mount your NFS share over
```MKDIR  DIR('/nfsmount1') DTAAUT(*RWX) OBJAUT(*ALL)```

#### This example mounts to an NFS share on remote NFS server: 1.1.1.1 on share /nfsmount1
```
MOUNT TYPE(*NFS) MFS('1.1.1.1:/nfsmount1') +                  
MNTOVRDIR('/nfsmount1') +                         
OPTIONS('rw,nosuid,retry=5,rsize=8096,wsize=8096,+
timeo=20,retrans=2,acregmin=30,acregmax=60,+
acdirmin=30,acdirmax=60,soft') +       
CODEPAGE(*BINARY *ASCII)                     
```

#### This example unmounts the NFS share that us mounted over IFS directory /nfsmount1
```UNMOUNT TYPE(*NFS) MNTOVRDIR('/nfsmount1') ```

#### How to see if an NFS share is mounted
```WRKLNK '/nfsmount1/*'```

If you can see files, the share is mounted.

#### Another way to check NFS mount status. 
```WRKLNK '/nfsmount1'```

```Take option 8``` and you will see the following on the Display Attributes Screen if the remote NFS share is mounted:

```
Object . . . . . . :   /nfsmount1                        
                                                         
Type . . . . . . . . . . . . . . . . . :   DIR           
                                                         
Owner  . . . . . . . . . . . . . . . . :   *NOUSRPRF     
System object is on  . . . . . . . . . :   Remote        
  Object overflowed  . . . . . . . . . :   No            
                                                         
Coded character set ID . . . . . . . . :   437           
Hidden file  . . . . . . . . . . . . . :   No            
PC system file . . . . . . . . . . . . :   No            
Read only  . . . . . . . . . . . . . . :   No            
                                                         
Need to archive (PC) . . . . . . . . . :   No            
Need to archive (System) . . . . . . . :   No            
```

#### In this example the IFS directory doesn't have anything mounted over it
```                                                   
Object . . . . . . :   /nfsmount1                  
                                                   
Type . . . . . . . . . . . . . . . . . :   DIR     
                                                   
Owner  . . . . . . . . . . . . . . . . :   RICHARD
System object is on  . . . . . . . . . :   Local   
Auxiliary storage pool . . . . . . . . :   1       
  Object overflowed  . . . . . . . . . :   No      
                                                   
Coded character set ID . . . . . . . . :   37      
Hidden file  . . . . . . . . . . . . . :   No      
PC system file . . . . . . . . . . . . :   No      
Read only  . . . . . . . . . . . . . . :   No      
```

## General Setup for NFS File Sharing from Windows or Linux

#### Sharing Windows Files via NFS
Install Windows Service for Uni
https://www.serverlab.ca/tutorials/windows/storage-file-systems/configuring-an-nfs-server-on-windows-server-2012-r2/

Sharing NFS Directory from Windows

Directory to share on C: drive
 

Add Everyone user to the directory with permissions

 

Right click directory and go to the NFS Sharing Tab

Set the settings as shown.

 

Click Permissions tab to provide No Access, Read Only or Read-Write permissions to a remote system. 

In this example we explicitly set No Permissions for all machines and then add read/write permissions to the IBM i on IP address 192.168.101.21

 
 

#### Sharing Linux Files via NFS
https://cloud.netapp.com/blog/azure-anf-blg-linux-nfs-server-how-to-set-up-server-and-client

