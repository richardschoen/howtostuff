# Basic Installation for WikiJS on IBM i 

I have not written any specific instructions at this point. But here's a basic guide that might work for you.

**Used the Windows install as a base**

https://docs.requarks.io/install/windows

Made sure to have Node 12 loaded and SQLite 3 from IBM Open Source packages. 

Download the Node app file. I used the Windows package and it worked fine since it's Node https://github.com/Requarks/wiki/releases/download/2.3.81/wiki-js-windows.tar.gz


**Upload tar file to root of IFS**

```/wiki-js-windows.tar.gz```

**Run this from bash shell or qp2term or possibly strqsh**

```
mkdir /wikijs
mkdir /wikijs/database
mkdir /wikijs/backups
cd /
tar xzf wiki-js-windows.tar.gz  -C  /wikijs cd /wikijs
```

***Ran this to rebuild SQLite3 driver which I am using***

```npm rebuild sqlite3```

***Copy sample config file to actual config file***

```cp /wikijs/config.sampl.yml  /wikijs/config.yml```

***Edit config.yml file via your favorite PC file editor or WRKLNK I suppose.***

```
Db 
     type: sqlite
     storage: /wikijs/database/database.sqlite
```

***Run WikiJs***

```node server```

***Hit site via browser and config***

```http://systemip:3000```

***Use the rest of the basic WikiJS site instructions***
```
https://docs.requarks.io/guide/intro
```
