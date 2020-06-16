# IBM i SQL Samples

## Select all spool files matching a specific spool file name
```
SELECT * FROM QSYS2.OUTPUT_QUEUE_ENTRIES_BASIC WHERE     
SPOOLED_FILE_NAME like 'LABINV'                          
```
