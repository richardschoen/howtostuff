# How to install GitBucket on IBM i 
GitBucket is an open source Java based git server for IBM i.

This GitBucket git server can host any of your git project source code and the server has many other features such as Wikis for documentation. 

GitBucket is a great way to keep all your git based source code in a single repository. 

When used in conjunction with iForgit (http://www.iforgit.com) as a native IBM i client, you have a complete source management solution for all of your open source language projects stored in the IFS and source members that are still managed via source physical files. iForgit works as a native command based interface for SEU, PDM, RDi and VS Code developers and can manage all your RPG, CL, COBOL and other classic IBM i source members. 

Note: iForGit is a commercial offering.

## Create IBM i GITBUCKET user profile

Create a user profile named: GITBUCKET with QPGMR authority. 

Give it a password so you can log on as the user when initially starting GitBucket.

After creating the profile view the profile via ```WRKUSRPRF GITBUCKET``` and make sure its home directory is: ```/home/GITBUCKET``` and the directory exists. 

If home directory dsoes not exist, run the following commands from 5250 to create the home directory for GITBUCKET user and set the user as owner of the home directory:

```
MKDIR DIR('/home/GITBUCKET') DTAAUT(*RWX) OBJAUT(*ALL)
 
CHGOWN OBJ('/home/GITBUCKET') NEWOWN(GITBUCKET) RVKOLDAUT(*YES) SUBTREE(*ALL)
```

## Visit the GitBucket site

https://gitbucket.github.io/

## Download the gitbucket.war file 

https://github.com/gitbucket/gitbucket/releases/download/4.37.2/gitbucket.war

Or view most recent releases

https://github.com/gitbucket/gitbucket/releases

## Log in as GITBUCKET to a SSH bash shell, QSH or QP2TERM, to create Gitbucket IFS dir with following commands:
```
cd /

mkdir gitbucket
```

## Upload the gitbucket.war file to the ```/gitbucket``` IFS directory using your favorite binary file transfer method

## Determine Current Default Java Version for 5250 Sessions (Mainly for Reference)
```
STRQSH

java -version

Output should look somethihg like this and should be 1.8.x at least:

------------------------------------------------------------------------------------
java version "1.8.0_161"                                                                
Java(TM) SE Runtime Environment (build 8.0.5.10 - pap3280sr5fp10-20180214_01(SR5 FP10)) 
IBM J9 VM (build 2.9, JRE 1.8.0 OS/400 ppc-32 20180208_378436 (JIT enabled, AOT enabled)
OpenJ9   - 39bb844                                                                      
OMR      - c04ccb2                                                                      
IBM      - 2321a81)                                                                     
JCL - 20180209_01 based on Oracle jdk8u161-b12                                      
------------------------------------------------------------------------------------
```

## From a shell logged in as GITBUCKET user profile, attempt to start the GitBucket server with following commands:
```
cd /gitbucket

java -jar gitbucket.war
```
Example to Start on alternate port 10001
```
cd /gitbucket

java -jar gitbucket.war  --port-10001
```

## Wait a few minutes and try to access the GitBucket URL from your IBM i 
```http://[hostname]:8080/```   User/pass: root/root

Or altrenate port
```http://[hostname]:10001/```   User/pass: root/root

```Change root user password after initial set up```

## Where are work app files created in IFS
By default the database and all application files and repository locations get extracted to or created in the ```/home/[userid]/.gitbucket``` directory for the user who ran the gitbucket server. In our case it should be:  ```/home/GITBUCKET/.gitbucket```

***It might be a good idea to create a GITBUCKET IBM i user to run the server nder for consistency.***

## See GitBucket site or GitBucket github site for more documentation

https://gitbucket.github.io/

https://github.com/gitbucket/gitbucket

## Databases
By default GitBucket uses an internal H2 database. You may want to install Postgres on your IBM i and use that as a database instead. See the GitBucket site for config instructions once you have Postgres installed on your IBM i. 

Feel free to use my instructions on this site to set up Postgres on IBM i. 

## Using with the new Java 11 on IBM i if desired
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
