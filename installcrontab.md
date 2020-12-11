# Install and configure Cron Scheduling on IBM i

From IBM: Now available for #IBMi: cron, via the 'cronie' RPM package! Anacron, too!

Install cronie yum packages from IBM i ACS Open Source Package Management
```
Package list:
cronie   
cronie-anacron
```
# Setting up sample crontab system schedule file in /QopenSys/etc/crontab

**The example listed below sends a message to QSYSOPR via calling an IBMi CL Command**
```
SHELL=/QOpenSys/pkgs/bin/bash
PATH=/QOpenSys/pkgs/bin:/QOpenSys/usr/sbin:/QOpenSys/usr/bin
MAILTO=qsecofr

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
# Run a sample IBMi CL command every minute
  */1  *  *  *  *  QSECOFR system "SNDMSG MSG(CRONJOB) TOUSR(QSYSOPR)"
```

# Starting the crond daemon to run schedule jobs

Log in to SSH as IBM i QSECOFR level user.

Type: ***crond*** and press enter. 


From a 5250 session, run ***WRKACTJOB SBS(QUSRWRK) JOB(QP0ZSPWP)*** and you should see the active server jobs and threads in the QUSRWRK subsystem
```
--------------------------------------------------------------------------------
QP0ZSPWP     QSECOFR  BCI      .0  PGM-crond   SELW 
--------------------------------------------------------------------------------
```

This document does not cover production best practices. Best practices should be addressed with your Administration team or by researching Cron security best practices. 

# Links

Cronie Github Site

https://github.com/cronie-crond/cronie
