# curl command line examples
This document lists some sample curl command examples. These can be run from a bash command line on in conjunction with the QSHEXEC command from the QSHONI library on IBM i. http://www.github.com/richardschoen/qshoni 

The bash commnad line samples should also be compatible with Linux and other platforms, just remove the path qualifier (/QOpenSys/pkgs/bin) when not using IBM i. The reason I used the path qualifier is that if an older version of curl is loaded on the IBM i machine, it will get picked up by QShell or PASE, so we want to make sure we call the version in /QOpenSys/pkgs/bin always on IBM i.

## Sample bash command line to download a save file of the QSHONI library with binary contents intact
```
/QOpenSys/pkgs/bin/curl -o /tmp/qshoni.savf -LJO https://github.com/richardschoen/QshOni/releases/download/V1.0.2/qshoni.sav
```

## Sample QSHEXEC command line to download a save file of the QSHONI library with binary contents intact
```
QSHONI/QSHEXEC 
 CMDLINE('/QOpenSys/pkgs/bin/curl -o /tmp/qshoni.savf -LJO 
 https://github.com/richardschoen/QshOni/releases/download/V1.0.2/qshoni.savf') 
 DSPSTDOUT(*YES) PRTSTDOUT(*YES) PRTSPLF(CURLLOG)                                  
```

# Curl documentation

Curl manual page
https://curl.se/docs/manpage.html

How to Use Curl Command with Examples
https://linoxide.com/tools/how-to-use-curl-command/

If you google: ***how to use curl*** you will find many other example sites for using curl. 

Let me know by posting in the issues if you have a cool command combination to share. 

