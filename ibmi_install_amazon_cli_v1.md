# Installing and Using Amazon CLI on IBM i for S3 File/Object Management  
The Amazon command line interface (CLI) allows IBM i developers to interact with their Amazon services from the IBM i PASE command line..  

Probably the most common use for the Amazon CLI might be to upload and download file objects from S3 storage buckets for use with IBM i. 

Also there are other cloud providers now providing S3 cloud compatible storage so you're not limited to Amazon as your cloud S3 provider.      
  
I took inspiration for this how-to from Diego Kesselman's article on LinkedIn to create this how-to.   

# Potential use cases
Here are a few potential use cases for S3 storage and the Amazon CLI:   

Saving libraries or IFS files to save files and uploading to Amazon S3 storage.   

Downloading and restoring a library or IFS files from a save file stored on Amazon S3 storage.

Uploading daily reports and other files to shared Amazon directories. (Similar to SharePoint).    

Uploading files to S3 storage so a trading partner can retrieve them.    

Upload working files from mobile devices to be picked up later by IBM i.   

Downloading files from S3 storage uploaded by a trading partner.    

# Amazon CLI Usage Links  
Link to Diego Kesselman's Linked in Article  (inspiration for this page)   
https://www.linkedin.com/pulse/ibm-i-having-fun-cloud-object-storage-cos-diego-kesselman    

Amazon CLI V1 Documentation  (There is a V2 API, but V1 is what is supported via Python3 currently)   
https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html     

# Installing on IBM i 

## Pre-requisite
OS level should be IBM i V7R3 or above.   
   
Make sure all ```Python 3``` options are installed by the '``Open Source Package Management``` menu option in ACS.   

Log in to an IBM i SSH terminal session and make sure bash is the current shell.     

## Install the Amazon CLI in PASE  
Run following command from SSH terminal.   
```pip3 install awscli```

## Set up your Amazon Credentials  
Run following command from SSH terminal.   
 ```aws configure```

 You will be prompted for your ```aws_access_key``` and ```aws_secret_access_key``` and region info as well. I only entered my access key and secret access key. 

The settings get saved in the following file for each user under their HOME directory:   
```~/.aws/credentials```

## Lets list our Amazon S3 Buckets 
Play around with the following aws list CLI commands.    

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
## Let's download a file from our Amazon S3 bucket to the IFS
The following example aws CLI commands can be used to download files from an S3 bucket to an IFS directory.   

```aws s3 cp s3://mybucket1/dir1/BACKUPIFS-20230827.zip   /tmp/BACKUPIFS-20230827.zip``` will download the ZIP backup file from S3 mybucket1/dir1 folder to the /tmp folder on our IFS.    
   
Successful download response:     
```download: s3://mybucket//dir1/BACKUPIFS-20230827.zip to ../../../tmp/BACKUPIFS-20230827.zip```   
   
```aws s3 cp s3://mybucket1/dir1/BACKUPIFS-20230830.zip   /tmp/BACKUPIFS-20230830.zip``` will try to download the non-existent backup ZIP file from S3 mybucket1/dir1 to the /tmp folder on our IFS but will fail because no file is found on S3 with this name.   

Error download response when file not found:     
```fatal error: An error occurred (404) when calling the HeadObject operation: Key "dir1/BACKUPIFS-20230830.zip" does not exist```   

## Let's upload an IFS file to our Amazon S3 bucket
The following example aws CLI commands can be used to upload files to an S3 bucket from an IFS directory.   

```aws s3 cp /tmp/BACKUPIFS-20230827.zip s3://mybucket1/dir1/BACKUPIFS-20230827.zip``` will upload the selected ZIP file from the /tmp IFS directory to S3 mybucket1/dir1.    

Successful upload response:    
```upload: ../../../tmp/BACKUPIFS-20230827.zip to s3://mybucket//dir1/BACKUPIFS-20230827.zip```   
   
```aws s3 cp /tmp/BACKUPIFS-20230827.zip s3://mybucket1/dir3/BACKUPIFS-20230827.zip``` will upload the selected ZIP file from the /tmp IFS directory to S3 mybucket1/dir3. (If dir3 does not exist in the bucket it will get automatically created.)     

Successful upload response:   
```upload: ../../../tmp/BACKUPIFS-20230827.zip to s3://mybucket//dir3/BACKUPIFS-20230827.zip```
   
```aws s3 cp /tmp/BACKUPIFS-20230827.zip s3://mybucket111/dir1/BACKUPIFS-20230827.zip``` will error while uploading the selected ZIP file from the /tmp IFS directory to S3 mybucket111/dir. (Bucket mybucket111 does not exist.)  

Error upload response when bucket not found:     
```
upload failed: ../../../tmp/BACKUPIFS-20230827.zip to s3://mybucket111/dir1/BACKUPIFS-20230827.zip
An error occurred (NoSuchBucket) when calling the PutObject operation: The specified bucket does not exist
```
## More to come
As I play more with the Amazon CLI I will update this article. There are lots of potential uses for the aws CLI command from IBM i.  

Feel free to send your updates to me for adding to the article by doing a pull request or creating an issue.     

## Watch Out For 
As I was testing I found out that as of 8/28/2023, it appears that the version of the ```botocore``` framework used by ```awscli``` is a bit different than the version that is used by the ```s3fs``` Package I've used for other Python Amazon S3 processes.   

As of 8/28/2023   
```awscli``` uses the following botocore version: botocore==1.31.36 with Python 3.9 on IBM i   
```s3fs``` uses the following botocore version: botocore==1.27.59 with Python 3.9 on IBM i   

Because of thie you may want to create a separate virtual environment for the ```awscli``` if you're also using something like s3fs. 

## Quickly create a virtual environment for awscli
We will make a virtual environmnet for the aws cli in IFS directory ```/awsclivenv```    

Create the environment without system packages (Recommended for a clean Python environment)   
```
cd /
python3 -m venv awsclienv
```

If you want an environment with a copy of your system packages.   
```
cd /
python3 -m venv awsclienv --system-site-packages
```

Activate the environment   
```source /awsclivenv/bin/activate```   

List your pip packages installed after activation.   
```pip3 list ```   

Install Amazon aws cli or other needed pip packages in the virtual environment (venv)
```pip3 install awscli``` 

Run any aws cli commands after environment has been activated.   

Deactivate environment when done   
```deactivate``` 

Single command line to activate and run AWS dir list command   
```source /awsclivenv/bin/activate;aws s3 ls s3://mybucket1/;deactivate```   












