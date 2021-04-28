# Setting Up SSH Daemon on IBM i to Use Port Other Than 22

Log on to a 5250 session on your IBM i system. 

Edit the SSH Daemon config file.

The edit file command would look as follows:

```
edtf '/QOpenSys/QIBM/UserData/SC1/OpenSSH/etc/sshd_config'
```

Once the edit screen comes up it may look as follows: 

```
# $OpenBSD: sshd_config,v 1.75 2007/03/19 01:01:29 djm Exp $               
                                                                           
# This is the sshd server system-wide configuration file.  See             
# sshd_config(5) for more information.                                     
                                                                           
# This sshd was compiled with PATH=/QOpenSys/usr/bin:/usr/ccs/bin:/QOpenSys
                                                                           
# The strategy used for options in the default sshd_config shipped with    
# OpenSSH is to specify options with their default value where             
# possible, but leave them commented.  Uncommented options change a        
# default value.                                                           
                                                                           
 Port 2022                                                                 
 #Port22
```
Add a new entry for the new port. Ex: Port 2022 and comment (#) the old entry if not already commented. 

After adding the port entry for port 2022, you can press F3 to save and exit the config file editor.

My preference is to put ports up in the 60000+ range.

Stop and restart the SSH daemon with the following commands

```
ENDTCPSVR *SSHD

Wait 10 seconds

STRTCPSVR *SSHD
```
Run the following command to make sure port 2022 is active:

```NETSTAT OPTION(*CNN) ```

If you see local port 2022 is active then you should be able to log in to the SSH server on port 2022. 

```
     Remote           Remote     Local                        
Opt  Address          Port       Port       Idle Time  State  
     *                *          as-admi >  100:11:23  Listen 
     *                *          as-admi >  100:17:44  Listen 
     *                *          as-admi >  100:17:44  Listen 
     *                *          as-admi >  100:17:44  Listen 

     *                *          2022       000:06:12  Listen 

```

You've completed the first step to securing your SSH server.

There are several OpenSSH server settings available, but the first step is getting SSH off of a non-standard port.

