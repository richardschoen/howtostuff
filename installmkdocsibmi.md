# How to install MKDocs on IBM i 
MKDocs is an open source Python static site generator for creating documentation using Markdown syntax documents. No database required.

## Visit the MKDocs site
https://www.mkdocs.org

## Pre-requisites

Make sure Python 3 is installed and running on your IBM i system from the IBM Open Source Package Management options in IBM ACS. 

## Install MKDocs using pip3

Log in to IFS from an SSH bash shell session, QSH or QP2TERM, run the following commands to install MKDocs as part of your default Python 3 environment
```
pip3 install mkdocs
pip3 install lunr
```
Install themes
```
pip3 install mkdocs
pip3 install lunr
```
**Note: There may be additional items needed that my system already had, but I have not identified if there are other specific requirements.**

## Create and run your first documentation site on port 8555
```
cd /

mkdocs new docproject1

cd /docproject1

mkdoc serve --dev-addr=0.0.0.0:8555
```
Visit your new documentation site in the browser: http://ibmiaddress:8555

## Setting default host address and theme info in mkdoc.yml site config file

edit /docproject1/mkdocs.yml file

```
site_name: My IBM i Documentation
dev_addr: 0.0.0.0:8555
theme: yeti
nav:
    - Home: index.md
    - About: about.md
```
These settings assume you will create a new about.md markdown page in your project directory.

## See MKDocs site for more documentation
https://www.mkdocs.org
