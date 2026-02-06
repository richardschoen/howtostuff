# Compiling SQLRPGLE Programs that Contain Long SQL Lines
I had a need to create some SQL in the IBM ACS ```Run SQL Scripts`` and then wanted to transplant that code into an SQLRPGLE member for processing.   

When I compiled the SQLRPGLE program the SQL preprocessor was giving me odd pre-processor errors. 

As it turns out by default your SQL line width is most likely limited to 80 characters. 

## Resolution
The easiest fix is to make sure your SQL statement lines are less than 80 characters.

-or-

The other option is to tell the compiler to allow longer lines when specifying ```*LVL1``` or ```*LVL2``` for the ```RPGPPOPT``` parameter. 

Here's an example using the PPMINOUTLN parameter in the CRTSQLRPGI command when creating an SQL RPG program: 
```
CRTSQLRPGI OBJ(&L/&N) SRCFILE(&L/&F) COMMIT(*NONE) RPGPPOPT(*LVL1)
    DBGVIEW(*SOURCE) COMPILEOPT('PPMINOUTLN(500)')
```

Apparently you can skip the special compile option if you add a special environment variable into your current job like this:
```
ADDENVVAR ENVVAR(QIBM_RPG_PPSRCFILE_LENGTH) VALUE(500) 
```



