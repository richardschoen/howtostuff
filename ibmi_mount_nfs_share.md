# IBM i NFS Share Mount How-To Notes

## Overview
Mounting an NFS share over an IFS directory is a great way to provide access to remote Windows or Linux file directories from IBM i and QShell/PASE without exposing them via NetServer, SMB and QTNC which can cause issues when user authentication doesn't match across systems.   

❗ You should limit access to your NFS shares to the IBM i IP address so this adds another level of security by limiting which machines can access the NFS shares. This is done on your remote Windows or Linux NFS share configuration.

❗ You SHOULD NOT need to start the IBM i NFS Server in order to mount an IFS directory over an NFS file share.

**Feel free to contribute any notes you have on accessing NFS file shares from IBM i.**

##  NFS Share Network Mount Example
For our example we will assume we have a remote Windows or Linux Server on IP address: 1.1.1.1 with a remote NFS share of /nfsmount1 that will get mounted over an IFS directory named /nfsmount1 for consistency.   

It's always a good idea to name your remote Windows and Linux directories, NFS shares and IFS directories consistently so the names are easily recognizable by your applications and users.

#### Mount NFS Share using NFS share named /nfsmount1 over IFS directory /nfsmount1
An NFS share is always mounted over an existing IFS directory path which means once mounted the local IFS files in the directory cannot be seen because the IFS directory is mapped to a remote NFS share and the local files in the IFS folder are hidden because of the mount. Once unmounted, the local files in teh IFS directory can be accessed again. 

❗ Note: Usually if mounting an NFS share over an IFS directory, it's probably a good idea to dedicate the IFS directory just for the the NFS mount and don't put any files in the local IFS directory. This will help avoid confusion that may occur where users may think local files have disappeared.

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


## Copying Files from and to NFS Shares using the CPY CL Command 

#### Copy file from IFS to NFS location.  Make sure to specify CCSID(437) and AUT(*INDIR) or you may get an authority error when copying files to an nfs directory from the IFS.
```CPY OBJ('/tmp/test.pdf') TOOBJ('/nfsmount1/test.pdf') TOCCSID(437) DTAFMT(*BINARY) REPLACE(*YES) AUT(*INDIR)```

#### Copy file from NFS to IFS location.  Make sure to specify CCSID(437) and AUT(*INDIR) or you may get an authority error when copying files from an nfs directory to the IFS.
```CPY OBJ('/nfsmount1/test.pdf') TOOBJ('/tmp/test.pdf') FROMCCSID(437) DTAFMT(*BINARY) REPLACE(*YES) AUT(*INDIR)```

## QShell/PASE IFS File Copy from and to NFS Shares

Copying files is pretty much like copying any other file in QSH/PASE. Use the ```cp``` command.

#### Initial copy from IFS to NFS mount if file doesn't exist on remote NFS share. If you do a WRKLNK option 8 on the file after copied, you will see a CCSID of 437. This can cause issues if you need to later replace the file on the remote NFS mount because the IBMi thinks it has a CCSID of 437.
```cp /tmp/test.pdf /nfsmount1/test.pdf```

#### Attempt to copy to NFS mount if file exists already. You may receive the following error because it appears the cp command is not CCSID aware.
```
cp /tmp/test.pdf  /nfsmount1/test.pdf                                      
cp: 001-2230 Error found setting CCSID to 437 for file /nfsmount1/test3.pdf.
Operation not supported.$                                                   
```

#### Attempt to copy file to NFS mount if file exists already. The following options should work. Either use the -t switch option or first delete the remote NFS file with rm command. Then copy it as a new file via cp command and this should work.

#### Copy file to NFS share and replace with -t switch 
```cp -t /tmp/test.pdf  /nfsmount1/test.pdf ```

I'm not exactly sure why the -t switch works to replace the remote file since it's exact usage documantation says: 
```
 -t, --target-directory=DIRECTORY
              copy all SOURCE arguments into DIRECTORY
```              
Without the -t switch we get an error similar to the following:   

