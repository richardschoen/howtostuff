# Configure NGINX with specific user without user needing *ALLOBJ Authority

# NGINX Configuration Steps
Using latest NGINX version on IBMi, here's what I got to work which can eliminate the *ALLOBJ requirement I believe:
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
- I added ```user NGINX1;``` at the top of my NGINX config for the user.
- I submit the NGINX startup to run as user ```NGINX1```. Should also work if logged in to SSH terminal as ```NGINX1``` user.
  I use the QSHEXEC command to submit my NGINX Process. (QSHEXEC is part of my QShell on i utilities)
- The server starts as user ```NGINX1``` and it skips the SETUID process because NGINX1 is already specified in the config file.
(The setuid skip thing was actually somewhat documented in the setuid api)
- NGINX version used: v1.23.0   
```
$ nginx -v   
Result: nginx version: nginx/1.23.0   
```
- In my case a number of DB tables had to be authorized as well. Unless you have *PUBLIC authority on the objects.   
  
The takeaway is you can run NGINX without *ALLOBJ with current NGINX. At least it worked for me

# Additional Reading
Interestingly it would appear that if I start the NGINX server as the user specified in the "user USERID;" setting in the NGINX.CONF file the NGINX user does not need *ALLOBJ authority.   
I'm basing my theory on this:   
https://www.ibm.com/docs/api/v1/content/ssw_ibm_i_73/apis/qsysetui.htm

I was reading this old NGINX thread on the IBMi open source site:   
https://bitbucket.org/ibmi/opensource/issues/141/run-nginx-and-php-fpm-as-user-qtmhhttp
