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

### Sample script file for Windows - stacshttpproxy.bat
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