```
cp: 001-2230 Error found setting CCSID to 437 for file /nfsmount1/test.pdf. Operation not supported.
```   

If the -t switch works for you, that's good. Otherwise you can always remove ```rm``` the remote file before copying it with ```cp```. The fun of QShell/PASE.

#### Remove existing file and copy to NFS share

```
rm /nfsmount1/test.pdf
cp /tmp/test.pdf  /nfsmount1/test.pdf                                      
```

## General Setup for NFS File Sharing from Windows or Linux

#### Sharing Windows Files via NFS
Install Windows Service for Unix on Windows 2012     
https://www.serverlab.ca/tutorials/windows/storage-file-systems/configuring-an-nfs-server-on-windows-server-2012-r2/

Install NFS Server on Windows 2019   
https://computingforgeeks.com/install-and-configure-nfs-server-on-windows-server

#### Sharing NFS Directory from Windows

Directory to share on C: drive    
![image](https://user-images.githubusercontent.com/9791508/236639390-40151a89-5c1c-422c-b2ee-3bb23e99f503.png)

Add Everyone user to the directory with permissions   
![image](https://user-images.githubusercontent.com/9791508/236639457-fa2e7774-c153-47fc-b0d0-079df9009a39.png)

Right click directory and go to the NFS Sharing Tab.

Set the settings as shown.      

![image](https://user-images.githubusercontent.com/9791508/236639534-32cab28a-f9c6-47c0-935f-9ef2ec7a9ce5.png)

![image](https://user-images.githubusercontent.com/9791508/236639572-87547451-53c4-4196-afe7-9642fdd86a40.png)

Click Permissions tab to provide No Access, Read Only or Read-Write permissions to a remote system.    

In this example we explicitly set No Permissions for all machines and then add read/write permissions to the IBM i on IP address 192.168.101.21   
![image](https://user-images.githubusercontent.com/9791508/236639704-a944b5ad-bba7-4d97-98f7-cf23c5057d7d.png)

![image](https://user-images.githubusercontent.com/9791508/236639713-5bb243ae-5bc8-424c-b563-5fb470293b97.png)

## Allow unmapped user access via NFS for IBMi when accessing Windows NFS shares  

You may need to do this on Windows 2016, 2019 and newer versions of Windows Server.  

Put ```Everyone``` user on the Windows directory and NFS share if possible.   

Add the ```Everyone``` user to ```NTFS permissions``` and give it ```Read/Write or Full Control```.  

Then check ```Allow unmapped user access by UID/GID```.   

Theoretically that should be what you need to do to make it work.   

Then from PASE try copying a file with the ```cp``` command to test as noted above.   

If that works, try copying files from a 5250 session via the ```CPY``` command as noted above.   

Now you don't need QNTC or SAMBA then at all for sending and receiving files from/to Windows shares.      

![image](https://user-images.githubusercontent.com/9791508/236643431-f5cf657a-ab57-4b41-bc0b-f12f70f0d896.png)

#### Sharing Linux Files via NFS
https://cloud.netapp.com/blog/azure-anf-blg-linux-nfs-server-how-to-set-up-server-and-client

#### Additional IBM i NFS and Other NFS Links
IBM i Network FIle System    
https://www.ibm.com/docs/en/i/7.5?topic=systems-network-file-system-nfs     

Windows Services for Network File Systems   
https://forsenergy.com/en-us/nfs__lh/html/1f02f8b2-e653-4583-8391-84d3411badd1.htm

Windows Services for NFS - Allow Root and Anonymous Access to Resources by NFS Clients    
https://forsenergy.com/en-us/nfs__lh/html/47b01fb7-a6f7-4be0-ae99-2fbda7974a8b.htm

Windows - Deploy Network File System (NFS)   
https://learn.microsoft.com/en-us/windows-server/storage/nfs/deploy-nfs


