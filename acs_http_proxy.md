# Use ACS HTTP Proxy to Install Python, Node and Other Open-Source Packages

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
