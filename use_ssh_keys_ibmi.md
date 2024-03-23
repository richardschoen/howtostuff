# Use SSH Keys to Stop User Password Access
This is a nice article from Andy Youens. Check out the link below  
https://powerwire.eu/use-ssh-keys-to-stop-user-password-access/

Also the script below 

```
#!/QOpenSys/pkgs/bin/bash

# FormaServe IBM i Training

# For full disclaimer see https://www.formaserve.co.uk/examples.php

# © - FormaServe Systems Ltd.  1990 - 2024

# www.FormaServe.co.uk
# powerwire.eu

# Buy me a coffee if this works! - https://Ko-fi.com/andyyouens

echo " "
echo "Correcting SSH user directories & authorities"
echo " "

# prompt the user for a user name
read -p "Enter a user name: " -r user

# Check if string is empty using -z.
if [[ -z "$user" ]]; then
    printf '%s\n' "No user entered!"
    exit 1
else
    # If user is not empty show what the user typed in and run ls -l
    printf "Resetting Directories & Files for %s" "$user"

    # change the current working directory to the user's home directory
    cd /home/$user

    # is there an .ssh directory, if not create
    if ! test -d /home/$user/.ssh; then
        echo ".ssh directory doesnt exist - creating it"
        mkdir /home/$user/.ssh
    fi

    # is there an authorized_keys file, if not create
    if ! test -f /home/$user/.ssh/authorized_keys; then
        echo ".ssh/authorized_keys file doesnt exist - creating it"
        touch /home/$user/.ssh/authorized_keys
    fi

    # change the owner and group of the home directory to the user name
    chown $user /home/$user
    chmod 755  /home/$user
    chown $user /home/$user
    chmod 700  /home/$user/.ssh/
    chmod 600  /home/$user/.ssh/authorized_keys

    echo ' '
    echo 'Finished setting up user directories & authorities'
    echo ' '

fi
```
