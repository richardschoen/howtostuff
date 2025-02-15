# Instructions to successfully build ILEAstic from GitHub
It appears there is an issue building the ILEAstic and NOXDB applications from the initial git close using an SSH terminal.

However the build process does seem to work via a QShell terminal.  Not sure wht but it works.   

The open project issue is: Install gmake issue #153   
https://github.com/sitemule/ILEastic/issues/153   

Site for ILEAstic   
https://github.com/sitemule/ILEastic   

## The issue with building from an SSH terminal
- Before trying to QSH install I tried building via a bash session via an SSH terminal.  I made sure that the ```/QOpenSys/pkgs/bin``` open source packages were in my search path. However when I tried the build steps as listed on the readme.md page from SSH, the build failed based on same error as issue #53 above.

- Based on the issue, what I learned from the #53 issue  is that I could build the ILEASTIC and NOXDB app libraries from the green screen using the QShell terminal interface.   
  ❗I'm not sure why this works from QShell and not SSH, but it does build.  

## Clone and build steps from a 5250 session for building ILEASTIC
- First review the readme.md on the ILEAstic site for build prerequisite requirements: https://github.com/sitemule/ILEastic   

- Sign on to a 5250 command line session with a user that has permissions to build code.

- Set the multi-threaded env variable **before starting/entering the QShell terminal**.    
```
ADDENVVAR ENVVAR('QIBM_MULTI_THREADED') VALUE('Y') CCSID(*JOB) LEVEL(*JOB) REPLACE(*YES)
```

- Start QShell terminal via ```STRQSH``` command.

- Set your path with following export statement from within QSH terminal:
```
export PATH=/QOpenSys/pkgs/bin:$PATH
```

- Run the following commands from the QSH terminal to clone and build the project. Same steps as the ILEAstic site uses.
```
mkdir /prj
cd /prj 
git -c http.sslVerify=false clone --recurse-submodules https://github.com/sitemule/ILEastic.git
cd ILEastic
gmake  
```

- If all works as expected, the ILEASTIC library should exist with the following list of objects (```WRKOBJPDM ILEASTIC```):
```
BASE64      *PGM        RPGLE       ILEastic Example Server
DATACHUNKS  *PGM        RPGLE       ILEastic Example Server
FASTCGI01   *PGM        RPGLE       ILEastic Example Server
HEADER      *PGM        RPGLE       ILEastic Example Server
HELLOWORLD  *PGM        RPGLE       ILEastic Example Server
INVALIDREQ  *PGM        RPGLE       ILEastic Example Server
JSONDATA    *PGM        RPGLE       ILEastic Example Server
JSONP       *PGM        RPGLE       ILEastic Example Server
MULTROUTES  *PGM        RPGLE       ILEastic Example Server              
NOXDBCUST   *PGM        RPGLE       ILEastic Example Server              
PLUGIN      *PGM        RPGLE       ILEastic Example Server              
QUERYSTR    *PGM        RPGLE       ILEastic Example Server              
ROUTEID     *PGM        RPGLE       ILEastic Example Server              
SCHEDULER   *PGM        RPGLE       ILEastic Example Server              
STATICFILE  *PGM        RPGLE       ILEastic Example Server              
ILEASTIC    *SRVPGM     CLE         ILEastic - programable applicationserver for ILE
ILEFASTCGI  *SRVPGM     CLE                                           
JSONXML     *SRVPGM                                                   
H           *FILE       PF-SRC                                        
QCLLESRC    *FILE       PF-SRC                                        
QRPGLEREF   *FILE       PF-SRC                                        
QSRVSRC     *FILE       PF-SRC                                        
ILEASTIC    *BNDDIR                                                   
JSONXML     *BNDDIR                                                   
NOXDB       *BNDDIR
```

- If all works as expected, the NOXDB library should exist with the following list of objects (```WRKOBJPDM NOXDB```):
```
PARSETEST   *PGM        RPGLE                                
JSONXML     *SRVPGM                                          
DATAGEN     *MODULE     CLE                                  
DATAINTO    *MODULE     CLE                                  
GENERIC     *MODULE     CLE                                  
HTTP        *MODULE     CLE                                  
ITERATOR    *MODULE     CLE                                  
JSONPARSER  *MODULE     CLE
MEM001      *MODULE     CLE       
NOXDB       *MODULE     CLE       
PARMS       *MODULE     CLE       
READER      *MODULE     CLE       
RTVSYSVAL   *MODULE     CLE       
SEGMENTS    *MODULE     CLE       
SERIALIZER  *MODULE     CLE       
SNDPGMMSG   *MODULE     CLE
SQLIO       *MODULE     CLE  
SQLWRAPPER  *MODULE     CLE  
STREAM      *MODULE     CLE  
TIMESTAMP   *MODULE     CLE  
TRACE       *MODULE     CLLE 
TRYCATCH    *MODULE     CLE  
UTL100      *MODULE     CLE  
VARCHAR     *MODULE     CLE
XLATE       *MODULE     CLE           
XMLPARSER   *MODULE     CLE           
XMLSERIAL   *MODULE     CLE           
EVFEVENT    *FILE       PF-DTA        
H           *FILE       PF-SRC        
QCLLESRC    *FILE       PF-SRC        
QRPGLEREF   *FILE       PF-SRC        
QSRVSRC     *FILE       PF-SRC
SQLTRACE    *DTAARA                 SQL trace enabled 
JSONXML     *BNDDIR                                   
NOXDB       *BNDDIR                                   
```

Now that the ILEASTIC and NOXDB libraies exist you are ready to start building HTTP server apps with ILEastic.

Re-visit the site to continue: https://github.com/sitemule/ILEastic   







 
  
