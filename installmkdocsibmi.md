# How to install MKDocs on IBM i 
MKDocs is an open source Python static site generator for creating documentation using Markdown syntax documents. 

No database required. And technically no web server either since the **build** option creates a static, standalone HTML site.

This is a quick way to establish a departmental knowledgebase with shareable system and process documentation. 

A MKDocs project directory structure could also be turned into a git project if desired so the entire site would be versioned in a git repository.

## Visit the MKDocs site
https://www.mkdocs.org

## Pre-requisites

Make sure Python 3 is installed and running on your IBM i system from the IBM Open Source Package Management options in IBM ACS. 

https://www.ibm.com/support/pages/getting-started-open-source-package-management-ibm-i-acs

:pushpin: This usually means installing the entire Python 3 option set and gcc compiler via ACS, including python3-devel to make sure python.h is found.
```
 gcc-aix
 gcc-cplusplus-aix
 gcc-cpp-aix
 python3                    
 python3-Pillow             
 python3-asn1crypto         
 python3-bcrypt             
 python3-cffi               
 python3-cryptography       
 python3-dateutil           
 python3-devel              
 python3-ibm_db             
 python3-idna               
 python3-itoolkit           
 python3-jinja2             
 python3-lxml               
 python3-markupsafe         
 python3-numpy              
 python3-pandas             
 python3-paramiko           
 python3-pip                
 python3-psutil             
 python3-psycopg2           
 python3-pycparser          
 python3-pynacl             
 python3-pyodbc             
 python3-pytz               
 python3-pyyaml             
 python3-pyzmq              
 python3-rpm                
 python3-scikit-learn       
 python3-scipy              
 python3-setuptools         
 python3-six                
 python3-tkinter            
 python3-wheel              

Or you could install gcc and python3 using the following commands from bash: 
yum install gcc*
yum install python3*
```

## Install MKDocs using pip3

Log in to IFS from an SSH bash shell session, QSH or QP2TERM, run the following commands to install MKDocs as part of your default Python 3.6 environment installed in /QOpenSys/pkgs/bin

**Note:** We will set the path so Python 3.6 is picked up from /QOpenSys/pkgs/bin

```
## Set the path so /QOpenSys/pkgs/bin is first in the list
PATH=/QOpenSys/pkgs/bin:/QOpenSys/usr/bin:/usr/ccs/bin:/QOpenSys/usr/bin/X11:/usr/sbin:.:/usr/bin
export PATH

## Run pip upgrade to make sure pip3 is current. (Version 19, 20 or newer after upgrade should be good. Mine is 20.3.3 as of 12/19/2020)
## If pip is not current then the correct current version Python package versions may not install.
pip3 install --upgrade pip 

## Check to make sure Python shows V3.6.x
python3 -V    (to verify we are seeing Python 3.6.x. Current version 3.6.12 as of 12/19/2020)

## Run the MKDocs install process
pip3 install mkdocs

```
When install completes you should see something like the following
```
Successfully built regex
Installing collected packages: regex, nltk, lunr, mkdocs
Successfully installed lunr-0.5.8 mkdocs-1.1.2 nltk-3.5 regex-2020.11.13
```

Install themes - Themes can be tweaked as desired. We will install the Bootswatch theme and then select yeti below when we edit the mkdocs.yml site configuration file.
```
pip3 install mkdocs-bootswatch
```
**Note: There may be additional items needed that my system already had, but I have not identified if there are other specific requirements.**

## Create and run your first documentation site on port 8555
```
cd /

mkdocs new docproject1

cd /docproject1

mkdocs serve --dev-addr=0.0.0.0:8555
```
Visit your new documentation site in the browser: http://ibmiaddress:8555

## If you get errors during startup of MkDocs
```
## I had an issue where the server didn't lke the livereload version and tornado versions.
## I got the following error:
##    raise VersionConflict(dist, req).with_context(dependent_req)
##pkg_resources.ContextualVersionConflict: (tornado 6.1 (/QOpenSys/pkgs/lib/python3.6/site-packages), Requirement.parse('tornado<6'), {'livereload'})

## The following pip upgrade fixed livereload and then I could run the mkdocs server
## It uninstalled tornado v6.1 and installed v5.1.1. On another server I already have
## tornado 6.1 and mkdocs works fine. Not sure why, but this solved the issue.
pip3 install --upgrade livereload
```

## Setting default host address and theme info in mkdoc.yml site config file

edit /docproject1/mkdocs.yml file and add the following contents. Tailor them to your liking.

```
site_name: My IBM i Documentation
dev_addr: 0.0.0.0:8555
theme: yeti
nav:
    - Home: index.md
    - About: about.md
```
These settings assume you will plan to create a new about.md markdown page in your project directory.

## Submitting MKDocs serve to Run as A Batch Job

The following command submits the MKDOCS job to run as a batch server in subsystem QSYSWRK via job queue QSYSNOMAX 
```
SBMJOB CMD(QSHEXEC CMDLINE('cd /docproject1;mkdocs serve') PRTSPLF(MKDOCS) PRTUSRDTA(*YES)) JOB(MKDOCS) JOBQ(QSYSNOMAX) JOBMSGQFL(*WRAP)                                       
```  
In order to use the QSHEXEC command to run the MKDocs server or other QShell/PASE commands, you must install the command from the following site: https://github.com/richardschoen/QshOni

## Building and Deploying your Static Site

This example builds a site directory from a MkDocs project directory named: /docproject1. Once the site is built, simply deploy the /docproject1/site folder to your web site or view the site from a network directory by opening index.html. 

Then you don't need anything special to access your site other than a web browser. 

```
cd /

cd /docproject1

mkdoc build
```

That's it. Your static site is ready to go.

## See MKDocs site for more documentation on building your documentation sites with markdown files
https://www.mkdocs.org

## Styling Your Docs with Themes
https://www.mkdocs.org/user-guide/styling-your-docs/

## 3rd Party Themes
https://github.com/mkdocs/mkdocs/wiki/MkDocs-Themes
