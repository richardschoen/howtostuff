# Configure NGINX with specific user without user needing *ALLOBJ Authority
User was seeing the following error in their NGINX log file when trying to start or restart the NGINX server via:   

Regular NGINX startup command   
```nginx -c /qopensys/etc/nginx/nginx.conf```   
-or-    
NGINX reload command   
```nginx -s reload```

Errors showed up in the log file in file: ```/QOpenSys/var/log/nginx/error.log```    
Accessing error.log from 5250 command line: ```WRKLNK '/QOpenSys/var/log/nginx/error.log'```     
```
2024/05/21 13:00:46 [notice] 3215038#1: signal process started                 
2024/05/21 13:00:46 [alert] 3214934#1: recvmsg() failed (13: Permission denied)
2024/05/21 13:00:46 [alert] 3215039#1: recvmsg() failed (13: Permission denied)
2024/05/21 13:00:46 [alert] 3215041#1: recvmsg() failed (13: Permission denied)
2024/05/21 13:00:46 [alert] 3215042#1: recvmsg() failed (13: Permission denied)
```
This seems to be related to setting up an appropriate user profile to run the NGINX server and threads under. 

By default the main thread user will be the ```user who started the NGINX server```. And worker thread jobs run under user profile: ```QTMHHTTP``` by default.   

What we want is for the main thread and worker threads to run under the ```same user profile```.

# NGINX Configuration Steps
Using latest NGINX version on IBM i, here's what I got to work which can eliminate the *ALLOBJ requirement I believe by running all NGINX jobs using the same user profile:
- I created a userid. Let's call it ```NGINX1```.
- I gave the user ```*NONE``` for special authorities.
- I did some IFS permission setting for ```NGINX1``` for NGINX log dirs with the following CL command from a 5250 session.
  ```
   CHGAUT OBJ('/qopensys/var/log/nginx')  
        USER(NGINX1)                    
        DTAAUT(*RWX)                    
        OBJAUT(*ALL)                    
        SUBTREE(*ALL)
  ```
- I added the ```user NGINX1;``` at the top of my NGINX config for the user instead of leaving the default of: ```user nobody;```   
- I submit the NGINX startup to run as user ```NGINX1```. Should also work to start NGINX via command line if logged in to SSH terminal as ```NGINX1``` user.
  I use the QSHEXEC command to submit my NGINX Process. (QSHEXEC is part of my QShell on i utilities)
  
  Example of submitting NGINX startup using QSHEXEC command:   
  ```
  SBMJOB CMD(QSHONI/QSHEXEC CMDLINE('nginx -c /qopensys/etc/nginx/nginx.conf') PRTSTDOUT(*YES) PRTSPLF(NGINX))   
        JOB(NGINX) JOBQ(QUSRNOMAX) USER(NGINX1)
  ```

- The server starts as user ```NGINX1``` and it skips the SETUID process because NGINX1 is already specified in the config file.
(The setuid skip thing was actually somewhat documented in the setuid api)
- NGINX version used: v1.23.0   
```
$ nginx -v   
Result: nginx version: nginx/1.23.0   
```
- In my case a number of DB tables had to be authorized as well so my web apps could access those tables. Unless you have *PUBLIC authority set on the objects you will also need to authorize objects for access by user ```NGINX1```.
  
The takeaway is you can run NGINX without *ALLOBJ with current NGINX. At least it worked for me.

Feel free to open a GitHub issue if you run into any issues with this example. 

# Additional Reading
Interestingly it would appear that if I start the NGINX server as the user specified in the "user USERID;" setting in the NGINX.CONF file the NGINX user does not need *ALLOBJ authority.   
I'm basing my theory on this:   
https://www.ibm.com/docs/api/v1/content/ssw_ibm_i_73/apis/qsysetui.htm

I was reading this old NGINX thread on the IBMi open source site:   
https://bitbucket.org/ibmi/opensource/issues/141/run-nginx-and-php-fpm-as-user-qtmhhttp
