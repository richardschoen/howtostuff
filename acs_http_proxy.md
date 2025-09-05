# Use ACS HTTP Proxy to Install Python, Node and Other Open-Source Packages
Article source: https://www.seidengroup.com/php-documentation/offline-installation-of-communityplus-php/

For IBM i systems not connected to the internet, you can install the IBM and Seiden PHP+ repositories through alternate means.

This article explains two different ways to install open source on your IBM i without a direct internet connection:

Use an HTTP proxy (for IBM i systems with restricted access, but PCs have access to the outside)
“Clone” an offline copy of IBM and PHP+ repositories using IBM i Access Client Solutions (ACS). (for sharing with completely airgapped systems)
You’ll need the latest version of ACS as a prerequisite; we recommend at least 1.1.8.5. Older versions do not support repository cloning properly.

## HTTP proxy
This method uses ACS to create a proxy on your PC through which your IBM i can connect to the internet.

Starting ACS in proxy mode
From a command prompt on your PC, run java -jar acsbundle.jar /PLUGIN=httproxyui, adjusting the path for the location of “acsbundle.jar”.

Example commands:
```
# If ACS is in your current directory:
java -jar acsbundle.jar /PLUGIN=httpproxyui
# Default installation location on Mac:
java -jar /usr/local/ibmiaccess/acsbundle.jar /PLUGIN=httpproxyui
# Default installation location on Linux:
java -jar /opt/ibm/iAccessClientSolutions/acsbundle.jar /PLUGIN=httpproxyui
```

A dialog will appear. Select your system and enter the credentials needed to log onto SSH. Make sure the SSH daemon is running.   

This command launches an HTTP Proxy program that connects to the internet. ACS will then connect using the proxy.

To aid in installing open source, the HTTP Proxy window also provides commands that allow an SSH terminal to use the proxy. When you copy and paste these commands into an SSH terminal, programs in that session will use the HTTP proxy. For example, you can run yum commands on an IBM i system that couldn’t connect to the repository otherwise, and it’ll proxy through your own computer to reach that repository.

Example SSH commands needed from any SSH command line once the proxy is started:    
```
Proxy Initialized
To use this proxy, run the following commands in an SSH terminal:
https_proxy=http://5e11383af7d34ffcb886:0cc51e1a08e2@localhost:47807
export https_proxy
http_proxy=http://5e11383af7d34ffcb886:0cc51e1a08e2@localhost:47807
export http_proxy
```
Once the proxy is running you should be able to run any commands suuch as ```yum```, ```wget``` or ```pip``` that need http or https access.  

## Sample Windows bat script file - stracshttpproxy.bat
```
REM https://www.seidengroup.com/php-documentation/offline-installation-of-communityplus-php/
REM Proxy Server https
REM In SSH windows, set env vars
REM Proxy Initialized
REM To use this proxy, run the following commands in an SSH terminal:
REM https_proxy=http://5e11383af7d34ffcb886:0cc51e1a08e2@localhost:47807
REM export https_proxy
REM http_proxy=http://5e11383af7d34ffcb886:0cc51e1a08e2@localhost:47807
REM export http_proxy
C:
cd %~dp0
java -jar acsbundle.jar /PLUGIN=httpproxyui
pause
```
