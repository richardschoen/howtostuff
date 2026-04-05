# Copying IBM i Save Files to the IFS and Back
These examples can be used for downloading binary save files directly to the IFS or directly 
to a save file from a web site or from another IFS file.

Data can also be directly copied from a save file to a binary file in the IFS as well.

❗ It turns out that when copying a save file into a library file object directly, the operating system will automatically create the save file object for you. 

These IBM i examples take advantage of the PASE commands: ```cp```, ```rm```, ```wget```, ```curl``` and assume you're working in a PASE terminal session.

In this example we will use an example downloaded IBM i app save file binary file named: ```mylib.savf```

## Download the file directly to the target save file and auto-create the save file if not found.
```
curl https://www.yoursite.net/files/mylib.savf --output /qsys.lib/qgpl.lib/mylib.file
```
-or-
```
wget -O /qsys.lib/qgpl.lib/mylib.file https://www.yoursite.com/files/mylib.bin
```

## Download the file to a temporary IFS location before copying to save file
```
curl https://www.yoursite.com/files/mylib.bin --output /tmp/mylib.savf
```

-or-

```
wget -O /tmp/mylib.savf https://www.yoursite.com/files/mylib.bin
```

## Copy the downloaded file to the target save file via the cp command. 
It should auto-create the target IBM i save file object if it doesn't exist.
If not you can always create the save file first using the CRTSAVF CL command.
```
cp /tmp/mylib.savf /qsys.lib/qgpl.lib/mylib.file
```

-or-

## Copy the downloaded save file to the target save file via CPYFRMSTMF. 
It should auto-create the target IBM i save file object if it doesn't exist.
```
CPYFRMSTMF FROMSTMF('/tmp/mylib.savf')                        
           TOMBR('/qsys.lib/qgpl.lib/mylib.file')            
           MBROPT(*REPLACE)                                    
          CVTDTA(*NONE)
```

## Restore the selected library from save file MYLIB
This example uses RSTLIB, but RSTOBJ and RST commands will also work depending on your save file contents.
```
RSTLIB SAVLIB(MYLIB)     
        DEV(*SAVF)          
        SAVF(QGPL/MYLIB)  
        OPTION(*ALL)        
        MBROPT(*ALL)        
        ALWOBJDIF(*ALL)     
```        

## Copy save file to the IFS via CPYTOSTMF
```
CPYTOSTMF FROMMBR('/qsys.lib/qgpl.lib/mylib.file')    
          TOSTMF('/tmp/mylib.savf')                    
          STMFOPT(*REPLACE)                             
          CVTDTA(*NONE)
```

## Copy save file to the IFS via cp command
```
cp /qsys.lib/qgpl.lib/mylib.file /tmp/mylib.savf
```

## Clean up temporary IFS save files via the (rm) remove command
```
rm /tmp/mylib.savf
```

## Clean up MYLIB temporary save file object from library QGPL via the (rm) remote commands
```
rm /qsys.lib/qgpl.lib/mylib.file
```
