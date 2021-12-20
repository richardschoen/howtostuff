# Set default PASE IBM i shell for individual user
This shows you how to set the default PASE user.  I generally set my user profile to use the bash shell as a default.

```
-- set current user's shell to bash
CALL QSYS2.SET_PASE_SHELL_INFO('*CURRENT', '/QOpenSys/pkgs/bin/bash');

-- set a specific user's shell to bash
-- (requires *SECADM special auth plus *USE and *OBJMGT to the user profile)
CALL QSYS2.SET_PASE_SHELL_INFO('THATUSER', '/QOpenSys/pkgs/bin/bash');

-- set the default shell which is returned for users that do not have
-- (requires *SECADM special auth plus *USE and *OBJMGT to QSYS)
CALL QSYS2.SET_PASE_SHELL_INFO('*DEFAULT', '/QOpenSys/pkgs/bin/bash');
```

#Useful Links
https://techchannel.com/SMB/08/2017/be-like-a-turtle


https://stackoverflow.com/questions/23913957/set-default-pase-ibm-i-shell-for-individual-user
