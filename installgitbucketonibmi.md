# How to install Gitbucket on IBM i 
Gitbucket is an open source Java based git server for IBM i 

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

## Wait a few minutes and try to access the Gitbucket URL from your IBM i 
```http://[hostname]:8080/```   User/pass: root/root

## See Gitbucket site or Gitbucket github site for more documentation

https://gitbucket.github.io/

https://github.com/gitbucket/gitbucket

## Databases
By default I believe Gitbucket uses an internal H2 database. You may want to install Postgres on your IBM i and use that as a database instead. See the Gitbucket site for config instructions once you have Postgres installed on your IBM i. 

Feel free to use my instructions on this site to set up Postgres on IBM i. 





