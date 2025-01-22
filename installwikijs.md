# Basic Installation for WikiJS on IBM i 

I have not written any specific instructions at this point. But here's a basic guide that might work for you.

**Use the Windows install as a base download**   
https://docs.requarks.io/install/windows

Made sure to have at least Node 12 loaded and SQLite 3 from IBM Open Source packages.   
```Current version of Node is V22.x.```

Manually download the latet WikiJS app file. I used the Windows package and it worked fine since it's Node based   
https://github.com/Requarks/wiki/releases/latest/download/wiki-js-windows.tar.gz

**Upload tar file to the /tmp off the root of IFS**

```/wiki-js-windows.tar.gz```

**Another option to get the file quickly is to run the wget command from an SSH terminal**
```
wget https://github.com/Requarks/wiki/releases/latest/download/wiki-js-windows.tar.gz -P /tmp
```
**Run this from bash shell, qp2term or possibly strqsh**

```
mkdir /wikijs
mkdir /wikijs/database
mkdir /wikijs/backups
cd /tmp
tar xzf wiki-js-windows.tar.gz  -C  /wikijs
(After tar completes change to wikijs dir)
cd /wikijs
```

***Ran this to rebuild SQLite3 driver binary I am using on IBM i (Only worked for node 12)***

```npm rebuild sqlite3```

***Copy sample config file to actual config file***

```cp /wikijs/config.sample.yml  /wikijs/config.yml```

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
