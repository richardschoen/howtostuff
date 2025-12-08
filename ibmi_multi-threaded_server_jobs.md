# How to use multi-threaded PASE jobs with subsystem QUSRWRK
I was doing some open-source testing on an IBM i system that had 8gb of memory but  only .05 core of CPU power. 

I found this scenaro to be pretty slow, so I wanted to see if I could juice up the processing speed by making the PASE thread jobs re-usable. 

For my test scenario I found that this little known technique of setting up prestart jobs for programs: QP0ZSPWP or QP0ZSPWT seems to speed up PASE jobs such as the SSH server and running Yum and Python threads. 

However it doesn't make the IBM i CPU core itself any faster. 

This technique may work for other subsystems that use PASE jobs such as running PHP jobs, but may need to be tweaked if those subsystems don't use the QUSRWRK subsystem.

Jobs that typically run in QUSRWRK are the SSH server and other SSH terminal or bash jobs.   

One of the articles listed below by Dawn May covers setting this up for QShell in QINTER, but that's out of scope for this particular document.  I'm mainly focusing on QUSRWRK for the moment.      

❗WARNING: I only tested this on a development system with subsystem QUSRWRK. You will want to validate this technique is accurate before rolling it out on a production system. But for me it helped in my testing on a small machine so on larger machines with more memory and CPU your mileage may vary.

## Using VS Code on a low power IBM i CPU
This was my experience using the VS Code for i plugin on a low power CPU even once it was tweaked to run PASE threads faster.

❗For better or worse the Code for i plugin is very-chatty. It runs a bunch of startup and checking PASE commands across the wire, so on a slow IBM i machine it connects pretty slowly. I also found that saving a source member using VS Code is pretty slow on a low end .05 core processor. 

Even once I tuned the system I was testing the VS Code file open and saves were taking 15-20 seconds which was painful. 

