# How to install Gitbucket on IBM i 
Gitbucket is an open source Java based git server for IBM i.

This Git server can host any of your git project source code and has many other features. 

Gitbucket is a great way to keep all your git based source code in a single repository. 

When used in conjunction with iForgit (http://www.iforgit.com) as a native IBM i client, you have a complete source management solution for all of your open source language projects stored in the IFS and source members that are still managed via source physical files. iForgit works as a native command based interface for SEU, PDM, RDi and VS Code developers and can manage all your RPG, CL, COBOL and other classic IBM i source members. 

Note: iForGit is a commercial offering.

## Visit the Gitbucket site

https://gitbucket.github.io/

## Download the Gitbucket.war file 

https://github.com/gitbucket/gitbucket/releases/download/4.33.0/gitbucket.war

Or view most recent releases

https://github.com/gitbucket/gitbucket/releases

## Log in to IFS and from an SSH bash shell, QSH or QP2TERM, run the following commands to create Gitbucket IFS dir
```
cd /

mkdir gitbucket
```

## Upload the gitbucket.war file to the /gitbucketr IFS directory using your favorite binary file transfer method

## From a shell attempt to start the Gitbucket server with following commands
```
cd /gitbucket

java -jar gitbucket.war
```
Start on alternate port 10001
```
cd /gitbucket

java -jar gitbucket.war  --port-10001
```

## Wait a few minutes and try to access the Gitbucket URL from your IBM i 
```http://[hostname]:8080/```   User/pass: root/root

## Where are work app files created in IFS
By default the database and all application files and repository locations get extracted to or created in the ```/home/[userid]/.gitbucket``` directory for the user who ran the gitbucket server. 

***It might be a good idea to create a GITBUCKET IBM i user to run the server nder for consistency.***

## See Gitbucket site or Gitbucket github site for more documentation

https://gitbucket.github.io/

https://github.com/gitbucket/gitbucket

## Databases
By default I believe Gitbucket uses an internal H2 database. You may want to install Postgres on your IBM i and use that as a database instead. See the Gitbucket site for config instructions once you have Postgres installed on your IBM i. 

Feel free to use my instructions on this site to set up Postgres on IBM i. 

## Using with the new Java 11 on IBM i
https://bitbucket.org/ibmi/opensource/src/master/docs/java11/JAVA11_EARLY_ACCESS.md

## Setting the Java 11 path in a bash or other shell
```
JAVA_HOME=/QOpenSys/pkgs/lib/jvm/openjdk-11/
export JAVA_HOME
PATH=/QOpenSys/pkgs/lib/jvm/openjdk-11/bin:$PATH
export PATH
cd /gitbucket
java -jar gitbucket.war
```

## Native IBM i Git Client for Managing Source Files in Git
http://www.iforgit.com

Use your favorite editor: SEU, PDM, RDi and VS Code to edit your classic RPG, CL and COBOL source members and then use iForGit as a native CL driven git client.

You'll make the auditors happy.


