# Install and configure Cron Scheduling on IBM i

From IBM: Now available for #IBMi: cron, via the 'cronie' RPM package! Anacron, too!

This package can be a good way to schedule your open source jobs or CL commands to run on a regular basis. 

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
# *  *  *  *  * ibmi-user-name  command to be executed
# Run a sample IBMi CL command every minute to send message to QSYSOPR
  */1  *  *  *  *  QSECOFR system "SNDMSG MSG(CRONJOB) TOUSR(QSYSOPR)"
# Run a sample IBMi CL command every minute to send message to QSYSOPR and log any stdout/stderr messages to custom log file /tmp/ibmicommand.log.
  */1  *  *  *  *  QSECOFR system "SNDMSG MSG(CRONJOB) TOUSR(QSYSOPR)"  >> /tmp/ibmicommand.log 2>&1
```

See crontab configuration sample links below for site that can teach you more about setting up your cron jobs via the crontab configration files.
https://github.com/richardschoen/howtostuff/blob/master/installcronie.md#links

***Note: It appears that you must specify the user ID to run the selected job as. In the above example we are running the SNDMSG example as QSECOFR.***  
```Only /QOpenSys/etc/crontab and the files in /QOpenSys/etc/cron.d/ have a username field though. Ours on IBM i are prefixed with /QOpenSys obviously.```  

Reading link for more info on running as a specific user.   
https://serverfault.com/questions/352835/crontab-running-as-a-specific-user  

# Make sure crontab file and cron directories are owned by root user for running system jobs

Run the following commands from a SSH session to make sure root user (QSECOFR) owns the files and directories. Otherwise your crontab will not run correctly because of permission errors even though the crond daemon will start up.

```
cd /QOpenSys/etc
chown qsecofr crontab
chown qsecofr cron.d
chown qsecofr cron.hourly
```

# Starting the crond daemon to run schedule jobs

Log in to SSH as IBM i QSECOFR level user. ```QSECOFR or a user with *ALLOBJ authority.```

Type: ```crond``` and press enter. 


From a 5250 session, run ***WRKACTJOB SBS(QUSRWRK) JOB(QP0ZSPWP)*** and you should see the active server jobs and threads in the QUSRWRK subsystem. 

```
--------------------------------------------------------------------------------
QP0ZSPWP     QSECOFR  BCI      .0  PGM-crond   SELW 
--------------------------------------------------------------------------------
```
Tip: If your crontab jobs are not running, drill in to this job via ```option 5. Work with``` and then display the job log for the active crond daemon ```10. Display job log, if active, on job queue, or pending ```. Usually there will be an error listed if your crontab command line entries are bad or permissions aren't set right on your crond configuration files and directories.


# Ending the crond daemon job

Log in to SSH as IBM i QSECOFR level user.

Type: ```kill `cat /QOpenSys/etc/crond.pid` ``` and press enter. 

# Start crond daemon job bash script - startcrond.sh

This script can be used to start the crond background job as an active job in the QUSRWRK subsystem.

```
#!/QOpenSys/pkgs/bin/bash
crond -s
```

# End crond daemon job bash script - endcrond.sh

This script can be used to end the crond background job if it's active. It used the process id stored in file /QOpenSys/etc/crond.pid to locate and kill the system job.

```
#!/QOpenSys/pkgs/bin/bash
kill `cat /QOpenSys/etc/crond.pid`
```

# Start crond daemon job from QSHEXEC CL command

This CL command example utilizes the QSHEXEC command which is part of the QSHONI library for running QSH/PASE jobs from a regular IBM i job. https://github.com/richardschoen/qshoni

```
 QSHONI/QSHEXEC CMDLINE('crond') LOGSTDOUT(*YES) 
```

# End crond daemon job from QSHEXEC CL command

This CL command example utilizes the QSHEXEC command which is part of the QSHONI library for running QSH/PASE jobs from a regular IBM i job. https://github.com/richardschoen/qshoni

```
 QSHONI/QSHEXEC CMDLINE('kill ```cat /QOpenSys/etc/crond.pid```') LOGSTDOUT(*YES)
```

This document does not cover production best practices. Best practices should be addressed with your Administration team or by researching Cron security best practices. 

# Links

Cronie Github Site

https://github.com/cronie-crond/cronie

Crontab configuration examples

https://phoenixnap.com/kb/set-up-cron-job-linux

https://corenominal.org/2016/05/12/howto-setup-a-crontab-file/

https://pimylifeup.com/cron-jobs-and-crontab/

Let me know if you have a favorite cron setup link.


