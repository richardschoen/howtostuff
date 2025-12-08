# How to use multi-threaded PASE jobs with subsystem QUSRWRK
I was doing some open-source testing on an IBM i system that had 8gb of memory but  only .05 core of CPU power. 

I found this scenaro to be pretty slow, so I wanted to see if I could juice up the processing speed by making the PASE thread jobs re-usable. 

For my test scenario I found that this little known technique seems to speed up PASE jobs such as the SSH server and running Yum and Python threads. 

However it doesn't make the CPU core itself faster. 

This technique may work for other subsystems that use PASE jobs such as running PHP jobs, but may need to be tweaked if those subsystems don't use the QUSRWRK subsystem.

❗I only tested this on a development system with subsystem QUSRWRK. You will want to validate this technique is accurate before rolling it out on a production system. But for me it helped in my testing on a small machine so on larger machines with more memory and CPU your mileage may vary.

## Using VS Code on a low power IBM i CPU
This waqs my experience using the VS Code for i plugin on a low power CPU even once it was tweaked to run PASE threads faster.

❗For better or worse the Code for i plugin is very-chatty. It runs a bunch of startup and checking PASE commands across the wire, so on a slow IBM i machine it connects pretty slowly. I also found that saving a source member using VS Code is pretty slow on a low end .05 core processor. 

Even once I tuned the system I was testing the VS Code file open and saves were taking 15-20 seconds which was painful. 

By contract I was testing my Work with IBM i app and it was taking only 1-4 seconds to upload or download a source member.  The only thing I can attribute this to is the overhead of the VS Code for i plugin.

This will probably not be an issue on larger systems, but for me it made VS Code unusable on the system I was testing with. 

## Initial Setup steps to enable multuthreading for server thread jobs QP0ZSPWP or QP0ZSPWT   
We will be adding prestart jobs to QUSRWRK to speed up multithreaded jobs

- Set the system level environment variable to use PASE prestart thread jobs.
As far as I now this is the only way to utilize this setting so that any PASE job threads use the prestart thread jobs  
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

- Add the prestart job entries for QP0ZSPWP and QP0ZSPWt thread jobs   
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

Now when you use SSH or PASE commands from putty or other terminal, or if you run YUM commands, Python jobs, etc the thread jobs should now get re-used. 

## Check to see if thread jobs are being re-used
See what's happening with prestart jobs.    

- Watch active jobs threads during subsystem startup or once active.  You can actually see all the pre-start jobs start up if you press F5 fast enough.    
```WRKACTJOB SBS(QUSRWRK)```   

- Display active prestart jobs and statistics
These two commands will display prestart job usage.    
✔️ I found all my PASE threads run under: QP0ZSPWT once I enabled the re-use jobs settings.   
```
DSPACTPJ SBS(QUSRWRK) PGM(QSYS/QP0ZSPWT)          
DSPACTPJ SBS(QUSRWRK) PGM(QSYS/QP0ZSPWP) 
```

## Reading Links
https://techchannel.com/i-can-blog/qp0zspwp-jobs/   

https://archive.midrange.com/midrange-l/201507/msg00266.html     

https://www.ibm.com/docs/en/i/7.6.0?topic=subsystems-use-prestart-jobs   

https://ibm-power-systems.ideas.ibm.com/ideas/IBMI-I-2180   



