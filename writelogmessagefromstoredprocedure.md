# Write log message to selected message queue from stored procedure

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




