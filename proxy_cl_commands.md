# Create safe short versions of system commands
If you want to create safe versions of your favorite CL commands, check out the ```CRTPRXCMD``` CL command to create a CL Proxy Command.

## Examples
These examples are created in QGPL but you probably want to use your own work library.  

Create copy of WRKACTJOB as WAJ
```
CRTPRXCMD CMD(QGPL/WAJ) TGTCMD(QSYS/WRKACTJOB)
```
Create copy of WRKOUTQ as WOQ
```
CRTPRXCMD CMD(QGPL/WOQ) TGTCMD(QSYS/WRKACTJOB)
```
Create copy of WRKSPLF as SPL
```
CRTPRXCMD CMD(QGPL/SPL) TGTCMD(QSYS/WRKSPLF)
```
Create copy of DSPJOB as DJ
```
CRTPRXCMD CMD(QGPL/DJ) TGTCMD(QSYS/DSPJOB)
```
Create copy of SIGNOFF as OFF
```
CRTPRXCMD CMD(QGPL/OFF) TGTCMD(QSYS/SIGNOFF)
```
