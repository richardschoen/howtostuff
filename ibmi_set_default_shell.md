# Set IBM i User's Default Shell to Bash or back to QShell
Nowadays, the best way to do this is to using QSYS2.SET_PASE_SHELL_INFO() SQL procedure. 

### From 5250 Launch STRSQL and switch to SQL mode (Shift-F1, Option 1, Naming convention-*SQL)  

### Set current user's shell to bash
```CALL QSYS2.SET_PASE_SHELL_INFO('*CURRENT', '/QOpenSys/pkgs/bin/bash')```   

### Set a specific user's shell to bash
(requires *SECADM special auth plus *USE and *OBJMGT to the user profile)   
```CALL QSYS2.SET_PASE_SHELL_INFO('USERID', '/QOpenSys/pkgs/bin/bash')```   

### Set the default shell which is returned for users that do not have a shell set
(requires *SECADM special auth plus *USE and *OBJMGT to QSYS)   
```CALL QSYS2.SET_PASE_SHELL_INFO('*DEFAULT', '/QOpenSys/pkgs/bin/bash')```

## In case you want to set Shell to Bourne SHell - IBM i default I believe
When you selec bsh as your default shell, you will see a $ on the command line prompt when you connect with an SSH terminal

### Set current user's shell to Bourne Shell - bsh
```CALL QSYS2.SET_PASE_SHELL_INFO('*CURRENT', '/QOpenSys/usr/bin/bsh')```   

### Set a specific user's shell to qsh
(requires *SECADM special auth plus *USE and *OBJMGT to the user profile)   
```CALL QSYS2.SET_PASE_SHELL_INFO('USERID', '/QOpenSys/usr/bin/bsh')```   

## In case you want to set Shell to QShell - Not usually recommended
When you selec qsh as your default shell, you will see an empty command line prompt when you connect with an SSH terminal

### Set current user's shell to qsh
```CALL QSYS2.SET_PASE_SHELL_INFO('*CURRENT', '/QOpenSys/usr/bin/qsh')```   

### Set a specific user's shell to qsh
(requires *SECADM special auth plus *USE and *OBJMGT to the user profile)   
```CALL QSYS2.SET_PASE_SHELL_INFO('USERID', '/QOpenSys/usr/bin/qsh')```   

## Links

### Changing the Default Shell for Inbound Secure Shell (SSH) Connections to the IBM i
https://www.ibm.com/support/pages/changing-default-shell-inbound-secure-shell-ssh-connections-ibm-i
