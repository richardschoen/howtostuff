# Register nodejs20 with alternatives as an alternate version of node
When I installed nodejs20 via the yum installer/Open Source Package Management to my IBM i, it didn't register itself as an alternative,
so I used the following commands from a ssh/bash shell to set up the alternatives command for nodejs20.

## List the alternatives to see if nodejs20 shows up
Run the following command: ```alternatives --list node```
```
/QOpenSys/pkgs/lib/nodejs10/bin/node
/QOpenSys/pkgs/lib/nodejs12/bin/node
/QOpenSys/pkgs/lib/nodejs14/bin/node
/QOpenSys/pkgs/lib/nodejs16/bin/node
/QOpenSys/pkgs/lib/nodejs18/bin/node
```
nodejs20 did not show as an alternative. 

## Install nodejs20 as an alternative
```
alternatives  --install /QOpenSys/pkgs/node node /QOpenSys/pkgs/lib/nodejs20/bin/node 100
```
nodejs20 now shows as an alternative when running ```alternative --list node```

```
/QOpenSys/pkgs/lib/nodejs10/bin/node
/QOpenSys/pkgs/lib/nodejs12/bin/node
/QOpenSys/pkgs/lib/nodejs14/bin/node
/QOpenSys/pkgs/lib/nodejs16/bin/node
/QOpenSys/pkgs/lib/nodejs18/bin/node
/QOpenSys/pkgs/lib/nodejs20/bin/node
```

## nodejs20 can now be set as an default version of node system wide   
Set nodejs20 as the default node version:   
```alternatives  --set node /QOpenSys/pkgs/lib/nodejs20/bin/node```

## Check the default node version now
Run following command: ```node -v``` and it should show: ```v20.8.1```

## NPM for nodejs20 doesn't seem to be found
After cganging to nodejs20, the npm command does not seem to be found, even though it exists as: ```/QOpenSys/pkgs/lib/nodejs20/bin/npm```

Type: ```npm``` and press enter.   

You will probably see: ```-bash: npm: command not found```

For some reason the shortcut to the nodejs20 version of npm didn't get created correctly. 

Not sure why, but I know how to make it work. 

## Create shortcut link to nodejs20 version of npm
Type the following to put the npm version shipped with nodejs20: 
```
ln -s /QOpenSys/pkgs/lib/nodejs20/bin/npm /QOpenSys/pkgs/bin/npm
```

Now if you run the ```npm``` command you will see the npm options and npm can now be used with nodejs20.
```
-bash-5.2$ npm 
npm <command>

Usage:

npm install        install all the dependencies in your project
npm install <foo>  add the <foo> dependency to your project
npm test           run this project's tests
npm run <foo>      run the script named <foo>
npm <command> -h   quick help on <command>
npm -l             display usage info for all commands
npm help <term>    search for help on <term>
npm help npm       more involved overview

All commands:

    access, adduser, audit, bugs, cache, ci, completion,
    config, dedupe, deprecate, diff, dist-tag, docs, doctor,
    edit, exec, explain, explore, find-dupes, fund, get, help,
    help-search, hook, init, install, install-ci-test,
    install-test, link, ll, login, logout, ls, org, outdated,
    owner, pack, ping, pkg, prefix, profile, prune, publish,
    query, rebuild, repo, restart, root, run-script, search,
    set, shrinkwrap, star, stars, start, stop, team, test,
    token, uninstall, unpublish, unstar, update, version, view,
    whoami

Specify configs in the ini-formatted file:
    /home/RICHARD/.npmrc
or on the command line via: npm <command> --key=value

More configuration info: npm help config
Configuration fields: npm help 7 config

npm@10.1.0 /QOpenSys/pkgs/lib/nodejs20/lib/node_modules/npm
```
