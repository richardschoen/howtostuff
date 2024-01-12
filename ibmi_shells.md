# List of IBM i Shells
This is my brain dump on IBM i shells after poking around the IFS.    

I generally use bash nowadays as my main shell. 

## CALL QP2TERM 
/QOpenSys/usr/bin/-sh 

## STRQSH - Start QShell 
/QSYS.LIB/QSHELL.LIB/QZSHSH.PGM

## sh - /usr/bin/sh
/usr/bin/sh  -points to-
/QSYS.LIB/QSHELL.LIB/QZSHSH.PGM

## QShell - qsh - /usr/bin/qsh
/usr/bin/qsh -points to-
/QSYS.LIB/QSHELL.LIB/QZSHSH.PGM

## QShell - qsh - Run QShell commands from PASE
/QOpenSys/usr/bin/qsh  
-points to-
/QOpenSys/QIBM/ProdData/OS400/PASE/bin/qsh

## Korn Shell - sh - /QOpenSys/pkgs/bin/sh
/QOpenSys/usr/bin/sh  
-points to-
/QOpenSys/QIBM/ProdData/OS400/PASE/bin/ksh

## Korn Shell - ksh - /QOpenSys/pkgs/bin/ksh
/QOpenSys/usr/bin/ksh  
-points to-
/QOpenSys/QIBM/ProdData/OS400/PASE/bin/ksh

Korn Shell AIX Info   
https://www.ibm.com/docs/en/aix/7.2?topic=k-ksh-command

## Bourne Shell - bsh - /QOpenSys/pkgs/bin/bsh
/QOpenSys/usr/bin/bsh  
-points to-
/QOpenSys/QIBM/ProdData/OS400/PASE/bin/bsh

Bourne Shell AIX Info   
https://www.ibm.com/docs/en/aix/7.1?topic=shells-bourne-shell

## Bourne Again Shell - bash
/QOpenSys/pkgs/bin/bash 

## Links
V7R5 PASE   
https://www.ibm.com/docs/en/i/7.5?topic=i-pase-shells-utilities   


