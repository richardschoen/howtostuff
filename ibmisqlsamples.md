# IBM i SQL Samples

## Select all spool files matching a specific spool file name
```
SELECT * FROM QSYS2.OUTPUT_QUEUE_ENTRIES_BASIC WHERE     
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
