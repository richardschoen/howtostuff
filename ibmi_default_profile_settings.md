# Set up default QSH/PASE/Bash Profile Settings for IBM i Users
In order to find open source packages from the command line in QShell, PASE or Bash without qualifying the path to ```/QOpenSys/pkgs/bin``` you should have the following profile files created in you your home directory on IBM i.

```
.profile - QShell default settings for path info during login or STRQSH.

.bash_profile - Bash default profile for path info during login.

.bashrc - Bach default profile for path info if new bash session started.
```
   
** If you want to skip the steps below and simplify the process of creating SSH/Bash/QSHell profile files for your IBM i users, you should install the QShell on i library (QSHONI) https://www.github.com/richardschoen/qshoni  and use the ```QSHSETPROF``` CL command in the ```QSHONI``` library to make life easy when creating user profile files. Just run QSHSETPROF with the appropriate user name and it creates all the files automatically for you. **


## Listed below are sample file contents you can use to create your own default profiles

### Make sure your IBM i user has a HOME directory 
Run the following command from an SSH terminal to make sure your user has a home directory. Or create from 5250 via the MKDIR command. 

Our examples use ```USERID``` as a sample user name. You should use your own user profile.   

```mkdir /home/USERID```   

It may say the directory already exists or the dir will get created. Either is fine.   

### Create .profile file
Create the file in your ```/home/USERID``` directory. (Where USERID is your user profile) 

File name will be: ```/home/USERID/.profile```

From SSH terminal you can create an empty file via the following:
```
touch /home/USERID/.profile
```
Then you can edit from 5250 via EDTF command or using the nano or vi editors in SSH terminal

```nano /home/USERID/.profile```

Add the following date to the .profile file:
```
PATH=/QOpenSys/pkgs/bin:/QOpenSys/usr/bin:/usr/ccs/bin:/QOpenSys/usr/bin/X11:/usr/sbin:.:/usr/bin:$PATH
```
If using the nano editor, after adding the line to the file you can press ```Control-X```, then press ```Y``` to save the file and press enter again once the file name is displayed. The editor will exit.   

Let's see the file contents by typing the following command:
```
cat /home/USERID/.profile
```
You should see the path echoed to the SSH terminal:
```
PATH=/QOpenSys/pkgs/bin:/QOpenSys/usr/bin:/usr/ccs/bin:/QOpenSys/usr/bin/X11:/usr/sbin:.:/usr/bin:$PATH
```

Now if you do a ```STRQSH``` command from the IBM i, after the shell starts you should be able to type: ```git``` or any other open source command and press Enter and the command line parameters should be shown letting you know that it found the command in the search path. You can type any open source command line option that exists in ```/QOpenSys/pkgs/bin``` and it should work now without qualifying the directory path.   

### Create .bashrc file
Create the file in your ```/home/USERID``` directory. (Where USERID is your user profile) 

File name will be: ```/home/USERID/.bashrc```

From SSH terminal you can create an empty file via the following:
```
touch /home/USERID/.bashrc
```
Then you can edit from 5250 via EDTF command or using the nano or vi editors in SSH terminal

```nano /home/USERID/.bashrc```

Add the following data to the .bashrc file:
```
# Set bash path                                            
export PATH=/QOpenSys/pkgs/bin:/QOpenSys/pkg/lib:$PATH     
```
If using the nano editor, after adding the line to the file you can press ```Control-X```, then press ```Y``` to save the file and press enter again once the file name is displayed.  The editor will exit.   

Let's see the file contents by typing the following command:
```
cat /home/USERID/.bashrc
```
You should see the file data echoed to the SSH terminal.

**Create the .bash_profile file before attempting to test if ```.bashrc``` works.** 

### Create .bash_profile file
Create the file in your ```/home/USERID``` directory. (Where USERID is your user profile) 

File name will be: ```/home/USERID/.bash_profile```

From SSH terminal you can create an empty file via the following:
```
touch /home/USERID/.bash_profile
```
Then you can edit from 5250 via EDTF command or using the nano or vi editors in SSH terminal

```nano /home/USERID/.bash_profile```

Add the following data to the .bash_profile file:
```
export PATH=/QOpenSys/pkgs/bin:/QOpenSys/pkg/lib:$PATH           
# Always execute the .bashrc script when logging in with bash as 
# default profile which will execute .base_profile upon login.   
# If default shell is QSH, .bashrc will execute when user calls  
# the bash command.                                              
# This keeps all actual path logic in the .bashrc file.          
# non-shell user                                                 
if [ -f ~/.bashrc ]; then                                        
 . ~/.bashrc                                                     
fi                                                               
```
If using the nano editor, after adding the line to the file you can press ```Control-X```, then press ```Y``` to save the file and press enter again once the file name is displayed.  The editor will exit.   

Let's see the file contents by typing the following command:
```
cat /home/USERID/.bash_profile
```
You should see the file data echoed to the SSH terminal.

Now if you start a NEW bash or logout and back in if bash is you default shell, all commands in directory ```/QOpenSys/pkgs/bin``` should be available to you. 
