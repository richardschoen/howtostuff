 /* Restore 5733CS1 *BASE and option 1 */
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

 /* Copy from IFS to save files */
             CPYFRMSTMF FROMSTMF('/tmp/q5733sc1b.savf') +
                          TOMBR('/QSYS.LIB/QTEMP.LIB/Q5733SC1B.FILE') +
                          MBROPT(*REPLACE) CVTDTA(*NONE)
             CPYFRMSTMF FROMSTMF('/tmp/q5733sc11.savf') +
                          TOMBR('/QSYS.LIB/QTEMP.LIB/Q5733SC11.FILE') +
                          MBROPT(*REPLACE) CVTDTA(*NONE)

 /* Restore 5733SC1 licensed program from save files */
             RSTLICPGM  LICPGM(5733SC1) DEV(*SAVF) OPTION(*BASE) +
                          SAVF(QTEMP/Q5733SC1B)
             RSTLICPGM  LICPGM(5733SC1) DEV(*SAVF) OPTION(1) +
                          SAVF(QTEMP/Q5733SC11)

             RETURN

ERRORS:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Errors +
                          occurred while restoring licensed program.') +
                          MSGTYPE(*ESCAPE)

             ENDPGM
