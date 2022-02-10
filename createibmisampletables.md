# Create IBM i DB2 Sample Database Tables
The following commands can be run from IBM ACS Run SQL Scripts to create a sample IBM i library with sample tables in it. 

Visit this IBM i site for info on the sample tables:

https://www.ibm.com/docs/en/i/7.3?topic=reference-db2-i-sample-tables

Create sample IBM i database tables in a library called **SAMPLE**

```CALL QSYS.CREATE_SQL_SAMPLE ('SAMPLE')```

Create sample IBM i database tables that contain embedded XML in a library called **SAMPLE**

```CALL QSYS.CREATE_XML_SAMPLE ('SAMPLE')```

After the SAMPLE library has been created the tables should exist. You can check with the following command

```WRKOBJPDM SAMPLE```

Sample SQL query to select data from customer table in SAMPLE library

```
select * from sample/customer  
-or- 
select * from sample.customer  
```
