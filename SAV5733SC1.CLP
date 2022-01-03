 /* Save 5733CS1 *BASE and option 1 */
             PGM

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERRORS))

 /* Create temp save files */
             CRTSAVF    FILE(QTEMP/Q5733SC1B) TEXT('5733SC1 - *BASE +
                          option')
             MONMSG     MSGID(CPF0000)
             CRTSAVF    FILE(QTEMP/Q5733SC11) TEXT('5733SC1 - option +
                          1')
             MONMSG     MSGID(CPF0000)

 /* Clear the saves file now  */
             CLRSAVF    FILE(QTEMP/Q5733SC1B)
             CLRSAVF    FILE(QTEMP/Q5733SC11)

 /* Save 5733SC1 licensed program */
             SAVLICPGM  LICPGM(5733SC1) DEV(*SAVF) OPTION(*BASE) +
                          SAVF(QTEMP/Q5733SC1B) TGTRLS(*CURRENT) +
                          LICACPRQD(*NO)
             SAVLICPGM  LICPGM(5733SC1) DEV(*SAVF) OPTION(1) +
                          SAVF(QTEMP/Q5733SC11) TGTRLS(*CURRENT) +
                          LICACPRQD(*NO)

 /* Copy save files to IFS */
             CPYTOSTMF  +
                          FROMMBR('/QSYS.LIB/QTEMP.LIB/Q5733SC1B.FILE+
                          ') TOSTMF('/tmp/q5733sc1b.savf') +
                          STMFOPT(*REPLACE) CVTDTA(*NONE)
             CPYTOSTMF  +
                          FROMMBR('/QSYS.LIB/QTEMP.LIB/Q5733SC11.FILE+
                          ') TOSTMF('/tmp/q5733sc11.savf') +
                          STMFOPT(*REPLACE) CVTDTA(*NONE)

             RETURN

ERRORS:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Errors +
                          occurred while saving licensed program.') +
                          MSGTYPE(*ESCAPE)

             ENDPGM
