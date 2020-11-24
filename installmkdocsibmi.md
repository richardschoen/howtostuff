# How to install MKDocs on IBM i 
MKDocs is an open source Python static site generator for creating documentation using Markdown syntax documents. No database required.

This is a quick way to establish a departmental knowledgebase with shareable system and process documentation. 

A MKDocs project directory structure could also be turned into a git project if desired so the entire site would be versioned in a git repository.

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
Install themes - Themes can be tweaked as desired.
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

## See MKDocs site for more documentation on building your documentation sites with markdown files
https://www.mkdocs.org

##Styling Your Docs with Themes
https://www.mkdocs.org/user-guide/styling-your-docs/

## 3rd Party Themes
https://github.com/mkdocs/mkdocs/wiki/MkDocs-Themes
