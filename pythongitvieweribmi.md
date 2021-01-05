# Installing Python git viewer on IBM i 

Klause is a Python based git repository viewer for viewing local file system repositories. 

For this use-case we will be viewing repositories stored in the IBM IFS file system.

Github site for Klause

https://github.com/jonashaag/klaus

# Prerequisites
Make sure all Python 3 yum packages installed on IBM i 

Install the following Python modules
```
pip3 install klaus
```
**If you get any errors during install, please note them here.**

# Running Klaus git server

This example runs the Klaus git server over repositories GITTEST123 and GITTEST124 on HTTP port 4646 and is litening on all IP addresses.

```
klaus --host 0.0.0.0 --port 4646 /gitrepostest/GITTEST123 /gitrepostest/GITTEST124
```
# Links
See the Klause site for further documentation

https://github.com/jonashaag/klaus
