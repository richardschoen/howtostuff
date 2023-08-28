# Installing and Using Amazon CLI on IBM i for S3 File/Object Management  
The Amazon command line interface (CLI) allows IBM i developers to interact with their Amazon services from the IBM i PASE command line.   

Probably the most common use for the Amazon CLI might be to upload and download file objects from S3 storage buckets for use with IBM i. 

Also there are other cloud providers now providing S3 cloud compatible storage so you're not limited to Amazon as your cloud S3 provider.      
  
I took inspiration for this how-to from Diego Kesselman's article on LinkedIn to create this how-to.   

# Potential use cases
Here are a few potential use cases for S3 storage and the Amazon CLI.

Saving libraries or IFS files to save files and uploading to Amazon S3 storage.   

Uploading daily reports and other files to shared Amazon directories. (Similar to SharePoint).   

Uploading files to S3 storage so a trading partner can retrieve them. 

Upload working files from mobile devices to be picked up later by IBM i.

# Amazon CLI Usage Links  
Link to Diego Kesselman's Linked in Article  (inspiration for this page)   
https://www.linkedin.com/pulse/ibm-i-having-fun-cloud-object-storage-cos-diego-kesselman    

Amazon CLI V1 Documentation  (There is a V2 API, but V1 is what is supported via Python3 currently)   
https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html     

# Installing on IBM i 

## Pre-requisite

Make sure all ```Python 3``` options are installed by the '``Open Source Package Management``` menu option in ACS

Log in to an IBM i SSH terminal session and make sure bash is the current shell

## Install the Amazon CLI in PASE  

```pip3 install awscli```

## Set up your Amazon Credentials  

 ```aws configure```

 You will be prompted for your ```aws_access_key``` and ```aws_secret_access_key and region info as well.

The settings get saved in the following file for each user: 
```~/.aws/credentials```

## Lets list our Amazon S3 Buckets 
Play around with the following commands.    

```aws s3 ls``` will display a list of all your available buckets at the command line.   
```
2015-11-04 16:48:52 mybucket1
2016-01-02 11:39:04 mybucket2
```
   
```aws s3 ls s3://mybucket1/``` will list all files and directories in mybucket1. Mine shows the following subdirectories. They may show ```PRE``` on the fornt of the list entries for a directory. 
```
PRE dir1/
PRE dir2/
```

```aws s3 ls s3://mybucket1/dir1/``` will list all files and directories in mybucket1 under the dir1 directory.  
```
2023-08-27 08:32:33     155232 BACKUPIFS-20230827.zip
2023-08-28 14:31:26     155232 BACKUPIFS-20230828.zip
```
## More to come
As I play more with the Amazon CLI I will update this article. 

Feel free to send your updates to me for adding to the article by doing a pull request or creating an issue.   

