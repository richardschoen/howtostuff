# Installing Python Web Based Git Repository Viewer (for viewing IBM i Source)
Klause is a Python based git repository viewer for viewing local file system repositories. 

For this use-case we will be viewing repository source changes stored in the IBM IFS file system that may have been committed ny **iForGit IBM i Git Client** Users (http://www.mobigogo.net/files/docs/iforgit). However any git repository can be viewed if listed in the runtime configuration. 

Slogan from the Github site: 
**klaus: a simple, easy-to-set-up Git web viewer that Just Works**

Github site for Klause
https://github.com/jonashaag/klaus

# Security
There is no user security on the web server component by default. If you need some basic security you will possibly want to implement this with the Gunicorn web server and nginx. 

See site for already available instructions: https://github.com/jonashaag/klaus

**TODO:** Gunicorn set up for IBM i. 

# Prerequisites
Make sure all Python 3 yum packages installed on IBM i via IBM ACS.

Install the following Python modules
```
pip3 install klaus
```
**If you get any errors during install, please note them here by opening an issue.**

# Running Klaus git viewer server from qsh/pase/bash

This example runs the Klaus git server over repositories GITTEST123 and GITTEST124 on HTTP port 4646 and is listening on all IP addresses.

```
klaus --host 0.0.0.0 --port 4646 /gitrepostest/GITTEST123 /gitrepostest/GITTEST124
```

# Running Klaus git viewer server from SBMJOB/QSHEXEC

This example runs the Klaus git server over repositories GITTEST123 and GITTEST124 on HTTP port 4646 and is listening on all IP addresses.

The background job is submitted via SBMJOB using the QSHEXEC command. (http://www.github.com/richardschoen/qshoni)

```
SBMJOB CMD(QSHONI/QSHEXEC CMDLINE('klaus --host 0.0.0.0 --port 4646 /gitrepostest/GITTEST123 /gitrepostest/GITTEST124') 
SETPKGPATH(*YES) PRTSPLF(GITVIEWER)) JOB(GITVIEWER) JOBQ(QUSRNOMAX) JOBMSGQFL(*WRAP)                                         
```
# Accessing Klaus Git Viewer Web Site
Log in from any web browser with the following url and port where sysnameorip is your IBM i host IP address and port is the specified port number.

Example using port 4646:
```http://sysnameorip:4646```

# Links
See the Klause site for further documentation
https://github.com/jonashaag/klaus