By contrast I was testing my Work with IBM i app (https://github.com/richardschoen/workwithibmipdm), which also uses SSH, and it was taking only 1-4 seconds to upload or download a source member. RDI was also pretty fast, but it doesn't use SSH. The only thing I can attribute this to is the overhead of the VS Code for i plugin and it becomes painfully apparent on a slow IBM i fractional CPU core.   

I tested on a larger IBM i system and the VS Code startup and saving of files seems to have improved. 

Over all this will probably not be an issue on larger IBM i systems, but for me it made VS Code unusable on the low-end .05 core IBM i system I was testing with.    

## Setup steps to enable multithreading for server thread jobs QP0ZSPWP or QP0ZSPWT   
We will be adding prestart jobs to QUSRWRK to speed up multithreaded jobs for programs QP0ZSPWP or QP0ZSPWT which are used to start thread for PASE jobs.   

- Set the system level environment variable to use PASE prestart thread jobs.   
As far as I now this is the only way to utilize this setting so that any PASE job threads use the prestart thread jobs.   
**You will need to make sure** this setting doesn't have a negative effect on any other jobs running in QSYSWRK that use PASE.            
```
ADDENVVAR ENVVAR(QIBM_PASE_USE_PRESTART_JOBS)   
          VALUE(Y)                              
          LEVEL(*SYS)                           
          REPLACE(*YES)
```                
- Stop the SSH server  
```ENDTCPSVR *SSHD```
- End subsystem QUSRWRK (**assuming no active work is happening**)   
```ENDSBS SBS(QUSRWRK) OPTION(*IMMED)```

- Allow multithreading when using the QDFTSVR job description.   
**Yum failed without this** because the QDFTSVR jobs job description doesn't allow multiple threads by default.  
```
CHGJOBD JOBD(QGPL/QDFTSVR) 
         ALWMLTTHD(*YES)    
```

- Add the prestart job entries for QP0ZSPWP and QP0ZSPWT thread jobs. I went with prestarting 100 thread jobs and allowing each one to be re-used 200 times.   
❗On one of the forums I read that they recommended MAXUSE(1) so each thread ends after usage. This would mirror closer to the real-world before using prestart jobs, but I would think a larger number of re-uses could be a good thing unless QP0ZSPWP and QP0ZSPWT jobs do something that doesn't make them good candidates for re-use more than 1 time.    
```
ADDPJE SBSD(QUSRWRK)       
       PGM(QSYS/QP0ZSPWP)  
       STRJOBS(*YES)       
       INLJOBS(100)         
       THRESHOLD(2)        
       ADLJOBS(2)          
       MAXJOBS(*NOMAX)     
       JOB(QP0ZSPWP)       
       JOBD(QGPL/QDFTSVR)  
       MAXUSE(200)           
       CLS(QINTER)
```        
```
ADDPJE SBSD(QUSRWRK)       
       PGM(QSYS/QP0ZSPWT)  
       STRJOBS(*YES)       
       INLJOBS(100)         
       THRESHOLD(2)        
       ADLJOBS(2)          
       MAXJOBS(*NOMAX)     
       JOB(QP0ZSPWT)       
       JOBD(QGPL/QDFTSVR)  
       MAXUSE(200)           
       CLS(QINTER)         
```

- Start the QUSRWRK subsystem   
```STRSBS SBSD(QUSRWRK)```

- Start the SSH server    
``` STRTCPSVR **SSHD```     

Now when you use SSH or PASE commands from putty or other terminal, or if you run Yum commands, Python jobs, etc the thread jobs should now get re-used. 

- Do a WRKACTJOB on subsystem QUSRWRK and you should see this:   
```WRKACTJOB SBS(QUSRWRK)```     

Job name: ```QP0ZSPWT``` and type: ```PJ```   
```
Subsystem/Job  User        Type  CPU %  Function        Status
QUSRWRK        QSYS        SBS      .0                   DEQW 
  QP0ZSPWT     QPMGR       PJ       .0  PGM-bash         SELW 
  QP0ZSPWT     QPGMR       PJ       .0  PGM-tmux         SELW 
  QP0ZSPWT     QSECOFR     PJ       .0  PGM-sshd         SELW
```


## Check to see if thread jobs are being re-used
These command let you see what's happening with prestart jobs.    

- Watch active jobs threads during subsystem startup or once active. You can actually see all the pre-start jobs start up if you press F5 fast enough.    
```WRKACTJOB SBS(QUSRWRK)```   

You'll also see your jobs should have a type of ```PJ``` for prestart jobs.

```
Subsystem/Job  User        Type  CPU %  Function        Status
QUSRWRK        QSYS        SBS      .0                   DEQW 
  QP0ZSPWT     QPMGR       PJ       .0  PGM-bash         SELW 
  QP0ZSPWT     QPGMR       PJ       .0  PGM-tmux         SELW 
  QP0ZSPWT     QSECOFR     PJ       .0  PGM-sshd         SELW
```

When prestart jobs were disabled the WRKACTJOB probably looked more like this. You can see the jobs are started as type: ```BCI```

```
Subsystem/Job  User        Type  CPU %  Function        Status
QUSRWRK        QSYS        SBS      .0                   DEQW 
  QP0ZSPWP     QPMGR       BCI      .0  PGM-bash         SELW 
  QP0ZSPWP     QPGMR       BCI      .0  PGM-tmux         SELW 
  QP0ZSPWP     QSECOFR     BCI      .0  PGM-sshd         SELW
```

- Display active prestart jobs and statistics
These two commands will display prestart job usage.    
✔️ I found all my PASE threads run under: QP0ZSPWT once I enabled the re-use jobs settings.   
```
DSPACTPJ SBS(QUSRWRK) PGM(QSYS/QP0ZSPWT)          
DSPACTPJ SBS(QUSRWRK) PGM(QSYS/QP0ZSPWP) 
```

The screen probably looks a lot like this:
```
                          Display Active Prestart Jobs                 SYS1     
                                                         12/08/25  09:26:18 CST 
 Subsystem  . . . . . :   QUSRWRK         Reset date . . . . . :   12/05/25     
 Program  . . . . . . :   QP0ZSPWT        Reset time . . . . . :   16:29:52     
   Library  . . . . . :     QSYS          Elapsed time . . . . :   0064:56:26   
                                                                                
 Prestart jobs:                                                                 
   Current number . . . . . . . . . . . . . . . . :   50                        
   Average number . . . . . . . . . . . . . . . . :   50.0                      
   Peak number  . . . . . . . . . . . . . . . . . :   50                        
                                                                                
 Prestart jobs in use:                                                          
   Current number . . . . . . . . . . . . . . . . :   3                         
   Average number . . . . . . . . . . . . . . . . :   3.2                       
   Peak number  . . . . . . . . . . . . . . . . . :   13                        
                                                                                
                                                                                
                                                                                
                                                                                
                                                                        More...
```
```
                         Display Active Prestart Jobs                 SYS1    
                                                        12/08/25  09:26:18 CST
Subsystem  . . . . . :   QUSRWRK         Reset date . . . . . :   12/05/25    
Program  . . . . . . :   QP0ZSPWT        Reset time . . . . . :   16:29:52    
  Library  . . . . . :     QSYS          Elapsed time . . . . :   0064:56:26  
                                                                              
Program start requests:                                                       
  Current number waiting . . . . . . . . . . . . :   0                        
  Average number waiting . . . . . . . . . . . . :   .0                       
  Peak number waiting  . . . . . . . . . . . . . :   0                        
  Average wait time  . . . . . . . . . . . . . . :   00:00:00.0               
  Number accepted  . . . . . . . . . . . . . . . :   849                      
  Number rejected  . . . . . . . . . . . . . . . :   0                        
                                                                              
                                                                              
                                                                              
                                                                              
                                                                              
                                                                              
                                                                        Bottom
```


## Disabling the prestart jobs for server thread jobs QP0ZSPWP or QP0ZSPWT   
After testing if you want to set things back to the way they were before using the prestart threasd jobs, do the following steps.   

- Remove the system level environment variable to use PASE prestart thread jobs.
```
RMVENVVAR ENVVAR('QIBM_PASE_USE_PRESTART_JOBS') LEVEL(*SYS)                           
```                
- Stop the SSH server  
```ENDTCPSVR *SSHD```
- End subsystem QUSRWRK (**assuming no active work is happening**)   
```ENDSBS SBS(QUSRWRK) OPTION(*IMMED)```

- This is optional, but if you want you can disallow multithreading again. *NO was probably the original value on your system.
```
CHGJOBD JOBD(QGPL/QDFTSVR) 
         ALWMLTTHD(*NO)    
```

- Remove the prestart job entries for QP0ZSPWP and QP0ZSPWT thread jobs   
```
RMVPJE SBSD(QUSRWRK)         
       PGM(QSYS/QP0ZSPWP)    
```
```
RMVPJE SBSD(QUSRWRK)         
       PGM(QSYS/QP0ZSPWT)
```

- Start the QUSRWRK subsystem   
```STRSBS SBSD(QUSRWRK)```

- Start the SSH server    
``` STRTCPSVR **SSHD```     

- Do a WRKACTJOB on subsystem QUSRWRK and you should see this:   
```WRKACTJOB SBS(QUSRWRK)```     

Job name: ```QP0ZSPWP``` and type: ```BCI```    
```
Subsystem/Job  User        Type  CPU %  Function        Status
QUSRWRK        QSYS        SBS      .0                   DEQW 
  QP0ZSPWP     QPMGR       BCI      .0  PGM-bash         SELW 
  QP0ZSPWP     QPGMR       BCI      .0  PGM-tmux         SELW 
  QP0ZSPWP     QSECOFR     BCI      .0  PGM-sshd         SELW
```

## Reading Links
Great article on this technique and using prestart jobs with QSH and PASE   
https://techchannel.com/i-can-blog/qp0zspwp-jobs/   

Old Midrange.com thread I found   
https://archive.midrange.com/midrange-l/201507/msg00266.html     

IBM i docs on prestart jobs    
https://www.ibm.com/docs/en/i/7.6.0?topic=subsystems-use-prestart-jobs   

An older article on generating joblogs from background jobs and causing issues with Job Tables   
https://ibm-power-systems.ideas.ibm.com/ideas/IBMI-I-2180   



