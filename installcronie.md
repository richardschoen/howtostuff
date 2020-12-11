# Install and configure Cron Scheduling on IBM i

From IBM: Now available for #IBMi: cron, via the 'cronie' RPM package! Anacron, too!

Install cronie yum packages from IBM i ACS Open Source Package Management
```
Package list:
cronie   
cronie-anacron
```
# Setting up sample crontab system schedule file 

From your favorite bash editor, edit the system crontab file: in ***/QOpenSys/etc/crontab***

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

# Make sure crontab file is owned by root user for running system jobs

Run the following commands from a SSH session to make sure root user (QSECOFR) owns the files and directories. Otherwise your crontab will not run correctly because of permission errors even though the crond daemon will start up.

```
cd /QOpenSys/etc
chown qsecofr crontab
chown qsecofr cron.d
chown qsecofr cron.hourly
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

# Ending the crond daemon job

Log in to SSH as IBM i QSECOFR level user.

Type: ***kill `cat /QOpenSYs/etc/crond.pid`*** and press enter. 

# crond daemon job startup script - startcrond.sh

This script can be used to start the crond background job as an active job in the QUSRWRK subsystem.

```
#!/QOpenSys/pkgs/bin/bash
crond -s
```

# crond daemon job end script - endcrond.sh

This script can be used to end the crond background job if it's active. It used the process id stored in file /QOpenSys/etc/crond.pid to locate and kill the system job.

```
#!/QOpenSys/pkgs/bin/bash
kill `cat /QOpenSys/etc/crond.pid`
```

This document does not cover production best practices. Best practices should be addressed with your Administration team or by researching Cron security best practices. 

# Links

Cronie Github Site

https://github.com/cronie-crond/cronie
