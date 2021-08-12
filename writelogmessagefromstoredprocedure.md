# Write log message to selected message queue from stored procedure

This sample creates a CL command, CL program and a stored procedure to test with from ACS or STRSQL. 

Messages are written by default to message queue: QSYS/QSYSOPR, but can be overridden or the CL program can call an RPG program or any other code. 

## CL Command - OPPGMMSG.CMD
```
* CRTCMD CMD(QGPL/OPPGMMSG)                  */                      
*        PGM(QGPL/OPPGMMSGC)                 */                      
*        SRCFILE(RJSDEVMB/SRCOPNUTIL)        */                      
*        SRCMBR(OPPGMMSG)                    */                      
*        PRDLIB(QGPL)                        */                      
*        REPLACE(*YES)                       */                      
            CMD        PROMPT('Send Program Message')                
            PARM       KWD(MSGDTA) TYPE(*CHAR) LEN(255) MIN(1) +     
                         CASE(*MIXED) PROMPT('Message date')         
            PARM       KWD(MSGQ) TYPE(*CHAR) LEN(10) DFT(QSYSOPR) +  
                         CASE(*MIXED) PROMPT('Message queue')        
            PARM       KWD(MSGQLIB) TYPE(*CHAR) LEN(10) +            
                         DFT(QSYS) CASE(*MIXED) PROMPT('Message +    
                         queue')                                     
```

## CL Command Processing Program OPPGMMSGC.CLP
```
             PGM        PARM(&MSGDTA &MSGQ &MSGQLIB)                  
                                                                      
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(255)             
             DCL        VAR(&MSGQ) TYPE(*CHAR) LEN(10)                
             DCL        VAR(&MSGQLIB) TYPE(*CHAR) LEN(10)             
                                                                      
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERRORS))      
                                                                      
             /* SEND PROGRAM  MESSAGE */                              
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOPGMQ(*SAME) TOMSGQ(&MSGQLIB/&MSGQ) +      
                          MSGTYPE(*INFO)                              
             RETURN                                                   
                                                                      
             /* HANDLE SEND MESSAGE ERRORS */                         
ERRORS:                                                               
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Errors +
                          running OPPGMMSG') TOMSGQ(*SYSOPR) +       
                          MSGTYPE(*INFO)                             
             /* DISPLAY JOBLOG ON ANY FAILURE */                     
             DSPJOBLOG  OUTPUT(*PRINT)                               
             MONMSG     MSGID(CPF0000)                               
                                                                     
             ENDPGM                                                  
```

## Sample Stored Procedure SpOpPgmMsg that uses OPPGMMSG CL command
The stored procedure writes to message queue: QSYS/QSYSOPR
```
CREATE OR REPLACE PROCEDURE
    QGPL.SpOpPgmMsg
    (
    )
    LANGUAGE SQL
    MODIFIES SQL DATA
    BEGIN
        
        DECLARE msgvar varchar(255);

        set msgvar = 'I am a test message';
                
        Call QSYS2.QCMDEXC('RJSDEVMB/OPPGMMSG MSGDTA('''|| msgvar ||''') MSGQ(QSYSOPR) MSGQLIB(QSYS)');

    END
;
```

## Call Sample Stored Procedure SpOpPgmMsg
```
call QGPL.SpOpPgmMsg();
```

## Sending Message Back via Output Parameter from Stored Procedure
This example allows you to output any return parameters in the ACS message list at the bottom of the Run SQL Statements screen. 

```
--Sample Stored Procedure
CREATE OR REPLACE PROCEDURE
    QGPL.SpOpPgmMsg
    (
     OUT msgvar varchar(255)
    )
    LANGUAGE SQL
    MODIFIES SQL DATA
    BEGIN
        
        --DECLARE msgvar varchar(255);

        set msgvar = 'I am a test message';

    END
;
```

## Call sproc with ? parameter marker/placeholder for output parameter. This will get ACS to output to its message window.
```
call QGPL/SpOpPgmMsg(?);
```

## This is what ACS shows after call to stored procedure
Return Code = 0 
**Output Parameter #1 (MSGVAR) = I am a test message**   
Statement ran successfully   (152 ms)
