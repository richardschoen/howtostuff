# These permissions are important when securing an SSH configuration for an IBM i user
Once a user has generated an SSH private key and copied the ```.pub``` key to ```authorized_keys```, the .ssh directory and file permissions need to be set correctly.   

For this example, let's assume the user name is: ```TEST1```. The ```/home/TEST1``` directory or ```/home/TEST1/.ssh``` directories may or may not already exist.     

If ```/home/TEST1/.ssh``` does not exist the user needs to first log in to QShell or PASE and run ```ssh-keygen -t rsa``` to generate a private and public key.     
```
mkdir /home/TEST1
chown TEST1 /home/TEST1
chmod 755  /home/TEST1
chmod 700  /home/TEST1/.ssh/
chmod 600  /home/TEST1/.ssh/authorized_keys
```

### Another SSH directory and authorized_keys ownership example:  

Set home dir ownership. Don't recurse
```system "CHGOWN OBJ('/home/TEST1')   NEWOWN(RSCHOEN) RVKOLDAUT(*YES) SUBTREE(*NONE)```

Set .ssh directory ownership. Recurse
```system "CHGOWN OBJ('/home/TEST1/.ssh')   NEWOWN(TEST1) RVKOLDAUT(*YES) SUBTREE(*ALL)```

Set permissions for current user if they are logged in and creating the SSH key stuff
```
system "QSH CMD('chmod 755 ~')"
system "QSH CMD('chmod 700 ~/.ssh')"
system "QSH CMD('chmod 600 ~/.ssh/authorized_keys')"
```

-or-

Set permissions for specific user if not logged in as that user
```
System "QSH CMD('chmod 755 /home/TEST1)"
System "QSH CMD('chmod 700 /home/TEST1/.ssh")
System "QSH CMD('chmod 600 /home/TEST1/.ssh/authorized_keys')"
```
