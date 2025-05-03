# Customize your bash prompt for PASE or Linux command line 
This customizes your bash prompt.  

You can also google for: ```customize bash command prompt```   

Add the following to your ```.bash_profile``` or ```.bashrc``` files.   

This example creates this prompt: ```user1@sys1:~$```   

```
PS1="\[\033[32m\]\u\[\033[0m\]@\[\033[34m\]\h\[\033[0m\]:\w\$ "
export PS1
````

The following example creates this prompt:     
![image](https://github.com/user-attachments/assets/a04a34e4-225b-4a16-b82b-378e5c636336)

```
PS1="\n\[\e[0;32m\]┌─[\[\e[0m\]\[\e[1;33m\]\u\[\e[0m\]\[\e[1;32m\] @ \[\e[0m\]\[\e[1;33m\]\h\[\e[0m\]\[\e[0;32m\]]─[\[\e[0m\]\[\e[1;34m\]\w\[\e[0m\]\[\e[0;32m\]]\[\e[0;32m\]─[\[\e[0m\]\[\e[0;31m\]\!\[\e[0m\]\[\e[0;32m\]]\[\e[0m\]\n\[\e[0;32m\]└─[\[\e[0m\]\[\e[1;37m\]\$\[\e[0m\]\[\e[0;32m\]]› \[\e[0m\]"
```
The [503] is the bash history line.   

![image](https://github.com/user-attachments/assets/eb56f73a-515a-4c25-a4cc-ef06b80288f8)

![image](https://github.com/user-attachments/assets/a37d8485-db22-4ea2-95e8-33048dd6e704)

## Links to customize bash prompts
https://phoenixnap.com/kb/change-bash-prompt-linux    
https://wiki.archlinux.org/title/Bash/Prompt_customization   
