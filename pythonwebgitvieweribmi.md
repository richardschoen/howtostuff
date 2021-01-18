# Installing Python Web Based Git Repository Viewer
Klaus is a Python based git repository viewer for viewing local file system repositories. 

For this use-case we will be viewing repository source changes stored in the IBM IFS file system that may have been committed by **iForGit IBM i Git Client** users. (http://www.mobigogo.net/files/docs/iforgit) However any IFS based git repository can be viewed from a browser if listed in the runtime configuration. 

Slogan from the Github site: 
**klaus: a simple, easy-to-set-up Git web viewer that Just Works**

Github site for Klause
https://github.com/jonashaag/klaus

# Security
There is no user security on the web server component by default. However the specified **repositories are read-only**. 

If you need some basic security you will possibly want to implement this with the Gunicorn web server and nginx. 

**Sample nginx config file listed at bottom of article**

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

# Sample nginx config for Klaus with user/password security enabled

Sample nginx config file: **nginx-klaus.conf**

```
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #---------------------------------------------------
    # Non SSL Reverse Proxy for Git Viewer 
    # This example passes the incoming request on port 
    # 4647 to the nginx server and passes the request 
    # to internal Klaus Git Viewer localhost address on port 4646
    #
    # Enable user security
    # - Uncomment auth_basic and auth_basic_user_file to enable user auth.
    # - .httpasswd file must exist if uncommenting/enabling basic user/password checking.
    # - Set up nginx .httpasswd file. See following web link for nginx user/pass setup example
    #   https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04
    #---------------------------------------------------
    server {
            listen 4647;
            #auth_basic "Enter Git Viewer User Info";
            #auth_basic_user_file /QOpenSys/etc/nginx/.htpasswd;
            server_name mygitviewer.com;
    
            location / {
                proxy_pass http://localhost:4646;
                proxy_pass_request_headers on;
                proxy_set_header        Host            $host;
                proxy_set_header        X-Real-IP       $remote_addr;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                #proxy_redirect off;
                proxy_cookie_domain localhost 127.0.0.1;
                proxy_http_version 1.1;
                proxy_set_header Connection "";
            }
            
            error_page  404              /404.html;

            # redirect server error pages to the static page /50x.html
            #
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
            root   html;
            }

        }
	
}
```

# Links
See the Klause site for further documentation
https://github.com/jonashaag/klaus

Nginx user/password file set up
https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04


