# Register nodejs20 with alternatives as an alternate version of node
When I installed nodejs20 via the yum installer/Open Source Package Management to my IBM i, it didn't register itself as an alternative, so I used the following commands from a ssh/bash shell to set up the alternatives command for nodejs20.

## List the alternatives to see if nodejs20 shows up
Run the following command: ```update-alternatives --list node```
```
/QOpenSys/pkgs/lib/nodejs10/bin/node
/QOpenSys/pkgs/lib/nodejs12/bin/node
/QOpenSys/pkgs/lib/nodejs14/bin/node
/QOpenSys/pkgs/lib/nodejs16/bin/node
/QOpenSys/pkgs/lib/nodejs18/bin/node
```
nodejs20 did not show as an alternative. 

## Install nodejs20 as an alternative along with associated apps (slave apps)
The following command should be copied and pasted to an ssh/bash session as a single command
```
update-alternatives  --install /QOpenSys/pkgs/node node /QOpenSys/pkgs/lib/nodejs20/bin/node 20  --slave  /QOpenSys/pkgs/bin/npm  npm  /QOpenSys/pkgs/lib/nodejs20/bin/npm  --slave /QOpenSys/pkgs/bin/npx  npx  /QOpenSys/pkgs/lib/nodejs20/bin/npx
```
nodejs20 now shows as an alternative when running ```update-alternatives --list node```

```
/QOpenSys/pkgs/lib/nodejs10/bin/node
/QOpenSys/pkgs/lib/nodejs12/bin/node
/QOpenSys/pkgs/lib/nodejs14/bin/node
/QOpenSys/pkgs/lib/nodejs16/bin/node
/QOpenSys/pkgs/lib/nodejs18/bin/node
/QOpenSys/pkgs/lib/nodejs20/bin/node
```

## You can also query to make sure the slave apps are set
Run the following command: ```update-alternatives --query node```    

This should display each node version and it's slave apps (associated apps to the selected node version).   

This example shows node18 and node20 are installed.    
```
Alternative: /QOpenSys/pkgs/lib/nodejs18/bin/node
Priority: 18
Slaves:
 npm /QOpenSys/pkgs/lib/nodejs18/bin/npm
 npx /QOpenSys/pkgs/lib/nodejs18/bin/npx

Alternative: /QOpenSys/pkgs/lib/nodejs20/bin/node
Priority: 20
Slaves:
 npm /QOpenSys/pkgs/lib/nodejs20/bin/npm
 npx /QOpenSys/pkgs/lib/nodejs20/bin/npx
```

## nodejs20 can now be set as an default version of node system wide   
Set nodejs20 as the default node version:   
```update-alternatives  --set node /QOpenSys/pkgs/lib/nodejs20/bin/node```

## Check the current default node version now
Run following command: ```node -v``` and it should show: ```v20.8.1```

## Check the current default npm version now
Run following command: ```npm -v``` and it should show: ```v10.1.0```

## Check the current default npx version now
Run following command: ```npx -v``` and it should show: ```v10.1.0```
