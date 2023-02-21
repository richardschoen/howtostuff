# Use update-alternatives to update default open source apps

## Python version to use

List available Python versions
```
update-alternatives --list python  

/QOpenSys/pkgs/bin/python2.7
/QOpenSys/pkgs/bin/python3.6
/QOpenSys/pkgs/bin/python3.9
```

Set Python 3.9 as default
```
update-alternatives --set python /QOpenSys/pkgs/bin/python3.9  
```

## Node version to use  

List available node versions
```
update-alternatives --list node  

/QOpenSys/pkgs/bin/node
/QOpenSys/pkgs/lib/nodejs10/bin/node
/QOpenSys/pkgs/lib/nodejs12/bin/node
/QOpenSys/pkgs/lib/nodejs14/bin/node
/QOpenSys/pkgs/lib/nodejs16/bin/node
/QOpenSys/pkgs/lib/nodejs18/bin/node
```

Set Node 18 as default
```
update-alternatives --set node /QOpenSys/pkgs/lib/nodejs18/bin/node  
```
