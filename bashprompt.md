# Customize your bash prompt for PASE or Linux command line 
This customizes your bash prompt.  

You can also google for: ```customize bash command prompt```   

Add the following to your ```.bash_profile``` or ```.bashrc``` files.   

```
PS1="\[\033[32m\]\u\[\033[0m\]@\[\033[34m\]\h\[\033[0m\]:\w\$ "
export PS1
````
This example creates this prompt: ```user1@sys1:~$```   


## Links to customize bash prompts
https://phoenixnap.com/kb/change-bash-prompt-linux    
https://wiki.archlinux.org/title/Bash/Prompt_customization   
