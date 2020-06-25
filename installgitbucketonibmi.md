# How to install Gitbucket on IBM i 
Gitbucket is an open source Java based git server for IBM i 

## Visit the Gitbucket site

https://gitbucket.github.io/

## Download the Gitbucket.war file 

https://github.com/gitbucket/gitbucket/releases/download/4.33.0/gitbucket.war

Or view most recent releases

https://github.com/gitbucket/gitbucket/releases

## Create a /gitbucket directory and upload the gitbucket.war file to your IFS using your favorite binary file transfer method

## Log in to IFS and from an SSH bash shell, QSH or QP2TERM, run the following commands
```
cd /

mkdir gitbucket
```

## From a shell attempt to start Gitbucket with following commands
```
cd /gitbucket

java -jar gitbucket.war
```

## Wait a few minutes and try to access the Gitbucket URL from your IBM i 
```http://[hostname]:8080/```   User/pass: root/root

## See Gitbucket site or Gitbucket github site for more documentation
```
https://gitbucket.github.io/

https://github.com/gitbucket/gitbucket
```






