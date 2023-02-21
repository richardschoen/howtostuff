# Using pip on IBM i to install with compiles
This doc describes some changes required when compiling Python pip modules for V7R4 and above.

## IBM i Prior to V7R4
gcc-6 can be used during installation of Python pip modules that need compilation.

## IBM i V7R4 and above  
gcc-10 needs to be used when installing Python pip modules that need compilation.

Example command line to install pip module:
```
CC='gcc-10 -pthread' CXX='g++-10 -pthread' python3.9 -m pip install <modulename>
```

Make your own directory with the gcc 10 symlinks and add it to the PATH, eg so you don't need the CC= or CXX=
```
mkdir mydir
ln -s /QOpenSys/pkgs/bin/gcc-10 mydir/gcc
ln -s /QOpenSys/pkgs/bin/g++-10 mydir/g++
PATH=$PWD/mydir:$PATH
```
Ideally use your own home directory for the shortcuts and add to path
```
mkdir ~/bin
ln -s /QOpenSys/pkgs/bin/gcc-10 ~/bin/gcc
ln -s /QOpenSys/pkgs/bin/g++-10 ~/bin/g++
PATH=$PWD/~/bin:$PATH
```

