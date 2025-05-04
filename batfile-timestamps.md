# Setting timestamp fields in a Windows .BAT file
Setting timestamps in a Windows batch file seems to be painful. I found the following example code that should work in your .BAT files.   

After creating this script you should have variables available to use for:   
```timestamp``` - yyyymmdd_hhmmss  
```year``` - yyyy  
```month``` - mm  
```day``` - dd  
```hour``` - hh  
```minute``` - mm  
```second``` - ss   

```
REM https://www.jamesparker.dev/how-do-i-get-the-current-date-and-time-in-a-batch-file/
REM @echo off
for /f "delims=" %%a in ('wmic os get localdatetime ^| find "."') do set datetime=%%a
set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set hour=%datetime:~8,2%
set minute=%datetime:~10,2%
set second=%datetime:~12,2%
set timestamp=%year%%month%%day%_%hour%%minute%%second%
echo %timestamp%
```
