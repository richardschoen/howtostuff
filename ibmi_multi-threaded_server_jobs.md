# How to use multi-threaded PASE jobs with subsystem QUSRWRK
I was doing some open source testing on an IBM i system that had 8gb of memoery but .05 core of CPU power. 

I found this scenaro to be pretty slow, so I wanted to see if I could juice up the processing speed by making the PASE thread jobs re-usable. 

For my test scenario I found that this technique speeds up PASE jobs such as the SSH server and running Yum and Python threads. 

This technique may work for other subsystems such as running PHP jobs, but may need to be tweaked. 
