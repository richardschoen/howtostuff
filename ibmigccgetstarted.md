# Install and configure gcc on IBM i and create Hello World App

If you ever wanted to get started learning gcc C for creating IBM i PASE apps in less than 5 minutes, then here you go. 

# Installing gcc
Install gcc yum packages from IBM i ACS Open Source Package Management
```
Package list:
gcc-aix
gcc-cplusplus-aix
gcc-cpp-aix
```
# Create and compile hello.c

Open an SSH/bash terminal window and run the following commands
```
PATH=/QOpenSys/pkgs/bin:/QOpenSys/usr/sbin:/QOpenSys/usr/bin
export PATH
cd /
mkdir gccsamples
cd /gccsamples
touch hello.c
```

From your favorite bash or IFS editor, create and edit the hello.c file in ***/gccsamples/hello.c*** and add the following code:
```
#include <stdio.h>
int main(int argc, char *argv[])
{
  printf("Hello World\n");
}
```

Save the source member and then compile with the following commands
```
cd /gccsamples
gcc -o hello hello.c
```

Now run the program by typing the following
```
hello    <press enter>
```

You should see
```
Hello World
```

Congratulations you're on your way to learning gcc

# Links


Let me know if you have a favorite gcc setup link.

