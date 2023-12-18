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

## In case you want to reset Shell to QShell

### Set current user's shell to qsh
```CALL QSYS2.SET_PASE_SHELL_INFO('*CURRENT', '/QOpenSys/usr/bin/qsh')```   

### Set a specific user's shell to qsh
(requires *SECADM special auth plus *USE and *OBJMGT to the user profile)   
```CALL QSYS2.SET_PASE_SHELL_INFO('USERID', '/QOpenSys/usr/bin/qsh')```   


