# IBM i SQL Samples

## Select all spool files matching a specific spool file name - Basic
```
SELECT * FROM QSYS2.OUTPUT_QUEUE_ENTRIES_BASIC WHERE     
SPOOLED_FILE_NAME like 'LABINV'                          
```
## Select all spool files matching a specific spool file name - Extended
```
SELECT * FROM QSYS2.OUTPUT_QUEUE_ENTRIES WHERE     
SPOOLED_FILE_NAME like 'LABINV'                          
```

## Select object statistics for a library
```
SELECT * FROM TABLE                                   
(QSYS2.OBJECT_STATISTICS('QGPL','ALL')) AS A       
```
## Select object statistics for a library
```
SELECT * FROM TABLE                                   
(QSYS2.OBJECT_STATISTICS('QGPL','ALL')) AS A   
```
## Select object statistics for all libraries
```
SELECT * FROM TABLE (QSYS2.OBJECT_STATISTICS('*ALL','ALL')) AS A 
```
## Select TCP info for current connection. Good for getting local PC/Server client IP
```
SELECT * FROM QSYS2.TCPIP_INFO    
```
## Netstat Connection Info
```
SELECT * FROM QSYS2.NETSTAT_INFO 
```
## Netstat Connection Info. Check for Local Port 22 active on IPV4
```
SELECT * FROM QSYS2.NETSTAT_INFO WHERE 
CONNECTION_TYPE = 'IPV4' and local_port=22                                                        
```

## Select Active Jobs
https://www.rpgpgm.com/2015/11/getting-active-jobs-data-using-sql.html
https://www.rpgpgm.com/2019/07/extracting-jobs-name-from-job-name.html
```
// Select all jobs
SELECT JOB_NAME,JOB_TYPE,JOB_STATUS,SUBSYSTEM,                   
           ELAPSED_CPU_PERCENTAGE AS PERCENT                     
FROM TABLE(QSYS2.ACTIVE_JOB_INFO(JOB_NAME_FILTER => '*ALL')) A   
ORDER BY ELAPSED_CPU_PERCENTAGE DESC

// Filtering by job status
SELECT JOB_NAME,JOB_TYPE,JOB_STATUS,SUBSYSTEM
    FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) B
   WHERE JOB_STATUS = 'MSGW'
   ORDER BY JOB_NAME

// Filtering by job name
SELECT JOB_NAME,JOB_TYPE,JOB_STATUS,SUBSYSTEM,
         CPU_TIME
    FROM TABLE(QSYS2.ACTIVE_JOB_INFO()) C
   WHERE JOB_NAME LIKE '%SIMON%'
   ORDER BY CPU_TIME DESC

// Query and Parse Job Info
SELECT SUBSTR(JOB_NAME,                                     
LOCATE_IN_STRING(JOB_NAME,'/',-1)+1) as JOBNAME,            
       SUBSTR(JOB_NAME,                                     
LOCATE_IN_STRING(JOB_NAME,'/',1)+1,                         
(LOCATE_IN_STRING(JOB_NAME,'/',-1)-1)                       
- (LOCATE_IN_STRING(JOB_NAME,'/',1))) as JOBUSER,           
       SUBSTR(JOB_NAME,1,6) as JOBNUMBER                    
FROM                                                        
TABLE(QSYS2.ACTIVE_JOB_INFO(JOB_NAME_FILTER => '*ALL')) A   

```
